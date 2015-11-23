class ContentItemPresenter
  attr_reader :content_item, :title, :description, :format, :locale, :phase

  def initialize(content_item)
    @content_item = content_item
    @title = content_item["title"]
    @description = content_item["description"]
    @format = content_item["format"]
    @locale = content_item["locale"] || "en"
    @phase = content_item["phase"]
  end

  def available_translations
    sorted_locales(@content_item["links"]["available_translations"])
  end

private

  def sorted_locales(translations)
    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? '' : t["locale"] }
  end
end

