module ContentItem
  module Linkable
    include ActionView::Helpers::UrlHelper

    def from
      organisations_ordered_by_importance(describedby: 'metadata-from') + links_group(%w{worldwide_organisations ministers speaker}, describedby: 'metadata-from')
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

    def links(type, describedby: nil)
      expanded_links_from_content_item(type).map do |link|
        link_for_type(type, link, (describedby.nil? ? {} : { describedby: describedby }))
      end
    end

    def expanded_links_from_content_item(type)
      return [] unless content_item["links"][type]
      content_item["links"][type]
    end

    def links_group(types, describedby: nil)
      types.flat_map { |type| links(type, (describedby.nil? ? {} : { describedby: describedby })) }.uniq
    end

    def organisations_ordered_by_importance(describedby: nil)
      organisations_with_emphasised_first.map do |link|
        link_to(link["title"], link["base_path"], (describedby.nil? ? {} : { 'aria-describedby': describedby }))
      end
    end

    def organisations_with_emphasised_first
      expanded_links_from_content_item("organisations").sort_by do |organisation|
        is_emphasised = organisation["content_id"].in?(emphasised_organisations)
        is_emphasised ? -1 : 1
      end
    end

    def emphasised_organisations
      content_item["details"]["emphasised_organisations"] || []
    end

    def link_for_type(type, link, describedby: nil)
      return link_for_world_location(link, (describedby.nil? ? {} : { 'describedby': describedby })) if type == "world_locations"
      link_to(link["title"], link["base_path"], (describedby.nil? ? {} : { 'aria-describedby': describedby }))
    end

    def link_for_world_location(link, describedby: nil)
      base_path = WorldLocationBasePath.for(link)
      link_to(link["title"], base_path, (describedby.nil? ? {} : { 'aria-describedby': describedby }))
    end
  end
end
