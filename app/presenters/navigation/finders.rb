module Navigation
  module Finders
    def related_navigation
      nav = super
      nav[:related_items] << finder_link
      nav
    end

    def finder_link
      {
        text: "Related #{pluralised_document_type}",
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
      links = content_item["links"].fetch(link_type, [])

      options = links.map { |l| option_value(l) }
      options = %w(all) if options.empty?

      { option_key => options }
    end

    def option_value(link)
      if link["schema_name"] == "world_location"
        link["title"].parameterize
      else
        link["base_path"].split("/").last
      end
    end

    def pluralised_document_type
      doctype = I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)
      doctype[0] = doctype[0].downcase
      doctype
    end
  end
end
