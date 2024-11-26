require "test_helper"

class GovukChatPromoTest < ActionDispatch::IntegrationTest
  test "renders GOV.UK chat promo for matching content type and requested path" do
    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      setup_and_visit_a_page_with_specific_base_path("guide", "/contracted-out")

      assert page.has_css?(".gem-c-chat-entry")
    end
  end

  test "renders GOV.UK chat promo when requested path contains multiple parts" do
    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      setup_and_visit_a_page_with_specific_base_path("guide", "/contracted-out/how-contracting-out-affects-your-amount")

      assert page.has_css?(".gem-c-chat-entry")
    end
  end

  test "does not render GOV.UK chat promo when base path is in allow list but actual path is not" do
    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      setup_and_visit_a_page_with_specific_base_path("guide", "/contracted-out/check-if-you-were-contracted-out")

      assert_not page.has_css?(".gem-c-chat-entry")
    end
  end

  def schema_type
    "guide"
  end
end
