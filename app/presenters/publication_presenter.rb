class PublicationPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::NationalStatisticsLogo
  include ContentItem::Political

  def details
    content_item["details"]["body"]
  end

  def documents
    content_item["details"]["documents"].to_a.join("")
  end

  def national_statistics?
    document_type == "national_statistics"
  end

  def dataset?
    %(national_statistics official_statistics transparency).include? document_type
  end
end
