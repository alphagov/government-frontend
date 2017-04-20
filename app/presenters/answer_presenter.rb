class AnswerPresenter < ContentItemPresenter
  include Linkable

  def body
    content_item["details"]["body"]
  end
end
