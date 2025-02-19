class CaseStudyPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Metadata
  include ContentItem::HeadingAndContext

  def image
    content_item["details"]["image"]
  end

  def page_title
    "#{super} - #{I18n.t("content_item.schema_name.#{document_type}", count: 1)}"
  end
end
