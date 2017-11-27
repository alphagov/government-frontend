module ContentItem
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

    def related_whitehall_topics
      links_for_navigation_sidebar('topics', 'whitehall')
    end

    def related_policies
      links_for_navigation_sidebar('related_policies', 'policy')
    end

    def related_organisations
      links_for_navigation_sidebar('organisations', 'organisation')
    end

    def related_collections
      links_for_navigation_sidebar('document_collections', 'document_collection')
    end

    def related_ordered_items
      links_for_navigation_sidebar('ordered_related_items', 'related')
    end

  private

    def links(type)
      expanded_links_from_content_item(type).map do |link|
        link_for_type(type, link)
      end
    end

    def links_for_navigation_sidebar(type, rendering_type)
      expanded_links_from_content_item(type).map do |link|
        {
          path: link["base_path"],
          text: link["title"],
          type: rendering_type
        }
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
        is_emphasised = organisation["content_id"].in?(emphasised_organisations)
        is_emphasised ? -1 : 1
      end
    end

    def emphasised_organisations
      content_item["details"]["emphasised_organisations"] || []
    end

    def link_for_type(type, link)
      return link_for_world_location(link) if type == "world_locations"
      link_to(link["title"], link["base_path"])
    end

    def link_for_world_location(link)
      base_path = WorldLocationBasePath.for(link)
      link_to(link["title"], base_path)
    end
  end
end
