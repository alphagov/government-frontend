module ApplicationHelper
  def page_text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end

  def wrapper_class
    "direction-#{page_text_direction}" if page_text_direction
  end

  def active_proposition
    # Which of the government sections is the page part of?
    # Derive this from the request path, eg: /government/consultations => consultations
    request.original_fullpath.split('/')[2]
  end
end
