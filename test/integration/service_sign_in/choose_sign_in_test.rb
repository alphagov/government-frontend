require 'test_helper'

module ServiceSignIn
  class ChooseSignInTest < ActionDispatch::IntegrationTest
    test "random but valid items do not error" do
      payload = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_type)
      path = payload["details"]["choose_sign_in"]["slug"]

      stub_request(:get, %r{#{path}})
        .to_return(status: 200, body: payload.to_json, headers: {})

      visit path
    end

    test "page renders correctly" do
      setup_and_visit_choose_sign_in_page("service_sign_in", "/choose-sign-in")

      assert page.has_css?("title", text: 'Prove your identity to continue - GOV.UK', visible: false)
      assert page.has_css?('meta[name="robots"][content="noindex, nofollow"]', visible: false)
      refute page.has_css?("#proposition-menu")

      assert page.has_css?('.gem-c-back-link[href="/log-in-file-self-assessment-tax-return"]', text: 'Back')
      assert page.has_css?('form[data-module="track-radio-group"]')
      assert page.has_css?("form[data-tracking-code='UA-xxxxxx']")
      assert page.has_css?("form[data-tracking-domain='tax.service.gov.uk']")
      assert page.has_css?("form[data-tracking-name='somethingClicky']")

      within "#content form" do
        within ".gem-c-fieldset" do
          within ".gem-c-fieldset__legend" do
            assert_has_component_title "Prove your identity to continue"
          end

          within ".gem-c-govspeak" do
            assert page.has_text?("You can't file online until you've activated Government Gateway account using your Unique Taxpayer Reference(UTR).")
          end

          assert page.has_css?(".gem-c-radio .govuk-label", text: "Use Government Gateway")
          assert page.has_css?(".gem-c-radio .govuk-hint", text: "You’ll have a user ID if you’ve signed up to do things like file your Self Assessment tax return online.")

          assert page.has_css?(".gem-c-radio .govuk-label", text: "Use GOV.UK Verify")
          assert page.has_css?(".gem-c-radio .govuk-hint", text: "You’ll have an account if you’ve already proved your identity with either Barclays, CitizenSafe, Digidentity, Experian, Post Office, Royal Mail or SecureIdentity.")

          assert page.has_css?(".govuk-radios__divider", text: "or")

          assert page.has_css?(".gem-c-radio .govuk-label", text: "Create an account")
        end

        assert page.has_css?(".gem-c-button", text: "Continue")
      end
    end

    test "renders errors correctly" do
      setup_and_visit_choose_sign_in_page("service_sign_in", "/choose-sign-in")

      click_on 'Continue'

      assert page.has_css?(".govuk-error-summary")
      assert page.has_css?(".govuk-error-summary__title", text: 'You haven’t selected an option')
      assert page.has_css?("ul li a:first-of-type[href='#option-0']", text: 'Please select an option')

      # Make sure the id is the same as the link href so that they'll link together properly.
      assert page.has_css?(".gem-c-radio input[id='option-0'][value='use-government-gateway']", visible: false)

      assert page.has_css?(".app-c-error-message", text: 'Please select an option')
    end

    test "page less options without an or divider" do
      setup_and_visit_choose_sign_in_page("view_driving_licence", "/choose-sign-in")

      assert page.has_css?(".gem-c-radio .govuk-label", text: "Use your driving licence and National Insurance number")
      assert page.has_css?(".gem-c-radio .govuk-hint", text: "Your driving licence must have been issued in England, Scotland or Wales.")

      assert page.has_css?(".gem-c-radio .govuk-label", text: "Use GOV.UK Verify")
      assert page.has_css?(".gem-c-radio .govuk-hint", text: "You can use an existing identity account or create a new one. It usually takes about 5 minutes to create an account.")

      refute page.has_css?(".govuk-radios__divider", text: "or")
    end

    test "page renders welsh correctly" do
      setup_and_visit_choose_sign_in_page("welsh", "/dewiswch-lofnodi")

      assert page.has_css?("title", text: 'Profwch pwy ydych chi i fwrw ymlaen - GOV.UK', visible: false)
      assert page.has_css?('.gem-c-back-link', text: 'Yn ôl')

      within "#content form" do
        within ".gem-c-fieldset" do
          within ".gem-c-fieldset__legend" do
            assert_has_component_title "Profwch pwy ydych chi i fwrw ymlaen"
          end

          within ".gem-c-govspeak" do
            assert page.has_text?("Os ydych chi’n ffeilio ar-lein am y tro cyntaf, bydd angen i chi gofrestru ar gyfer Hunanasesiad yn gyntaf.")
          end

          assert page.has_css?(".gem-c-radio .govuk-label", text: "Defnyddio Porth y Llywodraeth")
          assert page.has_css?(".gem-c-radio .govuk-hint", text: "Bydd gennych chi ID defnyddiwr os ydych chi wedi cofrestru ar gyfer Hunanasesiad neu wedi ffeilio ffurflen dreth ar-lein yn y gorffennol.")

          assert page.has_css?(".gem-c-radio .govuk-label", text: "Defnyddio GOV.UK Verify")
          assert page.has_css?(".gem-c-radio .govuk-hint", text: "Bydd gennych chi gyfrif os ydych chi wedi profi'n barod pwy ydych chi naill ai gyda Barclays, CitizenSafe, Digidentity, Experian, Swyddfa'r Post, y Post Brenhinol neu SecureIdentity.")

          assert page.has_css?(".govuk-radios__divider", text: "neu")

          within ".gem-c-radio:last-of-type" do
            assert page.has_css?(".gem-c-radio .govuk-label", text: "Cofrestru ar gyfer Hunanasesiad")
          end
        end

        assert page.has_css?(".gem-c-button", text: "Bwrw ymlaen")
      end
    end

    def setup_and_visit_choose_sign_in_page(example_name, example_path)
      content_item = get_content_example(example_name)
      content_path = content_item["base_path"] + example_path
      content_store_has_item(content_path, content_item.to_json)
      visit(content_path)
    end

    def schema_type
      "service_sign_in"
    end
  end
end
