module Supergroups
  class NewsAndCommunications < Supergroup

    PLACEHOLDER_IMAGE = "#{Plek.current.asset_root}/government/assets/placeholder.jpg".freeze

    def tagged_content
      content = fetch_content
      format_document_data(content)
    end

  private

    def format_document_data(documents)
      # Start with_index at 1 to help align analytics
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document["title"],
            path: document["link"],
            data_attributes: data_attributes(document["link"], document["title"], index, "ImageCardClicked")
          },
          metadata: {
            document_type: document_type(document),
            public_updated_at: updated_date(document)
          },
          image: {
            url: image_url(document),
            context: context(document)
          }
        }

        data
      end
    end

    def image_url(document)
      document["image_url"] || PLACEHOLDER_IMAGE
    end

    def context(document)
      "#{document_type(document)} - #{updated_date(document).strftime('%e %B %Y')}"
    end

    def fetch_content
      return [] unless @taxon_ids.any?
      MostRecentContent.fetch(content_ids: @taxon_ids, current_path: @current_path, filters: @filters)
    end
  end
end
