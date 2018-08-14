module Supergroups
  class Services < Supergroup
    attr_reader :content

    def initialize(current_path, taxon_ids, filters)
      super(current_path, taxon_ids, filters, MostPopularContent)
    end

    def tagged_content
      format_document_data(@content, data_category: "HighlightBoxClicked")
    end
  end
end
