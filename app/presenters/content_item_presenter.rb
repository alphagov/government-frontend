class ContentItemPresenter
  include ContentItem::Withdrawable

  attr_reader :content_item,
              :requested_path,
              :view_context,
              :base_path,
              :slug,
              :title,
              :description,
              :schema_name,
              :locale,
              :phase,
              :part_slug,
              :document_type,
              :step_by_steps,
              :taxons

  attr_accessor :include_collections_in_other_publisher_metadata

  def initialize(content_item, requested_path, view_context)
    @content_item = content_item
    @requested_path = requested_path
    @view_context = view_context
    @base_path = content_item["base_path"]
    @slug = base_path.delete_prefix("/") if base_path
    @title = content_item["title"]
    @description = content_item["description"]
    @schema_name = content_item["schema_name"]
    @locale = content_item["locale"] || "en"
    @phase = content_item["phase"]
    @document_type = content_item["document_type"]
    @taxons = content_item["links"]["taxons"] if content_item["links"]
    @step_by_steps = content_item["links"]["part_of_step_navs"] if content_item["links"]
    @part_slug = requesting_a_part? ? requested_path.split("/").last : nil
  end

  def parsed_content_item
    content_item.parsed_content
  end

  def requesting_a_part?
    false
  end

  def requesting_a_service_sign_in_page?
    false
  end

  def has_single_page_notifications?
    false
  end

  def available_translations
    translations = content_item["links"]["available_translations"] || []

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

  def web_url
    Plek.new.website_root + content_item["base_path"]
  end

  def canonical_url
    if requesting_a_part?
      "#{web_url}/#{part_slug}"
    else
      web_url
    end
  end

  # The default behaviour to is honour the max_age
  # from the content-store response.
  def cache_control_max_age(_format)
    content_item.cache_control.max_age
  end

  def cache_control_public?
    !content_item.cache_control.private?
  end

  def show_phase_banner?
    phase.in?(%w[alpha beta])
  end

  def service_manual?
    false
  end

  def render_guide_as_single_page?
    # /how-to-vote
    content_id == "9315bc67-33e7-42e9-8dea-e022f56dabfa" && voting_is_open?
  end

  def manual_updates?
    view_context.request.path =~ /^\/guidance\/.*\/updates$/ && content_item["schema_name"] == "manual"
  end

  def hmrc_manual_updates?
    view_context.request.path =~ /^\/hmrc-internal-manuals\/.*\/updates$/ && content_item["schema_name"] == "hmrc_manual"
  end

  def worldwide_organisation_office?
    view_context.request.path =~ /^\/world\/.*\/office\/.*$/ && content_item["schema_name"] == "worldwide_organisation"
  end

  def show_default_breadcrumbs?
    true
  end

private

  def voting_is_open?
    polls_closing_time = Time.zone.parse("2021-05-06 22:00:00")
    Time.zone.now < polls_closing_time
  end

  def display_date(timestamp, format = "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale: "en") if timestamp
  end

  def sorted_locales(translations)
    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? "" : t["locale"] }
  end

  def mapped_locales(translations)
    translations.map do |translation|
      {
        locale: translation["locale"],
        base_path: translation["base_path"],
        text: native_language_name_for(translation["locale"]),
      }.tap do |h|
        h[:active] = true if h[:locale] == I18n.locale.to_s
      end
    end
  end

  def text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end

  def native_language_name_for(locale)
    I18n.t("language_names.#{locale}", locale:)
  end
end
