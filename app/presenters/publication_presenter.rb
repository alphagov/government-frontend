class PublicationPresenter < ContentItemPresenter
  include Political
  include Linkable
  include Updatable
  include Withdrawable
  include ActionView::Helpers::UrlHelper

  def details
    content_item["details"]["body"]
  end
end
