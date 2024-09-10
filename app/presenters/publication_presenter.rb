class PublicationPresenter < ContentItemPresenter
  include ContentItem::Attachments
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::NationalStatisticsLogo
  include ContentItem::Political
  include ContentItem::SinglePageNotificationButton

  def details
    content_item["details"]["body"]
  end

  def attachments_for_components
    attachments_from(content_item["details"]["featured_attachments"])
  end

  def attachments_with_details
    attachments_for_components.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }.count
  end

  def national_statistics?
    document_type == "national_statistics"
  end

  def dataset?
    %(national_statistics official_statistics transparency).include? document_type
  end

  # this is a temporary hack and should be removed in approx 3 months
  def hide_from_search_engines?
    content_item["base_path"] == "/government/publications/pension-credit-claim-form--2"
  end
end
