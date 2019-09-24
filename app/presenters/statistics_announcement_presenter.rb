class StatisticsAnnouncementPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::NationalStatisticsLogo
  include ContentItem::TitleAndContext
  include StatisticsAnnouncementHelper

  FORTHCOMING_NOTICE = "These statistics will be released".freeze

  def release_date
    content_item["details"]["display_date"]
  end

  def release_date_and_status
    return "#{release_date} (#{state})" unless cancelled?
    release_date
  end

  def previous_release_date
    content_item["details"]["previous_display_date"]
  end

  def release_date_changed?
    content_item["details"].include?("previous_display_date")
  end

  def important_metadata
    super.tap do |m|
      if cancelled?
        m.merge!(
          "Proposed release" => release_date,
          "Cancellation date" => cancellation_date
        )
      else
        m.merge!("Release date" => release_date_and_status)
      end
    end
  end

  def national_statistics?
    content_item["details"]["format_sub_type"] == "national"
  end

  def cancellation_date
    cancelled_at = content_item["details"]["cancelled_at"]
    Time.zone.parse(cancelled_at).strftime("%e %B %Y %-l:%M%P")
  end

  def cancelled?
    state == "cancelled"
  end

  def cancellation_reason
    content_item["details"]["cancellation_reason"]
  end

  def release_date_change_reason
    content_item["details"]["latest_change_note"]
  end

  def page_title
    "#{super} - #{I18n.t("content_item.schema_name.#{document_type}", count: 1)}"
  end

  def forthcoming_notice_title
    "#{FORTHCOMING_NOTICE} #{on_in_between_for_release_date(release_date)}"
  end

  def forthcoming_publication?
    !cancelled?
  end

private

  def state
    content_item["details"]["state"]
  end
end
