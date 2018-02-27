module Navigation
  module Taxonomy
    # TODO: This will go away once we start to use
    # new content_purpose_supergroup and subgroup attributes.
    STATISTICS_DOCTYPES = %w(national_statistics official_statistics).freeze

    def taxonomy_navigation
      nav = taxonomy_sidebar
      nav[:items] << { title: taxon_link_text, url: link_url }
      nav
    end

    def taxon_link_text
      "More #{pluralised_document_type} about #{taxon['title']}"
    end

    def link_url
      link_params = {
        content_purpose_document_supertype: document_type,
        taxons: taxon["base_path"]
      }
      "#{ENV['FINDER_APP_URL']}#{link_params.to_query}"
    end

    # TODO: This will go away once we start to use
    # new content_purpose_supergroup and subgroup attributes.
    def pluralised_document_type
      return "statistics" if STATISTICS_DOCTYPES.include?(document_type)
      return "FOI releases" if document_type == "foi_release"

      doctype = I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)
      doctype[0] = doctype[0].downcase
      doctype
    end

    # TODO: Do we ever have multiple parent taxons?
    def taxon
      content_item["links"]["taxons"].first
    end
  end
end
