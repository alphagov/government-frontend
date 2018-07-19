module Supergroups
  class Services
    def tagged_content(taxon_id)
      @content = MostPopularContent.fetch(content_id: taxon_id, filter_content_purpose_supergroup: "services")
    end
  end
end
