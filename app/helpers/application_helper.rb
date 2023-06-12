module ApplicationHelper
  def page_text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end

  def t_locale_fallback(key, options = {})
    options[:locale] = I18n.locale
    options[:fallback] = nil
    translation = I18n.t(key, **options)

    if translation.nil? || translation.downcase.include?("translation missing")
      I18n.default_locale
    end
  end

  def wrapper_class
    "direction-#{page_text_direction}" if page_text_direction
  end

  def current_path_without_query_string
    request.original_fullpath.split("?", 2).first
  end
end
