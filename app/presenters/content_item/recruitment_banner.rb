module ContentItem
  module RecruitmentBanner
    SURVEY_URL = "https://signup.take-part-in-research.service.gov.uk/".freeze
    SURVEY_URL_MAPPINGS = {
      "/guidance/check-employment-status-for-tax" => "#{SURVEY_URL}?utm_campaign=List_CEST_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=577",
      "/guidance/corporation-tax-trading-and-non-trading" => "#{SURVEY_URL}?utm_campaign=List_Corp_Tax_trading_and_non_trading_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=578",
      "/guidance/how-to-fill-in-and-submit-your-vat-return-vat-notice-70012" => "#{SURVEY_URL}?utm_campaign=List_Fill_and_submit_VAT_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=579",
      "/guidance/sign-in-to-your-hmrc-business-tax-account" => "#{SURVEY_URL}?utm_campaign=List_Sign_in_BTA_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=580",
      "/guidance/rates-of-vat-on-different-goods-and-services" => "#{SURVEY_URL}?utm_campaign=List_VAT_on_goods_and_services_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=581",
      "/guidance/claim-a-refund-of-construction-industry-scheme-deductions-if-youre-a-limited-company" => "#{SURVEY_URL}?utm_campaign=List_CIS_refund_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=582",
      "/guidance/understanding-off-payroll-working-ir35" => "#{SURVEY_URL}?utm_campaign=List_IR35_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=583",
      "/guidance/tax-reliefs-and-allowances-for-businesses-employers-and-the-self-employed" => "#{SURVEY_URL}?utm_campaign=List_Tax_reliefs_and_allowances_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=584",
      "/guidance/corporation-tax-selling-or-closing-your-company" => "#{SURVEY_URL}?utm_campaign=List_Corp_Tax_selling_or_closing_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=585",
      "/guidance/check-when-you-can-expect-a-reply-from-hmrc" => "#{SURVEY_URL}?utm_campaign=List_Expect_a_reply_TAD&utm_source=Other&utm_medium=gov.uk&t=HMRC&id=586",
    }.freeze

    def recruitment_survey_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
