class TakePartPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::TitleAndContext

  def image
    content_item["details"]["image"]
  end

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
    end
  end
end
