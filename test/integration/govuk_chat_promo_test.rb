require "test_helper"

class GovukChatPromoTest < ActionDispatch::IntegrationTest
  test "renders GOV.UK chat promo for matching content type and base path" do
    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      setup_and_visit_a_page_with_specific_base_path("answer", GovukChatPromoHelper::GOVUK_CHAT_PROMO_BASE_PATHS.first)

      assert page.has_css?(".gem-c-chat-entry")
    end
  end

  def schema_type
    "answer"
  end
end
