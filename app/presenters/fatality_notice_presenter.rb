class FatalityNoticePresenter < ContentItemPresenter
  include ActionView::Helpers::UrlHelper
  include Linkable
  include Updatable

  def context
    field_of_operation = content_item["links"]["field_of_operation"][0]['title']
    "Operations in #{field_of_operation}"
  end

  def body
    content_item["details"]["body"]
  end

  def field_of_operation
    links("field_of_operation")
  end

  def image
    {
      'path' => 'mod-crest.png',
      'alt_text' => 'The MOD Crest'
    }
  end
end
