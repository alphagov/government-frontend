class PublicationPresenter < ContentItemPresenter
  include Linkable
  include NationalApplicability
  include Political
  include Updatable
  include ActionView::Helpers::UrlHelper

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

private

  def documents_list
    content_item["details"]["documents"]
  end
end
