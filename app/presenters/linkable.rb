module Linkable
  def from
    links_group(%w{
      lead_organisations
      organisations
      supporting_organisations
      worldwide_organisations
      ministers
    })
  end

  def part_of
    links_group(%w{
      document_collections
      related_policies
      policies
      world_locations
      topics
      topical_events
      related_statistical_data_sets
    })
  end

private

  def links(type)
    return [] unless content_item["links"][type]
    content_item["links"][type].map do |link|
      link_to(link["title"], link["base_path"])
    end
  end

  def links_group(types)
    types.flat_map { |type| links(type) }.uniq
  end
end
