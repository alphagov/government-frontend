module ContentItem
  module Metadata
    include Linkable
    include Updatable

    def metadata
      {
        from: from,
        first_published: published,
        last_updated: updated,
        see_updates_link: true,
        part_of: part_of,
        direction: text_direction,
        other: {}
      }
    end

    def important_metadata
      {}
    end

    def publisher_metadata
      {
        published: published,
        last_updated: updated,
        link_to_history: !!updated,
        other: {
          'From': from
        }
      }
    end
  end
end
