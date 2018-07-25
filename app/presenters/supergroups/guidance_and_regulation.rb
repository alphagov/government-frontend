module Supergroups
  class GuidanceAndRegulation < Supergroup
    def initialize(current_path, taxon_ids)
      @current_path = current_path
      @taxon_ids = taxon_ids
      @content = fetch_content
    end

    def tagged_content
      format_document_data(@content, include_timestamp: false)
    end

  private

    def fetch_content
      return [] unless @taxon_ids.any?
      MostPopularContent.fetch(content_ids: @taxon_ids, current_path: @current_path, filter_content_purpose_supergroup: "guidance_and_regulation")
    end
  end
end
