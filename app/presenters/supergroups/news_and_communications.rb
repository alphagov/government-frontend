module Supergroups
  class NewsAndCommunications < Supergroup
    attr_reader :content

    PLACEHOLDER_IMAGE = "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg".freeze

    def initialize(current_path, taxon_ids, filters)
      super(current_path, taxon_ids, filters, MostRecentContent)
    end

    def tagged_content
      return unless @content.any?
      {
        documents: documents,
        promoted_content: promoted_content,
      }
    end

  private

    def documents
      items = @content.drop(promoted_content_count)
      format_document_data(items)
    end

    def promoted_content
      items = @content.take(promoted_content_count)
      format_document_data(items, data_category: "ImageCardClicked")
    end

  private

    def format_document_data(documents, data_category: nil)
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document["title"],
            path: document["link"],
            data_attributes: data_attributes(document["link"], document["title"], index, data_category)
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

    def promoted_content_count
      3
    end

    def image_url(document)
      document["image_url"] || PLACEHOLDER_IMAGE
    end

    def context(document)
      "#{document_type(document)} - #{updated_date(document).strftime('%e %B %Y')}"
    end
  end
end
