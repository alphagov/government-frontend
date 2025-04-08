module ContentItem
  module Metadata
    include Linkable
    include Updatable

    def metadata
      metadata =
        {
          from:,
          first_published: published,
          last_updated: updated,
          part_of:,
          direction: text_direction,
          other: {},
        }
      if has_change_history?
        metadata[:see_updates_link] = true
      end
      metadata
    end

    def important_metadata
      {}
    end

    def publisher_metadata
      metadata =
        {
          from:,
          first_published: published,
          last_updated: updated,
        }

      if has_change_history?
        metadata[:see_updates_link] = true
      end

      metadata
    end

    def pending_stats_announcement?
      details_display_date.present? && Time.zone.parse(details_display_date).future?
    end

    def details_display_date
      content_item["details"]["display_date"]
    end

    def has_change_history?
      change_history.present?
    end
  end
end
