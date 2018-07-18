module Supergroups
  class Services
    attr_reader :content

    def initialize(taxon_id)
      @taxon_id = taxon_id
    end

    def tagged_content
      @content = MostPopularContent.fetch(content_id: @taxon_id, filter_content_purpose_supergroup: "services")
      format_document_data(@content)
    end

  private

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
