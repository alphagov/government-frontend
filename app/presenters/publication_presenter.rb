class PublicationPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::NationalStatisticsLogo
  include ContentItem::Political
  include ContentItem::Attachments
  include ContentItem::SinglePageNotificationButton

  def details
    content_item["details"]["body"]
  end

  def attachments_for_components
    documents.select { |doc| featured_attachments.include? doc["id"] }
  end

  def documents
    return [] unless content_item["details"]["attachments"]

    docs = content_item["details"]["attachments"].select { |a| !a.key?("locale") || a["locale"] == locale }
    docs.each do |doc|
      doc["type"] = "html" unless doc["content_type"]
      doc["type"] = "external" if doc["attachment_type"] == "external"
      doc["preview_url"] = "#{doc['url']}/preview" if doc["preview_url"]
      doc["alternative_format_contact_email"] = nil if doc["accessible"] == true
    end
  end

  def featured_attachments
    content_item["details"]["featured_attachments"].to_a
  end

  def national_statistics?
    document_type == "national_statistics"
  end

  def dataset?
    %(national_statistics official_statistics transparency).include? document_type
  end
end
