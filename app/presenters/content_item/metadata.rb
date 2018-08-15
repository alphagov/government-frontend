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
      {}.tap do |publisher_metadata|
        publisher_metadata[:published] = published
        publisher_metadata[:last_updated] = updated
        publisher_metadata[:link_to_history] = !!updated
        publisher_metadata[:other] = {
          from: from,
        }

        if include_collections_in_other_publisher_metadata
          publisher_metadata[:other][:collections] = links('document_collections')
        end
      end
    end
  end
end
