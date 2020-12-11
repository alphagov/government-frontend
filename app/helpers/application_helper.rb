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

  def format_with_html_line_breaks(string)
    ERB::Util.html_escape(string || "").strip.gsub(/(?:\r?\n)/, "<br/>").html_safe
  end

  def page_title(*title_parts)
    # This helper may be called multiple times on the
    # same page, with or without the necessary arguments
    # to construct the title (e.g. on a nested form).
    # rubocop:disable Rails/HelperInstanceVariable
    if title_parts.any?
      title_parts.push("Admin") if params[:controller].match?(/^admin\//)
      title_parts.push("GOV.UK")
      @page_title = title_parts.reject(&:blank?).join(" - ")
    else
      @page_title
    end
    # rubocop:enable Rails/HelperInstanceVariable
  end

  def page_class(css_class)
    content_for(:page_class, css_class)
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
