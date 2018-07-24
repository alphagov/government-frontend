module Supergroups
  class NewsAndCommunications
    attr_reader :content

    def initialize(taxon_ids)
      @taxon_ids = taxon_ids
    end

    def tagged_content
      @content = MostRecentContent.fetch(content_ids: @taxon_ids, filter_content_purpose_supergroup: "news_and_communications")
      format_document_data(@content)
    end

  private

    def format_document_data(documents)
      documents&.map do |document|
        data = {
            link: {
                text: document["title"],
                path: document["link"]
            },
            metadata: {
                public_updated_at: Date.parse(document["public_timestamp"]),
                organisations: format_organisations(document),
                document_type: document["content_store_document_type"].humanize
            }
        }

        data
      end
    end

    def format_organisations(document)
      if document["organisations"].present?
        document["organisations"].map { |organisation| organisation["title"] }.to_sentence
      end
    end
  end
end
