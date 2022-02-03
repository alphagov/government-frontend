require "component_test_helper"

class SinglePageNotificationButtonTest < ComponentTestCase
  def component_name
    "single_page_notification_button"
  end

  test "does not render without a base path" do
    assert_empty render_component({})
  end

  test "renders with the correct markup if base path is present" do
    render_component({ base_path: "/the-current-page" })
    assert_select "form.app-c-single-page-notification-button"
    assert_select "input[type='hidden']", value: "/the-current-page"
    assert_select ".app-c-single-page-notification-button button.app-c-single-page-notification-button__submit[type='submit']"
  end

  test "shows 'Get emails about this page' by default" do
    render_component({ base_path: "/the-current-page" })
    assert_select ".app-c-single-page-notification-button", text: "Get emails about this page"
  end

  test "shows 'Stop getting emails about this page' if already_subscribed is true" do
    render_component({ base_path: "/the-current-page", already_subscribed: true })
    assert_select ".app-c-single-page-notification-button", text: "Stop getting emails about this page"
  end

  test "has data attributes if data_attributes is specified" do
    render_component({ base_path: "/the-current-page", data_attributes: { custom_attribute: "kaboom!" } })
    assert_select ".app-c-single-page-notification-button[data-custom-attribute='kaboom!']"
  end

  test "sets a default bottom margin to its wrapper" do
    render_component({ base_path: "/the-current-page" })
    assert_select 'div.govuk-\!-margin-bottom-3 .app-c-single-page-notification-button'
  end

  test "adds bottom margin to its wrapper if margin_bottom is specified" do
    render_component({ base_path: "/the-current-page", margin_bottom: 9 })
    assert_select 'div.govuk-\!-margin-bottom-9 .app-c-single-page-notification-button'
  end

  test "has a js-enhancement class and a data-module attribute if the js-enhancement flag is present" do
    render_component({ base_path: "/the-current-page", js_enhancement: true })
    assert_select ".app-c-single-page-notification-button.js-personalisation-enhancement[data-module='single-page-notification-button']"
  end

  test "does not have a js-enhancement class and a data-module attribute if the js-enhancement flag is not present" do
    render_component({ base_path: "/the-current-page" })
    assert_select ".app-c-single-page-notification-button.js-personalisation-enhancement", false
    assert_select ".app-c-single-page-notification-button[data-module='single-page-notification-button']", false
  end

  test "has correct attributes for tracking by default" do
    render_component({ base_path: "/the-current-page" })
    assert_select ".app-c-single-page-notification-button[data-track-category='Single-page-notification-button'][data-track-action='Subscribe-button'][data-track-label='/the-current-page']"
  end

  test "has correct attributes for tracking when already_subscribed is true" do
    render_component({ base_path: "/the-current-page", already_subscribed: true })

    assert_select ".app-c-single-page-notification-button[data-track-category='Single-page-notification-button'][data-track-action='Unsubscribe-button'][data-track-label='/the-current-page']"
  end

  test "has the correct default data-track-action for tracking when button_location is top" do
    render_component({ base_path: "/the-current-page", button_location: "top" })

    assert_select ".app-c-single-page-notification-button[data-track-action='Subscribe-button-top']"
  end

  test "has the correct data-track-action for tracking when button_location is top and already_subscribed is true" do
    render_component({ base_path: "/the-current-page", button_location: "top", already_subscribed: true })

    assert_select ".app-c-single-page-notification-button[data-track-action='Unsubscribe-button-top']"
  end

  test "has the correct default data-track-action for tracking when button_location is bottom" do
    render_component({ base_path: "/the-current-page", button_location: "bottom" })

    assert_select ".app-c-single-page-notification-button[data-track-action='Subscribe-button-bottom']"
  end

  test "has the correct data-track-action for tracking when button_location is bottom and already_subscribed is true" do
    render_component({ base_path: "/the-current-page", button_location: "bottom", already_subscribed: true })

    assert_select ".app-c-single-page-notification-button[data-track-action='Unsubscribe-button-bottom']"
  end

  test "has the correct data-track-action for tracking when button_location has an invalid value" do
    render_component({ base_path: "/the-current-page", button_location: "this is unacceptable" })

    assert_select ".app-c-single-page-notification-button[data-track-action='Subscribe-button']"
  end
end
