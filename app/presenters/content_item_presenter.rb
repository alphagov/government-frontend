class ContentItemPresenter
  include Withdrawable

  attr_reader :content_item, :title, :description, :format, :locale, :phase, :document_type

  def initialize(content_item)
    @content_item = content_item
    @title = content_item["title"]
    @description = content_item["description"]
    @format = content_item["format"]
    @locale = content_item["locale"] || "en"
    @phase = content_item["phase"]
    @document_type = content_item["document_type"]
  end

  def available_translations
    sorted_locales(@content_item["links"]["available_translations"])
  end

private

  def display_time(timestamp)
    I18n.l(Date.parse(timestamp), format: "%-d %B %Y") if timestamp
  end

  def sorted_locales(translations)
    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? '' : t["locale"] }
  end
end
