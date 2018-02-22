require 'test_helper'

class ServiceSignInPresenterTest
  class VerifyHubTrialCreateNewAccount < ActiveSupport::TestCase
    GOV_GATE_URL_FOR_COMPANY_CAR = "https://www.tax.service.gov.uk/paye/company-car/start-government-gateway".freeze
    GOV_GATE_URL_FOR_INCOME_TAX = "https://www.tax.service.gov.uk/check-income-tax/start-government-gateway?_ga=2.114080007.145612230.1512381177-373904926.147".freeze
    VERIFY_URL_FOR_COMPANY_CAR = "https://www.tax.service.gov.uk/paye/company-car/start-verify".freeze
    VERIFY_URL_FOR_INCOME_TAX = "https://www.tax.service.gov.uk/check-income-tax/start-verify?_ga=2.114080007.145612230.1512381177-373904926.1473694521".freeze

    def schema_name
      "service_sign_in"
    end

    def setup
      @presented_item = present_example(schema_item)
      @create_new_account = schema_item["details"]["create_new_account"]
    end

    def present_example(example)
      ServiceSignIn::VerifyHubTrialCreateNewAccountPresenter.new(example)
    end

    def schema_item
      @schema_item ||= govuk_content_schema_example(schema_name, schema_name)
    end

    def parent_slug
      schema_item['details']['choose_sign_in']['slug']
    end

    test 'presents the schema_name' do
      assert_equal schema_item['schema_name'], @presented_item.schema_name
    end

    test 'presents correct url for gateway sign up - update company car details' do
      schema_item['base_path'] = "update-company-car-details/sign-in"
      assert_equal GOV_GATE_URL_FOR_COMPANY_CAR, @presented_item.govenment_gateway_url
    end

    test 'presents correct url for verify sign up - update company car details' do
      schema_item['base_path'] = "update-company-car-details/sign-in"
      assert_equal VERIFY_URL_FOR_COMPANY_CAR, @presented_item.verify_url
    end

    test 'presents correct url for gateway sign up - check income tax' do
      schema_item['base_path'] = "check-income-tax-current-year/sign-in"
      assert_equal GOV_GATE_URL_FOR_INCOME_TAX, @presented_item.govenment_gateway_url
    end

    test 'presents correct url for verify sign up - check income tax' do
      schema_item['base_path'] = "check-income-tax-current-year/sign-in"
      assert_equal VERIFY_URL_FOR_INCOME_TAX, @presented_item.verify_url
    end

    test 'presents the back_link' do
      assert_equal "#{schema_item['base_path']}/#{parent_slug}", @presented_item.back_link
    end
  end
end
