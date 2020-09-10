module ApplicationHelper
  def page_text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end

  def t_locale_fallback(key, options = {})
    options[:locale] = I18n.locale
    options[:fallback] = nil
    translation = I18n.t(key, **options)

    if translation.nil? || translation.include?("translation missing")
      I18n.default_locale
    end
  end

  def wrapper_class
    "direction-#{page_text_direction}" if page_text_direction
  end

  def active_proposition
    # Which of the government sections is the page part of?
    # Derive this from the request path, eg: /government/consultations => consultations
    active = request.original_fullpath.split("/")[2]
    active_proposition_mapping.fetch(active, active)
  end

  def current_path_without_query_string
    request.original_fullpath.split("?", 2).first
  end

private

  def active_proposition_mapping
    # Some paths don't map directly to the position nav
    # eg /government/news sits under 'announcements'
    {
      "news" => "announcements",
      "fatalities" => "announcements",
    }
  end
end
