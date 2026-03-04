# ZaloPay Gateway configuration
# Docs: https://developers.zalopay.vn/v2/general/overview.html#tao-don-hang
# Set APP_ID, KEY1, KEY2 from ZaloPay; use ENV in production.

module ZaloPayConfig
  APP_ID   = ENV.fetch("ZALOPAY_APP_ID", "2553").to_i
  KEY1     = ENV.fetch("ZALOPAY_KEY1", "PcY4iZIKFCIdgZvA6ueMcMHHUbRLYjPL")
  KEY2     = ENV.fetch("ZALOPAY_KEY2", "kLtgPl8HHhfvMuDHPwKfgfsY4Ydm9eIz")
  CREATE_ORDER_URL = ENV.fetch("ZALOPAY_CREATE_ORDER_URL", "https://sb-openapi.zalopay.vn/v2/create")
  QUERY_ORDER_URL = ENV.fetch("ZALOPAY_QUERY_ORDER_URL", "https://sb-openapi.zalopay.vn/v2/query")
  DEFAULT_BANK_CODE = "zalopayapp"
end
