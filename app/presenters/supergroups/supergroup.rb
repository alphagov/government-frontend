module Supergroups
  class Supergroup
  private

    def format_document_data(documents, data_category: nil, include_timestamp: true)
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document["title"],
            path: document["link"],
            data_attributes: data_attributes(document["link"], document["title"], index)
          },
          metadata: {
            document_type: document["content_store_document_type"].humanize
          }
        }

        if include_timestamp && document["public_timestamp"]
          data[:metadata][:public_updated_at] = Date.parse(document["public_timestamp"])
        end

        if data_category.present?
          data[:link][:data_attributes][:track_category] = data_module_label + data_category
        end

        data
      end
    end

    def data_attributes(base_path, link_text, index)
      {
        track_category: data_module_label + "DocumentListClicked",
        track_action: index,
        track_label: base_path,
        track_options: {
          dimension29: link_text
        }
      }
    end

    def data_module_label
      self.class.name.demodulize.camelize(:lower)
    end
  end
end
