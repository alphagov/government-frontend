class PublicationPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::NationalStatisticsLogo
  include ContentItem::Political
  include ContentItem::FeaturedAttachmentsMigration

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

  def dataset?
    %(national_statistics official_statistics transparency).include? document_type
  end

private

  def documents_list
    @documents_list ||= choose_field(
      new_field_name: "featured_attachments",
      old_field_name: "documents",
    )
  end
end
