class VnpayService
  def initialize(order)
    @order = order
  end

  def create_payment_url
    # Implement logic to create payment URL using VNPAY API
    # This typically involves generating a secure hash and constructing the URL with necessary parameters
    vnp_amount = (@order.amount * 100).to_i # Convert to smallest currency unit
    create_date = Time.current.strftime("%Y%m%d%H%M%S")

    vnp_params = {
      'vnp_Version': VNPayConfig.VNP_VERSION,
      'vnp_Command': VNPayConfig.VNP_COMMAND,
      'vnp_TmnCode': VNPayConfig.VNP_TMN_CODE,
      'vnp_Amount': vnp_amount.to_s,
      'vnp_CurrCode': VNPayConfig.VNP_CURR_CODE,
      'vnp_TxnRef': @order.id.to_s,
      'vnp_OrderInfo': @order.description,
      'vnp_OrderType': VNPayConfig.VNP_ORDER_TYPE,
      'vnp_Locale': VNPayConfig.VNP_LOCALE,
      'vnp_ReturnUrl': @order.return_url,
      'vnp_IpAddr': @order.ip_addr,
      'vnp_CreateDate': create_date
    }

    vnp_params["vnp_BankCode"] = @order.bank_code if @order.bank_code.present?

    query_string = vnp_params.map { |k, v| "#{k}=#{v}" }.join("&")
    payment_url = "#{VNPayConfig.VNP_URL}?#{query_string}"

    payment_url
  end
end

class VNPayConfig
  VNP_VERSION = "2.1.0"
  VNP_COMMAND = "pay"
  VNP_TMN_CODE = "YOUR_TMN_CODE"
  VNP_CURR_CODE = "VND"
  VNP_ORDER_TYPE = "other"
  VNP_LOCALE = "vn"
  VNP_HASH_SECRET = ""
  VNP_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html"
end
