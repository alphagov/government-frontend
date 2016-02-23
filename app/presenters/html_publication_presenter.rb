class HtmlPublicationPresenter < ContentItemPresenter
  def body
    content_item["details"]["body"]
  end

  def contents
    content_item["details"]["headings"].html_safe
  end

  def format_sub_type
    content_item["links"]["parent"][0]["format_sub_type"]
  end

  def last_changed
    timestamp = display_time(content_item["details"]["public_timestamp"])

    # This assumes that a translation doesn't need the date to come beforehand.
    if content_item["details"]["first_published_version"]
      "#{I18n.t('content_item.metadata.published')} #{timestamp}"
    else
      "#{I18n.t('content_item.metadata.updated')} #{timestamp}"
    end
  end
end
