class FatalityNoticePresenter < ContentItemPresenter
  include Metadata

  def field_of_operation
    attributes = content_item["links"]["field_of_operation"].first
    OpenStruct.new(title: attributes["title"], path: attributes["base_path"])
  end

  def image
    { "url" => ActionController::Base.helpers.asset_url("ministry-of-defence-crest.png"), "alt_text" => "Ministry of Defence crest" }
  end

  def metadata
    super.tap do |m|
      m[:other] = {
        "Field of operation" => link_to(field_of_operation.title, field_of_operation.path)
      }
    end
  end

  def body
    content_item['details']['body']
  end
end
