module ContentItem
  module Withdrawable
    def withdrawn?
      withdrawal_notice.present?
    end

    def page_title
      withdrawn? ? "[Withdrawn] #{title}" : title
    end

    def withdrawal_notice_component
      if withdrawn?
        {
          title: withdrawal_notice_title,
          description_govspeak: withdrawal_notice["explanation"]&.html_safe,
          time: withdrawal_notice_time,
          lang: I18n.locale.to_s == "en" ? false : "en",
        }
      end
    end

  private

    def withdrawal_notice
      content_item["withdrawn_notice"]
    end

    def withdrawal_notice_title
      "This #{withdrawal_notice_context.downcase} was withdrawn on #{withdrawal_notice_time}".html_safe
    end

    def withdrawal_notice_context
      I18n.t("content_item.schema_name.#{schema_name}", count: 1, locale: :en)
    end

    def withdrawal_notice_time
      view_context.tag.time(
        english_display_date(withdrawal_notice["withdrawn_at"]),
        datetime: withdrawal_notice["withdrawn_at"],
      )
    end

    def english_display_date(timestamp, format = "%-d %B %Y")
      I18n.l(Time.zone.parse(timestamp), format: format, locale: :en) if timestamp
    end
  end
end
