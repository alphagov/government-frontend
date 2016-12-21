module Linkable
  include ActionView::Helpers::UrlHelper

  def from
    organisations_ordered_by_importance + links_group(%w{worldwide_organisations ministers speaker})
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
    expanded_links_from_content_item(type).map do |link|
      link_to(link["title"], link["base_path"])
    end
  end

  def expanded_links_from_content_item(type)
    return [] unless content_item["links"][type]
    content_item["links"][type]
  end

  def links_group(types)
    types.flat_map { |type| links(type) }.uniq
  end

  def organisations_ordered_by_importance
    organisations_with_emphasised_first.map do |link|
      link_to(link["title"], link["base_path"])
    end
  end

  def organisations_with_emphasised_first
    expanded_links_from_content_item("organisations").sort_by do |organisation|
      is_emphasised = organisation["content_id"].in?(content_item["details"]["emphasised_organisations"])
      is_emphasised ? -1 : 1
    end
  end
end
