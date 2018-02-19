module Navigation
  module Finders
    UPPERCASE_POLICY_AREA_PREFIXES = %w(
      Europe
      National Health Service
      Northern Ireland
      Scotland
      UK
      Wales
    ).freeze

    def related_navigation
      nav = super
      nav[:related_items] << finder_link
      nav
    end

    def finder_link
      {
        text: link_text,
        path: finder_path_and_params,
        finder: true,
      }
    end

    def departments
      multiple_options_from_links("organisations", "departments")
    end

    def people
      multiple_options_from_links("people")
    end

    def topics
      multiple_options_from_links("policy_areas", "topics")
    end

    def world_locations
      multiple_options_from_links("world_locations")
    end

    def multiple_options_from_links(link_type, option_key = nil)
      option_key ||= link_type

      options = links_by_type(link_type).map { |l| option_value(l) }
      options = %w(all) if options.empty?

      { option_key => options }
    end

    def link_titles(link_type)
      links_by_type(link_type).map { |l| l["title"] }
    end

    def links_by_type(link_type)
      content_item["links"].fetch(link_type, [])
    end

    def option_value(link)
      if link["schema_name"] == "world_location"
        link["title"].parameterize
      else
        link["base_path"].split("/").last
      end
    end

    def policy_area_name
      name = link_titles("policy_areas").first
      return unless name
      name.downcase! unless name.start_with?(*UPPERCASE_POLICY_AREA_PREFIXES)
      name
    end

    def publishing_organisation
      link_titles("primary_publishing_organisation").first ||
        link_titles("organisations").first
    end

    def link_text
      buf = ["More #{pluralised_document_type}"]
      buf << "about #{policy_area_name}" if policy_area_name
      buf << "from #{publishing_organisation}"
      buf.join(" ")
    end
  end
end
