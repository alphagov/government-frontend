module Supergroups
  class GuidanceAndRegulation < Supergroup
    def initialize(current_path, taxon_ids, filters)
      super(current_path, taxon_ids, filters, MostPopularContent)
    end

    def tagged_content
      format_document_data(@content, include_timestamp: false)
    end
  end
end
