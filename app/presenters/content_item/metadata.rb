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

    def metadata_for_taxonomy_navigation
      data = metadata
      data.delete(:part_of)
      data
    end

    def document_footer
      {
        from: from,
        published: published,
        updated: updated,
        history: history,
        part_of: part_of,
        direction: text_direction,
        other: {}
      }
    end

    def document_footer_for_taxonomy_navigation
      data = document_footer
      data.delete(:part_of)
      data
    end
  end
end
