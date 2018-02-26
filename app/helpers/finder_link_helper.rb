module FinderLinkHelper
  def finder_link(content_item)
    taxons = content_item["links"]["taxons"]
    if taxons.any?
      taxon = content_item["links"]["taxons"].first
      document_type = content_item["document_type"]
      link_params = { taxons: taxon["base_path"], content_purpose_document_supertype: document_type }
      base_url = ENV["FINDER_APP_URL"] || ""
      finder_app_url = base_url + link_params.to_query
      document_types_text = I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)

      link_to("More #{document_types_text} about #{taxon['title']}",
              finder_app_url,
              class: "govuk-taxonomy-sidebar__collections-link")
    end
  end
end
