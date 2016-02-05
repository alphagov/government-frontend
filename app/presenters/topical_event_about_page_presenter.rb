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
    title = archived_topical_event? ? "#{parent['title']} (Archived)" : parent["title"]

    [
      {title: "Home", url: "/"},
      {title: title, url: parent["base_path"]}
    ]
  end

private

  def topical_event
    content_item["links"]["parent"][0]
  end

  def topical_event_end_date
    topical_event["details"]["end_date"]
  end

  def archived_topical_event?
    topical_event_end_date && DateTime.parse(topical_event_end_date) <= Date.today
  end
end
