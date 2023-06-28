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
      {
        from:,
        first_published: published,
        last_updated: updated,
        see_updates_link: true,
      }
    end

    def publisher_metadata_nodates
      {
        from:,
        see_updates_link: true,
      }
    end

  end
end
