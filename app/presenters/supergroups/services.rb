module Supergroups
  class Services < Supergroup
    attr_reader :content

    def initialize(current_path, taxon_ids, filters)
      super(current_path, taxon_ids, filters, MostPopularContent)
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
      format_document_data(items, "HighlightBoxClicked")
    end

    def promoted_content_count
      3
    end

    def format_document_data(documents, data_category = "DocumentListClicked")
      documents.each.with_index(1)&.map do |document, index|
        data = {
          link: {
            text: document["title"],
            path: document["link"],
            data_attributes: {
              track_category: "Services" + data_category,
              track_action: index,
              track_label: document["link"],
              track_options: {
                dimension29: document["title"],
              }
            }
          }
        }

        data
      end
    end
  end
end
