class TopicalEventAboutPagePresenter < ContentItemPresenter
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

  def breadcrumbs
    parent = topical_event
    [
      {title: "Home", url: "/"},
      {title: parent["title"], url: parent["base_path"]}
    ]
  end

private

  def topical_event
    content_item["links"]["parent"][0]
  end
end
