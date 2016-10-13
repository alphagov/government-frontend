class DetailedGuidePresenter < ContentItemPresenter
  include ExtractsHeadings
  include Linkable
  include NationalApplicability
  include Political
  include Updatable
  include ActionView::Helpers::UrlHelper

  def body
    content_item["details"]["body"]
  end

  def contents
    extract_headings_with_ids(body).map do |heading|
      link_to(heading[:text], "##{heading[:id]}")
    end
  end

  def context
    parent["title"]
  end

  def related_guides
    links("related_guides")
  end

  def related_mainstream_content
    links("related_mainstream_content")
  end

  def image
    content_item["details"]["image"]["url"] if content_item["details"]["image"]
  end
end
