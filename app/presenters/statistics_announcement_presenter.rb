class StatisticsAnnouncementPresenter < ContentItemPresenter
  include Metadata

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
      m[:other] = if cancelled?
                    {
                      "Proposed release" => release_date,
                      "Cancellation date" => cancellation_date,
                    }
                  else
                    {
                      "Release date" => release_date_and_status
                    }
                  end
    end
  end

  def national_statistics?
    content_item["details"]["format_sub_type"] == 'national'
  end

  def cancellation_date
    cancelled_at = content_item["details"]["cancelled_at"]
    DateTime.parse(cancelled_at).strftime("%e %B %Y %-l:%M%P")
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

private

  def state
    content_item["details"]["state"]
  end
end
