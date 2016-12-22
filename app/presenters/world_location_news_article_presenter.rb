class WorldLocationNewsArticlePresenter < ContentItemPresenter
  include ExtractsHeadings
  include Political
  include Withdrawable
  include Linkable
  include Updatable
  include Shareable

  def body
    content_item["details"]["body"]
  end

  def contents
    extract_headings_with_ids(body).map do |heading|
      link_to(heading[:text], "##{heading[:id]}")
    end
  end

  def image
    content_item["details"]["image"]
  end
end
