module ContentItem
  module Linkable
    def from
      organisations_ordered_by_importance + links_group(%w[worldwide_organisations people speaker])
    end

    def part_of
      links_group(%w[
        document_collections
        related_policies
        policies
        world_locations
        topics
        topical_events
        related_statistical_data_sets
      ])
    end

  private

    def links(type)
      expanded_links_from_content_item(type)
        .select { |link| link["base_path"] || type == "world_locations" }
        .map { |link| link_for_type(type, link) }
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
        view_context.link_to(link["title"], link["base_path"], class: "govuk-link")
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

      view_context.link_to(link["title"], link["base_path"], class: "govuk-link")
    end

    def link_for_world_location(link)
      base_path = WorldLocationBasePath.for(link)
      view_context.link_to(link["title"], base_path, class: "govuk-link")
    end
  end
end
