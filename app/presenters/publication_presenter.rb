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

  def documents
    docs = content_item["details"]["attachments"].select { |a| a["locale"] == locale }
    docs.each do |doc|
      doc.delete("alternative_format_contact_email") if doc["accessible"] == true
    end
    docs
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
