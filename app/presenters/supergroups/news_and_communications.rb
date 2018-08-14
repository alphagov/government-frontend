module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    PLACEHOLDER_IMAGE = "#{Plek.current.asset_root}/government/assets/placeholder.jpg".freeze

    def initialize(current_path, taxon_ids, filters)
      super(current_path, taxon_ids, filters, MostRecentContent)
    end

    def tagged_content
      format_document_data(@content)
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
  end
end
