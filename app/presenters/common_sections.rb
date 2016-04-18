module CommonSections
  def from
    links("lead_organisations") + links("supporting_organisations") + links("worldwide_organisations")
  end

  def published
    display_time(content_item["details"]["first_public_at"])
  end

  def updated
    display_time(content_item["public_updated_at"]) if any_updates?
  end

  def short_history
    if any_updates?
      "#{I18n.t('content_item.metadata.updated')} #{updated}"
    else
      "#{I18n.t('content_item.metadata.published')} #{published}"
    end
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

private

  def any_updates?
    if (first_public_at = content_item["details"]["first_public_at"]).present?
      DateTime.parse(content_item["public_updated_at"]) != DateTime.parse(first_public_at)
    else
      false
    end
  end

  def links(type)
    return [] unless content_item["links"][type]
    content_item["links"][type].map do |link|
      link_to(link["title"], link["base_path"])
    end
  end
end
