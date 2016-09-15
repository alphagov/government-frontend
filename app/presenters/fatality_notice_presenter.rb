class FatalityNoticePresenter < ContentItemPresenter
  include Linkable
  include Updatable

  def field_of_operation
    attributes = content_item["links"]["field_of_operation"].first
    OpenStruct.new(title: attributes["title"], path: attributes["base_path"])
  end

  def body
    content_item['details']['body']
  end
end
