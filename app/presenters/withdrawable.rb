module Withdrawable
  include ActionView::Helpers::TagHelper

  def withdrawn?
    withdrawal_notice.present?
  end

  def page_title
    withdrawn? ? "[Withdrawn] #{title}" : title
  end

  def withdrawal_notice_component
    {
      title: withdrawal_notice_title,
      description_govspeak: withdrawal_notice["explanation"],
      time: withdrawal_notice_time
    } if withdrawn?
  end

private

  def withdrawal_notice
    content_item["withdrawn_notice"]
  end

  def withdrawal_notice_title
    friendly_schema_name = I18n.t("content_item.schema_name.#{schema_name}", count: 1).downcase
    "This #{friendly_schema_name} was withdrawn on #{withdrawal_notice_time}".html_safe
  end

  def withdrawal_notice_time
    content_tag(:time, display_date(withdrawal_notice["withdrawn_at"]), datetime: withdrawal_notice["withdrawn_at"])
  end
end
