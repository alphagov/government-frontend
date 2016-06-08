module Withdrawable
  def withdrawn?
    content_item["withdrawn_notice"].present?
  end

  def page_title
    withdrawn? ? "[Withdrawn] #{title}" : title
  end

  def withdrawal_notice
    notice = content_item["withdrawn_notice"]
    if notice
      {
        time: content_tag(:time, display_time(notice["withdrawn_at"]), datetime: notice["withdrawn_at"]),
        explanation: notice["explanation"]
      }
    end
  end
end
