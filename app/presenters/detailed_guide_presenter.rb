class DetailedGuidePresenter < ContentItemPresenter
  include ExtractsHeadings
  include ActionView::Helpers::UrlHelper

  def body
    content_item["details"]["body"]
  end

  def contents
    extract_headings_with_ids(body).map do |heading|
      link_to(heading[:text], "##{heading[:id]}")
    end
  end
end
