require 'test_helper'

module ServiceSignIn
  class CreateNewAccount < ActionDispatch::IntegrationTest
    test "random but valid items do not error" do
      schema = GovukSchemas::Schema.find(frontend_schema: schema_type)
      random_example = GovukSchemas::RandomExample.new(schema: schema)

      payload = random_example.merge_and_validate(document_type: schema_type)
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
