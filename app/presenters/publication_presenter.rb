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

  def hide_from_search_engines?
    # this is a temporary hack and should be removed in approx 3 months
    return true if content_item["base_path"] == "/government/publications/pension-credit-claim-form--2"

    mobile_paths = %w[
      /government/publications/govuk-app-terms-and-conditions
      /government/publications/govuk-app-privacy-notice-how-we-use-your-data
      /government/publications/govuk-app-test-privacy-notice-how-we-use-your-data
      /government/publications/accessibility-statement-for-the-govuk-app
    ]
    mobile_paths.include?(content_item["base_path"])
  end
end
