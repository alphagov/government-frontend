class ContactPresenter < ContentItemPresenter
  include TitleAndContext

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
      t.delete(:context)
    end
  end

  def related_items
    sections = []
    sections << {
      title: "Elsewhere on GOV.UK",
      items: quick_links
    } if quick_links.any?

    sections << {
      title: "Other contacts",
      items: related_contacts_links
    } if related_contacts_links.any?

    {
      sections: sections
    }
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
    related = content_item["links"]["related"] || []
    related.map do |link|
      {
        title: link["title"],
        url:  link["base_path"]
      }
    end
  end

  def quick_links
    quick = content_item["details"]["quick_links"] || []
    quick.map do |link|
      {
        title: link["title"],
        url:  link["url"]
      }
    end
  end
end
