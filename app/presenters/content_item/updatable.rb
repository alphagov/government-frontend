module ContentItem
  module Updatable
    def published
      display_date(first_public_at)
    end

    def updated
      display_date(public_updated_at) if any_updates?
    end

    def history
      return [] unless any_updates?
      reverse_chronological_change_history
    end

    def first_public_at
      content_item["details"]["first_public_at"] || content_item["first_published_at"]
    end

    def public_updated_at
      content_item["public_updated_at"]
    end

  private

    def change_history
      changes = content_item["details"]["change_history"] || []
      changes.map do |item|
        {
          display_time: display_date(item["public_timestamp"]),
          note: item["note"],
          timestamp: item["public_timestamp"]
        }
      end
    end

    # The direction of change history isn’t guaranteed
    # https://github.com/alphagov/govuk-content-schemas/issues/545
    def reverse_chronological_change_history
      change_history.sort_by { |item| Time.parse(item[:timestamp]) }.reverse
    end

    def any_updates?
      if public_updated_at && first_public_at
        Time.zone.parse(public_updated_at) != Time.zone.parse(first_public_at)
      else
        false
      end
    end
  end
end
