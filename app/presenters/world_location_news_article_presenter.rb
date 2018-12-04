class WorldLocationNewsArticlePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Political
  include ContentItem::Linkable
  include ContentItem::Updatable
  include ContentItem::Shareable
  include ContentItem::TitleAndContext
  include ContentItem::Metadata

  def image
    content_item["details"].dig("image") || default_news_image || placeholder_image
  end

private

  def default_news_image
    organisation = content_item["links"].dig("primary_publishing_organisation")
    organisation[0].dig("details", "default_news_image") if organisation.present?
  end

  def placeholder_image
    "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg"
  end
end
