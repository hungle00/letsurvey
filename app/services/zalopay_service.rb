# frozen_string_literal: true

# ZaloPay Service – create order, verify callback, query order status
# Docs: https://developers.zalopay.vn/v2/general/overview.html#tao-don-hang

require "openssl"
require "net/http"
require "json"

class ZalopayService
  VIETNAM_TZ = ActiveSupport::TimeZone["Asia/Ho_Chi_Minh"]

  class << self
    def compute_hmac_sha256(key, data)
      OpenSSL::HMAC.hexdigest("SHA256", key.to_s, data.to_s)
    end

    def app_trans_id_prefix
      Time.current.in_time_zone(VIETNAM_TZ).strftime("%y%m%d")
    end

    def generate_app_trans_id(uid = nil)
      uid ||= "#{Time.current.to_i}_#{SecureRandom.hex(4)}"
      "#{app_trans_id_prefix}_#{uid}"
    end

    def create_order(
      app_user:,
      app_trans_id:,
      amount:,
      description:,
      embed_data:,
      item:,
      bank_code: nil,
      callback_url: nil
    )
      app_id = ZaloPayConfig::APP_ID
      key1 = ZaloPayConfig::KEY1
      url = URI(ZaloPayConfig::CREATE_ORDER_URL)
      bank_code = bank_code.presence || ZaloPayConfig::DEFAULT_BANK_CODE

      app_time = (Time.current.in_time_zone(VIETNAM_TZ).to_f * 1000).to_i
      embed_str = embed_data.is_a?(String) ? embed_data : embed_data.to_json
      item_str = item.is_a?(String) ? item : item.to_json

      hmac_data = "#{app_id}|#{app_trans_id}|#{app_user}|#{amount}|#{app_time}|#{embed_str}|#{item_str}"
      mac = compute_hmac_sha256(key1, hmac_data)

      form = {
        "app_id" => app_id,
        "app_user" => app_user,
        "app_trans_id" => app_trans_id,
        "app_time" => app_time,
        "amount" => amount,
        "description" => description,
        "embed_data" => embed_str,
        "item" => item_str,
        "bank_code" => bank_code,
        "mac" => mac
      }
      form["callback_url"] = callback_url if callback_url.present?

      begin
        res = Net::HTTP.post_form(url, form)
        result = JSON.parse(res.body)
        {
          return_code: result["return_code"],
          return_message: result["return_message"].to_s,
          order_url: result["order_url"].to_s,
          sub_return_code: result["sub_return_code"],
          sub_return_message: result["sub_return_message"].to_s
        }
      rescue StandardError => e
        {
          return_code: 2,
          return_message: e.message,
          order_url: "",
          sub_return_code: nil,
          sub_return_message: e.message
        }
      end
    end

    def verify_callback_mac(data_str, req_mac)
      return false if data_str.blank? || req_mac.blank?
      mac = compute_hmac_sha256(ZaloPayConfig::KEY2, data_str)
      ActiveSupport::SecurityUtils.secure_compare(mac, req_mac)
    end

    def parse_callback_data(data_str)
      JSON.parse(data_str.to_s)
    rescue JSON::ParserError, TypeError
      {}
    end

    def query_order(app_trans_id)
      app_id = ZaloPayConfig::APP_ID
      key1 = ZaloPayConfig::KEY1
      url = URI(ZaloPayConfig::QUERY_ORDER_URL)

      data = "#{app_id}|#{app_trans_id}|#{key1}"
      mac = compute_hmac_sha256(key1, data)
      form = { "app_id" => app_id, "app_trans_id" => app_trans_id, "mac" => mac }

      begin
        res = Net::HTTP.post_form(url, form)
        JSON.parse(res.body)
      rescue StandardError => e
        { "return_code" => 2, "return_message" => e.message, "zp_trans_id" => nil, "amount" => nil }
      end
    end
  end
end
