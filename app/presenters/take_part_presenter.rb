class TakePartPresenter < ContentItemPresenter
  def body
    content_item["details"]["body"]
  end

  def image
    content_item["details"]["image"]
  end
end
