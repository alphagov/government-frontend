class HtmlPublicationPresenter < ContentItemPresenter
  include OrganisationBranding

  def body
    content_item["details"]["body"]
  end

  def contents?
    contents && contents != '<ol></ol>'
  end

  def contents
    content_item["details"]["headings"].html_safe
  end

  def format_sub_type
    parent["document_type"]
  end

  def last_changed
    timestamp = display_date(content_item["details"]["public_timestamp"])

    # This assumes that a translation doesn't need the date to come beforehand.
    if content_item["details"]["first_published_version"]
      "#{I18n.t('content_item.metadata.published')} #{timestamp}"
    else
      "#{I18n.t('content_item.metadata.updated')} #{timestamp}"
    end
  end

  def organisations
    (content_item["links"]["organisations"] || {}).sort_by { |o| o["title"] }
  end

  def organisation_logo(organisation)
    super.tap do |logo|
      if organisations.count > 1
        logo[:organisation].delete(:image)
      end
    end
  end
end
