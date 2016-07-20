class DetailedGuidePresenter < ContentItemPresenter
  include Political
  include ExtractsHeadings
  include Linkable
  include Updatable
  include NationalApplicability
  include ActionView::Helpers::UrlHelper

  def body
    content_item["details"]["body"]
  end

  def breadcrumbs
    return [] unless parent

    direct_parent = parent
    ordered_parents = []

    while direct_parent
      ordered_parents.unshift(
        title: direct_parent["title"],
        url: direct_parent["base_path"],
      )
      direct_parent = direct_parent["parent"] && direct_parent["parent"].first
    end

    ordered_parents.unshift(title: "Home", url: "/")
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

  def related_mainstream
    links("related_mainstream")
  end
end
