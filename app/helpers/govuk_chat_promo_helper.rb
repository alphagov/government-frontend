module GovukChatPromoHelper
  GOVUK_CHAT_PROMO_BASE_PATHS = %w[
    /business-support-helpline
    /company-tax-returns
    /corporation-tax
    /pay-corporation-tax
    /pay-vat
    /search-for-trademark
    /set-up-business
    /submit-vat-return
    /write-business-plan
  ].freeze

  def show_govuk_chat_promo?(base_path)
    ENV["GOVUK_CHAT_PROMO_ENABLED"] == "true" && GOVUK_CHAT_PROMO_BASE_PATHS.include?(base_path)
  end
end
