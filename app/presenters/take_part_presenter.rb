class TakePartPresenter < ContentItemPresenter
  include TitleAndContext

  def body
    content_item["details"]["body"]
  end

  def image
    content_item["details"]["image"]
  end

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
    end
  end
end
