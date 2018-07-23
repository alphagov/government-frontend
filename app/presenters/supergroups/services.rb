module Supergroups
  class Services
    attr_reader :content

    def initialize(taxon_ids)
      @taxon_ids = taxon_ids
    end

    def all_services
      {
        documents: tagged_content.drop(promoted_content_count),
        promoted_content: promoted_content,
      }
    end

    def tagged_content
      @content = MostPopularContent.fetch(content_ids: @taxon_ids, filter_content_purpose_supergroup: "services")
      format_document_data(@content)
    end

    def promoted_content
      tagged_content.shift(promoted_content_count)
    end

  private

    def promoted_content_count
      3
    end

    def format_document_data(documents)
      documents&.map do |document|
        data = {
          link: {
            text: document["title"],
            path: document["link"]
          }
        }

        data
      end
    end
  end
end
