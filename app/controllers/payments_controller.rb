# frozen_string_literal: true

# ZaloPay payment API – create order, callback (IPN), return URL, status
# Docs: https://developers.zalopay.vn/v2/general/overview.html#tao-don-hang

class PaymentsController < ApplicationController
  allow_unauthenticated_access only: [ :ipn, :return ]
  skip_before_action :verify_authenticity_token, only: [ :ipn, :return ]

  def create
    user = Current.user
    existing = user.subscription
    if existing && user.has_active_subscription?
      return respond_create_error("You already have an active subscription", subscription_id: existing.id)
    end

    plan_id = params[:plan_id].presence
    if plan_id.present?
      plan = Plan.find_by(id: plan_id)
      return respond_create_error("Plan not found") unless plan
      amount = plan.monthly_price.to_i
      duration_days = 30
      if amount <= 0
        create_free_subscription(user, plan)
        return redirect_to subscription_path, notice: "Subscription activated successfully!"
      end
    else
      duration_days = (params[:duration_days] || 30).to_i
      amount = (params[:amount] || 0).to_i
      if amount <= 0
        return respond_create_error("amount must be greater than 0")
      end
    end

    bank_code = params[:bank_code].presence || ZaloPayConfig::DEFAULT_BANK_CODE
    app_trans_id = ZalopayService.generate_app_trans_id("#{user.id}_#{plan_id || 'api'}")
    description = "Subscription payment - #{duration_days} days"
    base_url = request.base_url
    callback_url = "#{base_url}/payments/ipn"
    redirect_url = "#{base_url}/payments/return?app_trans_id=#{app_trans_id}"

    metadata = { service: "subscription", duration_days: duration_days, plan_id: plan_id }
    embed_data = { redirecturl: redirect_url, merchantinfo: metadata.to_json }.to_json
    item = [ { "itemid" => "plan", "itename" => description, "itemprice" => amount, "itemquantity" => 1 } ].to_json

    result = ZalopayService.create_order(
      app_user: user.id.to_s,
      app_trans_id: app_trans_id,
      amount: amount,
      description: description,
      embed_data: embed_data,
      item: item,
      bank_code: bank_code,
      callback_url: callback_url
    )

    if result[:return_code] != 1
      return respond_create_error(result[:return_message].presence || "ZaloPay create order failed")
    end

    user.payments.create!(
      app_trans_id: app_trans_id,
      amount: amount,
      status: :pending,
      return_data: metadata.to_json,
      return_code: result[:return_code].to_s,
      bank_code: bank_code
    )

    render json: {
      message: "Payment order created successfully",
      payment_url: result[:order_url],
      txn_ref: app_trans_id,
      app_trans_id: app_trans_id,
      amount: amount,
      duration_days: duration_days
    }, status: :created
  end

  def ipn
    body = request.raw_post
    payload = begin
      JSON.parse(body)
    rescue JSON::ParserError
      nil
    end

    unless payload && payload["data"].present? && payload["mac"].present?
      return render json: { return_code: 2, return_message: "Invalid callback payload" }, status: :bad_request
    end

    data_str = payload["data"]
    req_mac = payload["mac"]

    unless ZalopayService.verify_callback_mac(data_str, req_mac)
      return render json: { return_code: 2, return_message: "mac not equal" }, status: :bad_request
    end

    data = ZalopayService.parse_callback_data(data_str)
    app_trans_id = data["app_trans_id"]
    amount = data["amount"].to_i
    zp_trans_id = data["zp_trans_id"]&.to_s

    payment = Payment.find_by(app_trans_id: app_trans_id)
    unless payment
      return render json: { return_code: 2, return_message: "Order not found" }, status: :not_found
    end

    if amount != payment.amount
      return render json: { return_code: 2, return_message: "Invalid amount" }, status: :bad_request
    end

    if payment.success?
      return render json: { return_code: 1, return_message: "success" }, status: :ok
    end

    payment.update!(
      callback_data: body,
      zp_trans_id: zp_trans_id,
      return_code: data["return_code"]&.to_s || "1"
    )

    payment.update!(status: :success, paid_at: Time.current)
    create_subscription_from_payment(payment)

    render json: { return_code: 1, return_message: "success" }, status: :ok
  rescue StandardError => e
    Rails.logger.error "PaymentsController#ipn: #{e.message}"
    render json: { return_code: 0, return_message: "Error: #{e.message}" }, status: :internal_server_error
  end

  def return
    app_trans_id = params[:app_trans_id]
    unless app_trans_id.present?
      return render_invalid_return("Missing app_trans_id", "Missing order reference")
    end

    payment = Payment.find_by(app_trans_id: app_trans_id)
    unless payment
      return render_invalid_return("Order not found", "Order not found")
    end

    if payment.pending?
      query = ZalopayService.query_order(app_trans_id)
      if query["return_code"] == 1
        payment.update!(
          status: :success,
          paid_at: Time.current,
          zp_trans_id: query["zp_trans_id"]&.to_s,
          return_code: query["return_code"]&.to_s
        )
        create_subscription_from_payment(payment) if payment.subscription_id.blank?
      elsif query["return_code"] == 2
        payment.update!(status: :failed, return_code: query["return_code"]&.to_s)
      end
    end

    if payment.success?
      if request.format.html? || !request.headers["Accept"]&.include?("application/json")
        redirect_to subscription_path, notice: "Payment successful. Subscription has been activated."
      else
        render_success_return(
          txn_ref: app_trans_id,
          transaction_no: payment.zp_trans_id.to_s,
          amount: payment.amount.to_s,
          response_code: "1"
        )
      end
    else
      render_failed_return(
        txn_ref: app_trans_id,
        response_code: payment.return_code.to_s,
        amount: payment.amount.to_s,
        transaction_no: payment.zp_trans_id.to_s,
        message: "Payment failed or pending"
      )
    end
  rescue StandardError => e
    Rails.logger.error "PaymentsController#return: #{e.message}"
    render json: { success: false, error: e.message, message: "Payment processing error" }, status: :internal_server_error
  end

  def status
    app_trans_id = params[:txn_ref] || params[:app_trans_id]
    payment = Current.user.payments.find_by(app_trans_id: app_trans_id)
    unless payment
      return render json: { error: "Payment not found" }, status: :not_found
    end

    data = {
      txn_ref: payment.app_trans_id,
      app_trans_id: payment.app_trans_id,
      status: payment.status,
      amount: payment.amount,
      transaction_no: payment.zp_trans_id,
      zp_trans_id: payment.zp_trans_id,
      response_code: payment.return_code,
      bank_code: payment.bank_code,
      created_at: payment.created_at&.iso8601,
      paid_at: payment.paid_at&.iso8601,
      subscription_id: payment.subscription_id
    }

    if payment.subscription_id
      sub = Subscription.find_by(id: payment.subscription_id)
      if sub
        data[:subscription] = {
          id: sub.id,
          plan_id: sub.plan_id,
          start_date: sub.subscription_start_date&.iso8601,
          end_date: sub.subscription_end_date&.iso8601
        }
      end
    end

    render json: data, status: :ok
  end

  private

  def create_subscription_from_payment(payment)
    return if payment.subscription_id.present?

    metadata = {}
    if payment.return_data.present?
      begin
        metadata = JSON.parse(payment.return_data)
      rescue JSON::ParserError
        metadata = {}
      end
    end
    metadata = {} unless metadata.is_a?(Hash)
    duration_days = metadata["duration_days"] || metadata[:duration_days] || 30
    plan_id = metadata["plan_id"] || metadata[:plan_id]

    user = payment.user
    start_date = Date.current
    end_date = start_date + duration_days.days

    sub = user.subscription || user.build_subscription
    sub.assign_attributes(
      status: "active",
      subscription_start_date: start_date,
      subscription_end_date: end_date
    )
    sub.plan_id = plan_id.presence || sub.plan_id || Plan.order(:monthly_price).first&.id
    sub.save!
    payment.update!(subscription_id: sub.id)
  end

  def create_free_subscription(user, plan)
    sub = user.subscription || user.build_subscription
    sub.assign_attributes(
      plan_id: plan.id,
      status: "active",
      subscription_start_date: Date.current,
      subscription_end_date: nil
    )
    sub.save!
  end

  def respond_create_error(message, extra = {})
    if request.format.html?
      redirect_to subscription_path, alert: message
    else
      render json: { error: message }.merge(extra), status: :unprocessable_entity
    end
  end

  def render_invalid_return(error_key, message)
    if request.format.json? || request.headers["Accept"]&.include?("application/json")
      render json: { success: false, error: error_key, message: message }, status: :bad_request
    else
      render json: { title: "Payment result", result: "Error", message: message }, status: :bad_request
    end
  end

  def render_success_return(txn_ref:, transaction_no:, amount:, response_code:)
    amt = amount.present? ? amount.to_i : 0
    data = {
      success: true,
      message: "Payment successful",
      txn_ref: txn_ref,
      app_trans_id: txn_ref,
      transaction_no: transaction_no,
      amount: amt,
      response_code: response_code
    }
    if request.format.json? || request.headers["Accept"]&.include?("application/json")
      render json: data, status: :ok
    else
      render json: {
        title: "Payment result",
        result: "Success",
        order_id: txn_ref,
        amount: amt,
        transaction_no: transaction_no,
        response_code: response_code
      }, status: :ok
    end
  end

  def render_failed_return(txn_ref:, response_code:, amount:, transaction_no:, message:)
    amt = amount.present? ? amount.to_i : 0
    data = {
      success: false,
      message: "Payment failed",
      txn_ref: txn_ref,
      response_code: response_code,
      error_message: message
    }
    if request.format.json? || request.headers["Accept"]&.include?("application/json")
      render json: data, status: :ok
    else
      render json: {
        title: "Payment result",
        result: "Error",
        order_id: txn_ref,
        amount: amt,
        transaction_no: transaction_no,
        response_code: response_code,
        message: message
      }, status: :ok
    end
  end
end
