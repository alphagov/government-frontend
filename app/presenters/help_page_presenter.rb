class HelpPagePresenter < ContentItemPresenter
  include Linkable

  def body
    content_item["details"]["body"]
  end

  def related_items
    content_item["links"]["ordered_related_items"].map do |link|
      {
        title: link["title"],
        url:  link["base_path"]
      }
    end
  end
end
