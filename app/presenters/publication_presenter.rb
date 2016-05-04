class PublicationPresenter < ContentItemPresenter
  include Political
  include Linkable
  include Updatable
  include Withdrawable
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

private

  def documents_list
    content_item["details"]["documents"]
  end
end
