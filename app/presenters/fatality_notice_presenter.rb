class FatalityNoticePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::TitleAndContext
  include ContentItem::Metadata

  def field_of_operation
    content_item_links = content_item["links"]["field_of_operation"]
    if content_item_links
      attributes = content_item_links.first
      OpenStruct.new(title: attributes["title"], path: attributes["base_path"])
    end
  end

  def image
    { "url" => ActionController::Base.helpers.asset_url("ministry-of-defence-crest.png"), "alt_text" => "Ministry of Defence crest" }
  end

  def important_metadata
    super.tap do |m|
      if field_of_operation
        m.merge!('Field of operation' => link_to(field_of_operation.title, field_of_operation.path, class: "govuk-link app-link"))
      end
    end
  end

  def title_and_context
    super.tap do |t|
      if field_of_operation
        t[:context] = "Operations in #{field_of_operation.try(:title)}"
      end
    end
  end

  def page_title
    "#{super} - #{I18n.t("content_item.schema_name.#{document_type}", count: 1)}"
  end
end
