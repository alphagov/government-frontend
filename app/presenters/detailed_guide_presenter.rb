class DetailedGuidePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::Political
  include ContentItem::TitleAndContext
  include ContentItem::SinglePageNotificationButton

  def title_and_context
    super.tap do |t|
      t[:context] = I18n.t("content_item.schema_name.guidance", count: 1)
    end
  end

  def logo
    image = content_item.dig("details", "image")
    return unless image

    { path: image["url"], alt_text: "European structural investment funds" }
  end
end
