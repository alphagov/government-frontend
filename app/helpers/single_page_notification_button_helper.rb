module SinglePageNotificationButtonHelper
  def single_page_notification_button_data(local_assigns)
    button_location = button_location_is_valid?(local_assigns[:button_location]) ? local_assigns[:button_location] : nil
    data_attributes = local_assigns[:data_attributes] || {}
    button_type = local_assigns[:already_subscribed] ? "Unsubscribe" : "Subscribe"
    data_attributes[:track_label] = local_assigns[:base_path]
    # data-action for tracking should have the format of e.g. "Unsubscribe-button-top", or "Subscribe-button-bottom"
    # when button_location is not present data-action will fall back to "Unsubscribe-button"/"Subscribe-button"
    data_attributes[:track_action] = [button_type, "button", button_location].compact.join("-")
    data_attributes[:module] = "single-page-notification-button" if local_assigns[:js_enhancement]
    data_attributes[:track_category] = "Single-page-notification-button"
    # This attribute is passed through to the personalisation API to ensure when a new button is returned from the API, it has the same button_location
    data_attributes[:button_location] = button_location
    data_attributes
  end

  def single_page_notification_button_text(already_subscribed)
    already_subscribed ? I18n.t("components.single_page_notification_button.unsubscribe_text") : I18n.t("components.single_page_notification_button.subscribe_text")
  end

private

  def button_location_is_valid?(button_location)
    %w[bottom top].include? button_location
  end
end
