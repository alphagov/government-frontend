require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "User research banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    survey_url = "https://signup.take-part-in-research.service.gov.uk/"
    survey_url_mappings = {
      "/guidance/check-employment-status-for-tax" => "#{survey_url}?utm_campaign=List_CEST_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=577",
      "/guidance/corporation-tax-trading-and-non-trading" => "#{survey_url}?utm_campaign=List_Corp_Tax_trading_and_non_trading_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=578",
      "/guidance/how-to-fill-in-and-submit-your-vat-return-vat-notice-70012" => "#{survey_url}?utm_campaign=List_Fill_and_submit_VAT_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=579",
      "/guidance/sign-in-to-your-hmrc-business-tax-account" => "#{survey_url}?utm_campaign=List_Sign_in_BTA_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=580",
      "/guidance/rates-of-vat-on-different-goods-and-services" => "#{survey_url}?utm_campaign=List_VAT_on_goods_and_services_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=581",
      "/guidance/claim-a-refund-of-construction-industry-scheme-deductions-if-youre-a-limited-company" => "#{survey_url}?utm_campaign=List_CIS_refund_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=582",
      "/guidance/understanding-off-payroll-working-ir35" => "#{survey_url}?utm_campaign=List_IR35_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=583",
      "/guidance/tax-reliefs-and-allowances-for-businesses-employers-and-the-self-employed" => "#{survey_url}?utm_campaign=List_Tax_reliefs_and_allowances_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=584",
      "/guidance/corporation-tax-selling-or-closing-your-company" => "#{survey_url}?utm_campaign=List_Corp_Tax_selling_or_closing_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=585",
      "/guidance/check-when-you-can-expect-a-reply-from-hmrc" => "#{survey_url}?utm_campaign=List_Expect_a_reply_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=586",
    }.freeze

    pages_of_interest = survey_url_mappings.keys

    pages_of_interest.each do |path|
      guide["base_path"] = path
      stub_content_store_has_item(guide["base_path"], guide.to_json)
      visit guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: survey_url_mappings[path])
    end
  end

  test "User research banner is not displayed on all pages" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Sign up to take part in user research", href: "https://gov.uk")
  end
end
