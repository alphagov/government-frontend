module Supergroups
  class Transparency
    def initialize(taxon_ids)
      @taxon_ids = taxon_ids
      @content = MostRecentContent.fetch(content_ids: @taxon_ids, filter_content_purpose_supergroup: "transparency")
    end

    def tagged_content
      format_document_data(@content)
    end

    def any_content?
      @content.any?
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
                organisations: format_organisations(document),
                document_type: document["content_store_document_type"].humanize
            }
        }

        if document["public_timestamp"]
          data[:metadata][:public_updated_at] = Date.parse(document["public_timestamp"])
        end

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
