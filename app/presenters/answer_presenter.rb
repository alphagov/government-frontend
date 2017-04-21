class AnswerPresenter < ContentItemPresenter
  include Linkable

  def body
    content_item["details"]["body"]
  end

  def updated
    display_date(content_item["public_updated_at"]) if content_item["public_updated_at"]
  end
end
