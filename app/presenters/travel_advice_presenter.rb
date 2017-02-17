class TravelAdvicePresenter < ContentItemPresenter
  def title_and_context
    {
      context: 'Foreign travel advice',
      title: country_name
    }
  end

  def related_items
    items = ordered_related_items.map do |link|
      {
        title: link["title"],
        url:  link["base_path"]
      }
    end

    {
      sections: [
        {
          title: 'Elsewhere on GOV.UK',
          items: items
        }
      ]
    }
  end

  def parts_navigation
    part_links.each_slice(part_navigation_group_size).to_a
  end

  def parts_navigation_second_list_start
    part_navigation_group_size + 1
  end

private

  def country_name
    content_item["details"]["country"]["name"]
  end

  def parts
    content_item["details"]["parts"] || []
  end

  def part_links
    links = [
      {
        title: 'Current travel advice',
        path: content_item["base_path"]
      }
    ]

    links + parts.map do |part|
      {
        title: part['title'],
        path: "#{content_item["base_path"]}/#{part['slug']}"
      }
    end
  end

  def part_navigation_group_size
    size = part_links.size.to_f / 2
    if size < 2
      3
    else
      size.ceil
    end
  end

  def ordered_related_items
    content_item["links"]["ordered_related_items"] || []
  end
end
