module Supergroups
  class Transparency < Supergroup
    def initialize(current_path, taxon_ids)
      @current_path = current_path
      @taxon_ids = taxon_ids
      @content = fetch_content
    end

    def tagged_content
      format_document_data(@content)
    end

  private

    def fetch_content
      return [] unless @taxon_ids.any?
      MostRecentContent.fetch(content_ids: @taxon_ids, current_path: @current_path, filter_content_purpose_supergroup: "transparency")
    end
  end
end
