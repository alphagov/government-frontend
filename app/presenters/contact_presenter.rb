class ContactPresenter < ContentItemPresenter
  def related_items
    [
      {
        title: "Elsewhere on GOV.UK",
        items: quick_links
      },
      {
        title: "Other contacts",
        items: related_contacts_links
      }
    ]
  end

private

  def related_contacts_links
    content_item["links"]["related"].map do |link|
      {
        title: link["title"],
        url:  link["base_path"]
      }
    end
  end

  def quick_links
    content_item["details"]["quick_links"].map do |link|
      {
        title: link["title"],
        url:  link["url"]
      }
    end
  end
end
