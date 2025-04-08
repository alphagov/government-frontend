module ContentItem
  module Metadata
    include Linkable
    include Updatable

    def metadata
      {
        from:,
        first_published: published,
        last_updated: updated,
        see_updates_link: true,
        part_of:,
        direction: text_direction,
        other: {},
      }
    end

    def important_metadata
      {}
    end

    def publisher_metadata
      metadata = {
        from:,
        first_published: published,
        last_updated: updated,
      }

      unless pending_stats_announcement? || cancelled_stats_announcement?
        metadata[:see_updates_link] = true
      end

      metadata
    end

    def pending_stats_announcement?
      details_display_date.present? && Time.zone.parse(details_display_date).future?
    end

    def cancelled_stats_announcement?
      content_item["details"]["state"] == "cancelled"
    end

    def details_display_date
      content_item["details"]["display_date"]
    end
  end
end
