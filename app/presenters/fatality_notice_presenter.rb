class FatalityNoticePresenter < ContentItemPresenter
  def field_of_operation
    content_item["links"]["field_of_operation"].first["title"]
  end
end
