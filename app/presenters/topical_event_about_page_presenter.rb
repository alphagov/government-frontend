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

  # Old topical event pages have a "archived" string appended to their title
  # which we also include in the breadcrumbs of topical event about pages
  # for example: https://www.gov.uk/government/topical-events/ebola-virus-government-response/about
  def breadcrumbs
    result = super
    result.last[:title] = parent['title']
    result
  end

private

  def parent
    topical_event_end_date = super["details"]["end_date"]

    if topical_event_end_date && DateTime.parse(topical_event_end_date) <= Date.today
      super.merge("title" => "#{super['title']} (Archived)")
    else
      super
    end
  end
end
