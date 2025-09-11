module ContentItem
  module SinglePageNotificationButton
    def display_single_page_notification_button?
      I18n.locale == :en
    end
  end
end
