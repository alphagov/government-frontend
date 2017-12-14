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

  def related_navigation
    merge_publishers_and_worldwide_organisations(@nav_helper.related_navigation_sidebar)
  end

  def related_items
    @nav_helper.related_items
  end

  def tagged_to_a_taxon?
    content_item.dig("links", "taxons").present?
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

  def merge_publishers_and_worldwide_organisations(related_navigation)
    related_navigation[:publishers] += related_navigation.delete(:worldwide_organisations)
    related_navigation
  end
end
