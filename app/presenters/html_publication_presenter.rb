class HtmlPublicationPresenter < ContentItemPresenter
  def body
    content_item["details"]["body"]
  end

  def contents
    content_item["details"]["headings"].html_safe
  end

  def format_sub_type
    parent["document_type"]
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

  def parent_base_path
    parent["base_path"]
  end

  def organisations
    content_item["links"]["organisations"].sort_by { |o| o["title"] }
  end

  # HACK: Replaces the organisation_brand for executive office organisations.
  # Remove this in the future after migrating organisations to the content store API,
  # and updating them with the correct brand in the actual store.
  def organisation_brand(organisation)
    brand = organisation["details"]["brand"]
    brand = "executive-office" if organisation["details"]["logo"]["crest"] == "eo"
    brand
  end
end
