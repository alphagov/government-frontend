require 'test_helper'

module ServiceSignIn
  class CreateNewAccount < ActionDispatch::IntegrationTest
    test "random but valid items do not error" do
      # Create new account is an optional field, so we need to try a few times to
      # get an example with it present.
      path = nil
      until path
        payload = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_type)
        path = payload.dig("details", "create_new_account", "slug")
      end

      stub_request(:get, %r{#{path}})
        .to_return(status: 200, body: payload.to_json, headers: {})

      visit path
    end

    test "page renders correctly" do
      setup_and_visit_create_new_account_page

      assert page.has_css?("title", text: 'Create an account - GOV.UK', visible: false)

      assert_has_component_title "Create an account"

      assert page.has_text?("To use this service, you need to create either a Government Gateway or GOV.UK Verify account. These are used to help fight identity theft.")
      assert page.has_css?('meta[name="robots"][content="noindex, nofollow"]', visible: false)
      refute page.has_css?("#proposition-menu")

      assert page.has_css?(
        '.gem-c-back-link[href="/log-in-file-self-assessment-tax-return/sign-in/choose-sign-in"]',
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
