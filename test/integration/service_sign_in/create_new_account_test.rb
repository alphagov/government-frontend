require 'test_helper'

module ServiceSignIn
  class CreateNewAccount < ActionDispatch::IntegrationTest
    test "random but valid items do not error" do
      schema = GovukSchemas::Schema.find(frontend_schema: schema_type)
      random_example = GovukSchemas::RandomExample.new(schema: schema)

      # Create new account is an optional field, so we need to try a few times to
      # get an example with it present.
      payload = nil
      loop do
        payload = random_example.payload
        break if payload["details"]["create_new_account"].present?
      end

      path = payload["details"]["create_new_account"]["slug"]

      stub_request(:get, %r{#{path}})
        .to_return(status: 200, body: payload.to_json, headers: {})

      visit path
    end

    test "page renders correctly" do
      setup_and_visit_create_new_account_page

      assert page.has_css?("title", text: 'Create an account - GOV.UK', visible: false)
      within shared_component_selector('title') do
        assert page.has_text?("Create an account")
      end

      assert_has_component_govspeak("<p>To use this service, you need to create either a Government Gateway or GOV.UK Verify account. These are used to help fight identity theft.</p><p>Once you have an account, you can use it to access other government services online.</p><h2 id='choose-a-way-to-prove-your-identity'>Choose a way to prove your identity</h2><h3 id='government-gateway'>Government Gateway</h3><p>Registering with Government Gateway usually takes about 10 minutes. It works best if you have:</p><ul><li>your National Insurance number</li><li>a recent payslip or P60 or a valid UK passport</li></ul><p><a rel='external' href='https://www.tax.service.gov.uk/check-income-tax/start-government-gateway?_ga=2.114080007.145612230.1512381177-373904926.1473694521'>Create a Government Gateway account.</a></p><h3 id='govuk-verify'>GOV.UK Verify</h3><p>Registering with GOV.UK Verify usually takes about 15 minutes. It works best if you have:</p><ul><li>a UK address</li><li>a valid passport or photocard driving licence</li></ul><p><a rel='external' href='https://www.tax.service.gov.uk/check-income-tax/start-verify?_ga=2.114080007.145612230.1512381177-373904926.1473694521'>Create a GOV.UK Verify account.</a></p><p>A certified company will double check your identity when you register with GOV.UK Verify. They’ve all met security standards set by government.</p><h2 id='personal-tax-account'>Personal tax account</h2><p>Signing in for the first time will activate your personal tax account. You can use this to check your HMRC records and manage your other details.</p>")

      assert page.has_css?('meta[name="robots"][content="noindex, nofollow"]', visible: false)
      refute page.has_css?(shared_component_selector('breadcrumbs'))
      refute page.has_css?(shared_component_selector('government_navigation'))

      assert page.has_css?(
        '.app-c-back-link[href="/log-in-file-self-assessment-tax-return/sign-in/choose-sign-in"]',
        text: 'Back'
      )
    end

    def setup_and_visit_create_new_account_page
      content_item = get_content_example("service_sign_in")
      path = content_item["base_path"] + "/create-new-account"
      content_store_has_item(path, content_item.to_json)
      visit(path)
    end

    def schema_type
      "service_sign_in"
    end
  end
end
