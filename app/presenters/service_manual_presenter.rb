class ServiceManualPresenter < ContentItemPresenter
  def available_translations
    sorted_locales(links["available_translations"])
  end

  def links
    @links ||= content_item["links"] || {}
  end

  def details
    @details ||= content_item["details"] || {}
  end

  def include_search_in_header?
    true
  end

  def format
    content_item["document_type"]
  end

private

  def sorted_locales(translations)
    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? "" : t["locale"] }
  end
end
