class DetailedGuidePresenter < ContentItemPresenter
  include ExtractsHeadings
  include ActionView::Helpers::UrlHelper
  include CommonSections

  def body
    content_item["details"]["body"]
  end

  def breadcrumbs
    e = parent
    res = []

    while e
      res << { title: e["title"], url: e["base_path"] }
      e = e["parent"] && e["parent"].first
    end

    res.reverse
  end

  def contents
    extract_headings_with_ids(body).map do |heading|
      link_to(heading[:text], "##{heading[:id]}")
    end
  end

  def context
    parent["title"]
  end

  def part_of
    links("document_collections") + links("related_policies") + links("worldwide_priorities") + links("world_locations") + links("topics")
  end

private

  def parent
    content_item["links"]["parent"][0]
  end
end
