module ContentItem
  module TaxonomyNavigation
    include LinksOut

    def taxonomy_navigation(current_base_path)
      taxons = @taxons.select { |taxon| taxon["phase"] == "live" }
      taxon_ids = taxons.map { |taxon| taxon["content_id"] }
      supergroup_taxon_links = []

      links_out_supergroups.each do |supergroup|
        content = "Supergroups::#{supergroup.camelcase}".constantize.new(current_base_path, taxon_ids, filter_content_purpose_subgroup: links_out_subgroups)
        supergroup_taxon_link = { supergroup: supergroup.to_sym, content: content }
        supergroup_taxon_links << supergroup_taxon_link
      end

      supergroup_taxon_links_threads = {}
      supergroup_taxon_links.each do |supergroup_taxon_link|
        supergroup_taxon_links_threads[supergroup_taxon_link[:supergroup]] = Thread.new { supergroup_taxon_link[:content].tagged_content }
      end

      taxonomy_navigation = {}
      supergroup_taxon_links_threads.each_pair do |supergroup, content_thread|
        taxonomy_navigation[supergroup] = content_thread.join.value
      end
      taxonomy_navigation
    end
  end
end
