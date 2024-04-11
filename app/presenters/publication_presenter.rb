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
    return [] unless content_item["details"]["attachments"]

    docs = content_item["details"]["attachments"].select { |a| a["locale"] == locale }
    docs.each { |t| t["type"] = "html" unless t["content_type"] }
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
