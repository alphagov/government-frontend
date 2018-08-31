module Supergroups
  class GuidanceAndRegulation < Supergroup
    def tagged_content
      content = fetch_content
      format_document_data(content, include_timestamp: false)
    end

  private

    def fetch_content
      return [] unless @taxon_ids.any?
      MostPopularContent.fetch(content_ids: @taxon_ids, current_path: @current_path, filters: @filters)
    end
  end
end
