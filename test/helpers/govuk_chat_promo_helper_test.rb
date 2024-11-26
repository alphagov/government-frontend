require "test_helper"

class GovukChatPromoHelperTest < ActionView::TestCase
  test "show_govuk_chat_promo? when configuration disabled" do
    assert_not show_govuk_chat_promo?(GOVUK_CHAT_PROMO_PATHS.first)
  end

  test "show_govuk_chat_promo? when base_path not in configuration" do
    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      assert_not show_govuk_chat_promo?("/non-matching-path")
    end
  end

  test "show_govuk_chat_promo? when base_path is in configuration" do
    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      assert show_govuk_chat_promo?(GOVUK_CHAT_PROMO_PATHS.first)
    end
  end
end
