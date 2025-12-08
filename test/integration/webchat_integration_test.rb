require "test_helper"

class WebchatIntegrationTest < ActionDispatch::IntegrationTest
  WEBCHAT_PATH = "/government/organisations/hm-passport-office/contact/hm-passport-office-webchat".freeze

  def setup
    @test_webchat = Webchat.new({
      "base_path" => WEBCHAT_PATH,
      "open_url" => "https://webchat.host/open",
      "availability_url" => "https://webchat.host/available",
      "csp_connect_src" => "https://webchat.host",
      "title" => "Test Webchat",
      "more_info_webchat" => "<p>Test info</p>",
      "open_url_redirect" => false,
      "quick_links" => [
        {
          "title" => "Test Quick Link",
          "url" => "/test-link",
        },
      ],
      "parent" => {
        "title" => "Test Parent Organization",
        "base_path" => "/test-parent",
      },
      "description" => "Chat online with Test Organization advisers",
      "schema_name" => "webchat",
    })
    Webchat.stubs(:find).returns(@test_webchat)

    I18n.locale = :en
    I18n.backend.reload!
  end

  def teardown
    Capybara.use_default_driver
    I18n.locale = I18n.default_locale
  end

  test "renders webchat page with correct content" do
    I18n.with_locale(:en) do
      visit WEBCHAT_PATH

      assert_selector "h1", text: "Test Webchat"
      assert_selector "#webchat-title", text: I18n.t("contact.webchat", locale: :en)
      assert page.has_content?("Test info")
    end
  end

  test "renders webchat widget with correct data attributes" do
    visit WEBCHAT_PATH

    assert_selector ".js-webchat[data-availability-url='https://webchat.host/available']"
    assert_selector ".js-webchat[data-open-url='https://webchat.host/open']"
    assert_selector ".js-webchat[data-redirect='false']"
  end

  test "does not render with the single page notification button" do
    visit WEBCHAT_PATH
    assert_no_selector ".single-page-notification-button"
  end

  test "the content security policy is updated for webchat hosts" do
    Capybara.current_driver = :rack_test

    visit WEBCHAT_PATH
    parsed_csp = parse_csp_header(page.response_headers["Content-Security-Policy"])

    assert_includes parsed_csp["connect-src"], "https://webchat.host"
  end

  test "has GA4 tracking on the webchat available link" do
    visit WEBCHAT_PATH
    assert_ga4_tracking_present
  end

private

  def parse_csp_header(csp_header)
    csp_header.split(";")
              .map { |directive| directive.strip.split(" ") }
              .each_with_object({}) { |directive, memo| memo[directive.first] = directive[1..] }
  end

  def assert_ga4_tracking_present
    assert_selector ".js-webchat-advisers-available a[data-module=ga4-link-tracker]", visible: false
    assert_selector ".js-webchat-advisers-available a[data-ga4-link='#{expected_ga4_data}']", visible: false
  end

  def expected_ga4_data
    '{"event_name":"navigation","type":"webchat","text":"Speak to an adviser now"}'
  end
end
