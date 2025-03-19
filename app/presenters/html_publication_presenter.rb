class HtmlPublicationPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::OrganisationBranding
  include ContentItem::ContentsList
  include ContentItem::Political
  include ContentItem::NationalApplicability

  def isbn
    content_item["details"]["isbn"]
  end

  def copyright_year
    content_item["details"]["public_timestamp"].to_date.year if public_timestamp.present?
  end

  def format_sub_type
    if parent && parent["document_type"].present?
      parent["document_type"]
    else
      "publication"
    end
  end

  def last_changed
    timestamp = DateTimeHelper.display_date(public_timestamp)

    # This assumes that a translation doesn't need the date to come beforehand.
    if content_item["details"]["first_published_version"]
      "#{I18n.t('content_item.metadata.published')} #{timestamp}"
    else
      "#{I18n.t('content_item.metadata.updated')} #{timestamp}"
    end
  end

  def organisations
    content_item["links"]["organisations"] || []
  end

  def organisation_logo(organisation)
    super.tap do |logo|
      if logo && organisations.count > 1
        logo[:organisation].delete(:image)
      end
    end
  end

  def full_path(request)
    request.base_url + request.path
  end

  def exclude_main_wrapper_class?
    true
  end

  def hide_from_search_engines?
    PublicationPresenter::MOBILE_PATHS.any? { |path| content_item["base_path"].start_with?(path) }
  end

private

  def public_timestamp
    content_item["details"]["public_timestamp"]
  end

  def withdrawal_notice_context
    I18n.t("content_item.schema_name.#{format_sub_type}", count: 1)
  end
end
