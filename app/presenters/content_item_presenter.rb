class ContentItemPresenter
  include ContentItem::Withdrawable

  attr_reader :content_item,
              :requested_content_item_path,
              :base_path,
              :title,
              :description,
              :schema_name,
              :locale,
              :phase,
              :part_slug,
              :document_type

  def initialize(content_item, requested_content_item_path = nil)
    @content_item = content_item
    @requested_content_item_path = requested_content_item_path
    @base_path = content_item["base_path"]
    @title = content_item["title"]
    @description = content_item["description"]
    @schema_name = content_item["schema_name"]
    @locale = content_item["locale"] || "en"
    @phase = content_item["phase"]
    @document_type = content_item["document_type"]
    @nav_helper = GovukNavigationHelpers::NavigationHelper.new(content_item)
    @part_slug = requesting_a_part? ? requested_content_item_path.split('/').last : nil
  end

  def requesting_a_part?
    false
  end

  def requesting_a_service_sign_in_page?
    false
  end

  def available_translations
    translations = @content_item["links"]["available_translations"] || []

    mapped_locales(sorted_locales(translations))
  end

  def parent
    if content_item["links"].include?("parent")
      content_item["links"]["parent"][0]
    end
  end

  def content_id
    content_item["content_id"]
  end

  def breadcrumbs
    @nav_helper.breadcrumbs[:breadcrumbs]
  end

  def taxon_breadcrumbs
    @nav_helper.taxon_breadcrumbs[:breadcrumbs]
  end

  def taxonomy_sidebar
    @nav_helper.taxonomy_sidebar
  end

  def related_items
    @nav_helper.related_items
  end

  def tagged_to_a_taxon?
    content_item.dig("links", "taxons").present?
  end

  def publishing_organisation
    @content_item["links"]["organisations"].to_a.first
  end

  def policy
    @content_item["links"]["related_policies"].to_a.first
  end

  def person
    @content_item["links"]["people"].to_a.first
  end

  def taxon
    @content_item["links"]["taxons"].to_a.first
  end

  def taxons
    @content_item["links"]["taxons"]
  end

  def related_stuff(rummager_args)
    results = Services.rummager.search({ count: 5, fields: %w[title public_timestamp link display_type]}.merge(rummager_args))["results"]

    items = results.map do |r|
      {
        link: { text: r["title"], path: r["link"] },
        metadata: { public_updated_at: Time.parse(r["public_timestamp"]), document_type: r["display_type"] }
      }
    end

    { items: items }
  end

private

  def display_date(timestamp, format = "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format: format) if timestamp
  end

  def sorted_locales(translations)
    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? '' : t["locale"] }
  end

  def mapped_locales(translations)
    translations.map do |translation|
      {
        locale: translation["locale"],
        base_path: translation["base_path"],
        text: native_language_name_for(translation["locale"])
      }.tap do |h|
        h[:active] = true if h[:locale] == I18n.locale.to_s
      end
    end
  end

  def text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end

  def native_language_name_for(locale)
    I18n.t("language_names.#{locale}", locale: locale)
  end
end
