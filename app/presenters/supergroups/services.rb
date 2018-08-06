module Supergroups
  class Services
    attr_reader :content

    def initialize(current_path, taxon_ids)
      @taxon_ids = taxon_ids
      @current_path = current_path
      @content = fetch
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

    def fetch
      return [] if @taxon_ids.empty?

      MostPopularContent.fetch(
        content_ids: @taxon_ids,
        current_path: @current_path,
        filter_content_purpose_supergroup: "services"
      )
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
