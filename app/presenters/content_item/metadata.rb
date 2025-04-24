module ContentItem
  module Metadata
    include Linkable
    include Updatable

    def metadata
      publisher_metadata.merge(
        part_of:,
        direction: text_direction,
        other: {},
      )
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

      metadata[:see_updates_link] = true if has_change_history?

      metadata
    end

    def has_change_history?
      change_history.present?
    end
  end
end
