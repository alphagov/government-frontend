module Linkable
  def from
    links("lead_organisations") + links("supporting_organisations") + links("worldwide_organisations")
  end

  def part_of
    links("document_collections") + links("related_policies") + links("world_locations") + links("topics")
  end

private

  def links(type)
    return [] unless content_item["links"][type]
    content_item["links"][type].map do |link|
      link_to(link["title"], link["base_path"])
    end
  end
end
