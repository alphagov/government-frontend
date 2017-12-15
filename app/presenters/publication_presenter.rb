class PublicationPresenter < ContentItemPresenter
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::Political

  def details
    content_item["details"]["body"]
  end

  def documents
    documents_list.join('')
  end

  def documents_count
    documents_list.size
  end

  def national_statistics?
    document_type === "national_statistics"
  end

  # FIXME: This is a temporary removal of National Applicability
  # Once all formats have moved to new publisher/important metadata
  # components, we can remove here: app/presenters/content_item/national_applicability.rb:33
  def publisher_metadata
    super.tap { |m| m[:other].delete(:"Applies to") }
  end

private

  def documents_list
    content_item["details"]["documents"]
  end
end
