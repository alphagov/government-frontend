class FatalityNoticePresenter < ContentItemPresenter
  include Linkable
  include Updatable

  def field_of_operation
    attributes = content_item["links"]["field_of_operation"].first
    OpenStruct.new(title: attributes["title"], path: attributes["base_path"])
  end

  def image
    { "url" => ActionController::Base.helpers.asset_url("ministry-of-defence-crest.png"), "alt_text" => "Ministry of Defence crest" }
  end

  def body
    content_item['details']['body']
  end
end
