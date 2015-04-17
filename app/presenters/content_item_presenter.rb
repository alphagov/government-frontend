class ContentItemPresenter
  attr_reader :content_item, :title, :description, :body, :format, :format_display_type, :locale

  def initialize(content_item, view_context)
    @content_item = content_item
    @view_context = view_context

    @title = content_item["title"]
    @description = content_item["description"]
    @body = content_item["details"]["body"]
    @format = content_item["format"]
    @format_display_type = content_item["details"]["format_display_type"]
    @locale = content_item["locale"] || "en"
  end

  def from
    links("lead_organisations") + links("supporting_organisations") + links("worldwide_organisations")
  end

  def part_of
    links("document_collections") + links("related_policies") + links("worldwide_priorities") + links("world_locations")
  end

  def available_translations
    sorted_locales(@content_item["links"]["available_translations"])
  end

  def history
    return [] unless any_updates?
    content_item["details"]["change_history"].map do |item|
      {
        display_time: display_time(item["public_timestamp"]),
        note: item["note"],
        timestamp: item["public_timestamp"]
      }
    end
  end

  def published
    display_time(content_item["details"]["first_public_at"])
  end

  def updated
    if any_updates?
      display_time(content_item["public_updated_at"])
    end
  end

  def short_history
    if any_updates?
      "#{I18n.t('content_item.metadata.updated')} #{updated}"
    else
      "#{I18n.t('content_item.metadata.published')} #{published}"
    end
  end

  def image
    content_item["details"]["image"].presence || placeholder_image_data
  end

  def archived?
    content_item["details"].include? "archive_notice"
  end

  def page_title
    archived? ? "[Archived] #{title}" : title
  end


  def archive_notice
    notice = content_item["details"]["archive_notice"]
    {
      time: @view_context.content_tag(:time, display_time(notice["archived_at"]), datetime: notice["archived_at"]),
      explanation: notice["explanation"]
    }
  end

private

  def sorted_locales(translations)
    translations.sort_by { |t| t["locale"] == I18n.default_locale.to_s ? '' : t["locale"] }
  end

  def display_time(timestamp)
    I18n.l(Date.parse(timestamp), format: "%-d %B %Y") if timestamp
  end

  def any_updates?
    DateTime.parse(content_item["public_updated_at"]) != DateTime.parse(content_item["details"]["first_public_at"])
  end

  def links(type)
    return [] unless content_item["links"][type]
    content_item["links"][type].map do |link|
      @view_context.link_to(link["title"], link["base_path"])
    end
  end

  def placeholder_image_data
    {
      'url' => @view_context.url_to_image('placeholder.jpg'),
      'alt_text' => 'placeholder',
      'caption' => nil
    }
  end
end
