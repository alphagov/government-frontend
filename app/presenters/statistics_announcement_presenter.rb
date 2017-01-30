class StatisticsAnnouncementPresenter < ContentItemPresenter
  include Metadata
  include TitleAndContext

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

  def metadata
    super.tap do |m|
      if cancelled?
        m[:other]["Proposed release"] = release_date
        m[:other]["Cancellation date"] = cancellation_date
      else
        m[:other]["Release date"] = release_date_and_status
      end
    end
  end

  def national_statistics?
    content_item["details"]["format_sub_type"] == 'national'
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

private

  def state
    content_item["details"]["state"]
  end
end
