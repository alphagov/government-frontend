require_relative "../../services/most_popular_content"
require_relative "../../services/most_recent_content"

module Supergroups
  class Supergroup
    def initialize(current_path, taxon_ids, filters)
      @current_path = current_path
      @taxon_ids = taxon_ids
      @filters = default_filters.merge(filters)
    end

    def tagged_content
      content = fetch_content
      format_document_data(content)
    end

  private

    def format_document_data(documents, data_category: nil, include_timestamp: true)
      # Start with_index at 1 to help align analytics
      documents.each.with_index(1).map do |document, index|
        data = {
          link: {
            text: document["title"],
            path: document["link"],
            data_attributes: data_attributes(document["link"], document["title"], index, data_category)
          },
          metadata: {
            document_type: document_type(document)
          }
        }

        if include_timestamp && document["public_timestamp"]
          data[:metadata][:public_updated_at] = updated_date(document)
        end

        data
      end
    end

    def data_attributes(base_path, link_text, index, data_category)
      {
        track_category: data_module_label + (data_category || "DocumentListClicked"),
        track_action: index,
        track_label: base_path,
        track_options: {
          dimension29: link_text
        }
      }
    end

    def document_type(document)
      document["content_store_document_type"].humanize
    end

    def updated_date(document)
      Date.parse(document["public_timestamp"])
    end

    def data_module_label
      self.class.name.demodulize.camelize(:lower)
    end

    def default_filters
      { filter_content_purpose_supergroup: self.class.name.demodulize.underscore }
    end
  end
end
