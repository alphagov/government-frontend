class TopicalEventAboutPagePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::HeadingAndContext

  def heading_and_context
    super.tap do |t|
      t[:font_size] = "xl"
      t.delete(:context)
    end
  end
end
