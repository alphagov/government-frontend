require "test_helper"

class HmpoWebchatTest < ActionDispatch::IntegrationTest
  test "does not render with the single page notification button" do
    visit("/government/organisations/hm-passport-office/contact/hm-passport-office-webchat")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end

  # Ideally this would be tested at the Controller level however the
  # ActionController::TestCase does not integrate with CSP, so tested at a level
  # which does.
  test "the content security policy is updated for webchat hosts" do
    # Need to use Rack as Selenium, the default driver, doesn't provide header access
    Capybara.current_driver = :rack_test

    webchat = Webchat.new({
      "base_path" => "/content",
      "open_url" => "https://webchat.host/open",
      "availability_url" => "https://webchat.host/avaiable",
      "csp_connect_src" => "https://webchat.host",
    })

    Webchat.stubs(:find).returns(webchat)

    visit("/government/organisations/hm-passport-office/contact/hm-passport-office-webchat")
    parsed_csp = page.response_headers["Content-Security-Policy"]
                     .split(";")
                     .map { |directive| directive.strip.split(" ") }
                     .each_with_object({}) { |directive, memo| memo[directive.first] = directive[1..] }

    assert_includes parsed_csp["connect-src"], "https://webchat.host"

    # reset back to default driver
    Capybara.use_default_driver
  end

  test "has GA4 tracking on the webchat available link" do
    visit("/government/organisations/hm-passport-office/contact/hm-passport-office-webchat")

    assert_selector ".js-webchat-advisers-available a[data-module=ga4-link-tracker]"
    assert_selector ".js-webchat-advisers-available a[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"webchat\",\"text\":\"Speak to an adviser now\"}']"
  end

  test "has English text for GA4 on the webchat available link" do
    visit("/government/organisations/hm-passport-office/contact/hm-passport-office-webchat")

    assert_selector ".js-webchat-advisers-available a[data-module=ga4-link-tracker]"
    assert_selector ".js-webchat-advisers-available a[data-ga4-link='{\"event_name\":\"navigation\",\"type\":\"webchat\",\"text\":\"Speak to an adviser now\"}']"
  end
end
