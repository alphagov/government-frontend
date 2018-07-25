module Supergroups
  class Supergroup
  private

    def format_document_data(documents, include_timestamp: true)
      documents&.map do |document|
        data = {
          link: {
            text: document["title"],
            path: document["link"]
          },
          metadata: {
            document_type: document["content_store_document_type"].humanize
          }
        }

        if include_timestamp && document["public_timestamp"]
          data[:metadata][:public_updated_at] = Date.parse(document["public_timestamp"])
        end

        data
      end
    end
  end
end
