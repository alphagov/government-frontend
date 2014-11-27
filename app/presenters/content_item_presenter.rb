class ContentItemPresenter
  include ActionView::Helpers::UrlHelper

  attr_reader :content_item, :title, :description, :body, :format, :context

  def initialize(content_item)
    @content_item = content_item

    @title = content_item["title"]
    @description = content_item["description"]
    @body = content_item["details"]["body"]
    @format = content_item["format"]
    @context = I18n.t("content_item.format.#{content_item["details"]["format_display_type"]}", count: 10)
  end

  def from
    links("lead_organisations") + links("supporting_organisations")
  end

  def part_of
    []
  end

  def history
    return [] unless any_updates?
    @content_item["details"]["change_history"].map do |item|
      {
        display_time: display_time(item["public_timestamp"]),
        note: item["note"],
        timestamp: item["public_timestamp"]
      }
    end
  end

  def published
    display_time(@content_item["details"]["first_public_at"])
  end

  def updated
    if any_updates?
      display_time(@content_item["public_updated_at"])
    end
  end

  def short_history
    if any_updates?
      "Updated #{updated_at}"
    else
      "Published #{published}"
    end
  end

  def image
    @content_item["details"]["image"]
  end

private
  def display_time(timestamp)
    Date.parse(timestamp).strftime("%-d %B %Y") if timestamp
  end

  def any_updates?
    Date.parse(@content_item["public_updated_at"]) != Date.parse(@content_item["details"]["first_public_at"])
  end

  def links(type)
    return [] unless @content_item["links"][type]
    @content_item["links"][type].map do |link|
      link_to(link["title"], link["base_path"])
    end
  end
end
