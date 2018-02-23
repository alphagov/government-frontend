# Trial new start page payout for update company car details and income tax services (by verify hub improvements team)
# Due for teardown/review on 8th March 2018 - Jira card HUB-39

module ServiceSignIn
  class VerifyHubTrialCreateNewAccountPresenter < ContentItemPresenter
    include ServiceSignIn::Paths

    GOV_GATE_URL_FOR_COMPANY_CAR = "https://www.tax.service.gov.uk/paye/company-car/start-government-gateway".freeze
    GOV_GATE_URL_FOR_INCOME_TAX = "https://www.tax.service.gov.uk/check-income-tax/start-government-gateway?_ga=2.114080007.145612230.1512381177-373904926.147".freeze
    VERIFY_URL_FOR_COMPANY_CAR = "https://www.tax.service.gov.uk/paye/company-car/start-verify".freeze
    VERIFY_URL_FOR_INCOME_TAX = "https://www.tax.service.gov.uk/check-income-tax/start-verify?_ga=2.114080007.145612230.1512381177-373904926.1473694521".freeze

    def page_type
      "create_new_account"
    end

    def partial_type
      "verify_hub_trial_create_new_account"
    end

    def govenment_gateway_url
      return GOV_GATE_URL_FOR_COMPANY_CAR if content_item['base_path'].include?("update-company-car-details")
      return GOV_GATE_URL_FOR_INCOME_TAX if content_item['base_path'].include?("check-income-tax-current-year")
    end

    def verify_url
      return VERIFY_URL_FOR_COMPANY_CAR if content_item['base_path'].include?("update-company-car-details")
      return VERIFY_URL_FOR_INCOME_TAX if content_item['base_path'].include?("check-income-tax-current-year")
    end

    def back_link
      "#{content_item['base_path']}/#{parent_slug}"
    end

  private

    def parent_slug
      content_item["details"]["choose_sign_in"]["slug"]
    end

    def create_new_account
      content_item["details"]["create_new_account"]
    end
  end
end
