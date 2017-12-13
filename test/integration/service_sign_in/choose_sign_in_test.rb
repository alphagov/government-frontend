require 'test_helper'

module ServiceSignIn
  class ChooseSignInTest < ActionDispatch::IntegrationTest
    test "random but valid items do not error" do
      schema = GovukSchemas::Schema.find(frontend_schema: schema_type)
      random_example = GovukSchemas::RandomExample.new(schema: schema)

      payload = random_example.merge_and_validate(document_type: schema_type)
      path = payload["details"]["choose_sign_in"]["slug"]

      stub_request(:get, %r{#{path}})
        .to_return(status: 200, body: payload.to_json, headers: {})

      visit path
    end

    test "page renders correctly" do
      setup_and_visit_choose_sign_in_page

      assert page.has_css?("title", text: 'Prove your identity to continue - GOV.UK', visible: false)
      assert page.has_css?('meta[name="robots"][content="noindex, nofollow"]', visible: false)
      refute page.has_css?(shared_component_selector('breadcrumbs'))
      refute page.has_css?(shared_component_selector('government_navigation'))

      assert page.has_css?('.app-c-back-link[href="/log-in-file-self-assessment-tax-return"]', text: 'Back')
      assert page.has_css?('form[data-module="track-radio-group"]')

      within "form" do
        within ".app-c-fieldset" do
          within ".app-c-fieldset__legend" do
            within shared_component_selector('title') do
              assert page.has_text?("Prove your identity to continue")
            end
          end

          within shared_component_selector('govspeak') do
            assert page.has_text?("You can't file online until you've activated Government Gateway account using your Unique Taxpayer Reference(UTR).")
          end

          within ".app-c-radio:first-of-type" do
            assert page.has_css?(".app-c-radio__label__text", text: "Use Government Gateway")
            assert page.has_css?(".app-c-radio__label__hint", text: "You’ll have a user ID if you’ve signed up to do things like file your Self Assessment tax return online.")
          end

          within ".app-c-radio:nth-of-type(2)" do
            assert page.has_css?(".app-c-radio__label__text", text: "Use GOV.UK Verify")
            assert page.has_css?(".app-c-radio__label__hint", text: "You’ll have an account if you’ve already proved your identity with either Barclays, CitizenSafe, Digidentity, Experian, Post Office, Royal Mail or SecureIdentity.")
          end

          assert page.has_css?(".app-c-radio__block-text", text: "or")

          within ".app-c-radio:last-of-type" do
            assert page.has_css?(".app-c-radio__label__text", text: "Create an account")
          end
        end
        assert page.has_css?(shared_component_selector('button'), text: "Continue")
      end
    end

    test "renders errors correctly" do
      setup_and_visit_choose_sign_in_page

      page.execute_script('document.querySelector(\'form\').submit()')

      assert page.has_css?(".app-c-error-summary")
      assert page.has_css?(".app-c-error-summary__title", text: 'You haven’t selected an option')
      assert page.has_css?(".app-c-error-summary__link[href='#option-0']", text: 'Please select an option')

      # Make sure the id is the same as the link href so that they'll link together properly.
      assert page.has_css?(".app-c-radio__input[id='option-0'][value='use-government-gateway']", visible: false)

      assert page.has_css?(".app-c-error-message", text: 'Please select an option')
    end

    def setup_and_visit_choose_sign_in_page
      content_item = get_content_example("service_sign_in")
      path = content_item["base_path"] + "/choose-sign-in"
      content_store_has_item(path, content_item.to_json)
      visit(path)
    end

    def schema_type
      "service_sign_in"
    end
  end
end
