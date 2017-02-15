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

  def online_form_links
    content_item["details"]["contact_form_links"].map do |link|
      {
        url: link['link'],
        title: link['title'],
        description: link['description'].html_safe
      }
    end
  end

  def online_form_body
    content_item["details"]["more_info_contact_form"].html_safe
  end

  def online_forms?
    online_form_links.any?
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
