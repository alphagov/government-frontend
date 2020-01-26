class PublicationPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::NationalStatisticsLogo
  include ContentItem::Political

  def details
    content_item["details"]["body"]
  end

  def documents
    documents_list.join("")
  end

  def documents_count
    documents_list.size
  end

  def national_statistics?
    document_type == "national_statistics"
  end

private

  def documents_list
    content_item["details"]["documents"]
  end
end
