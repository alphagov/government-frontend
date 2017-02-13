module CorporateInformationGroups
  include Linkable

  def corporate_information?
    corporate_information_groups.any?
  end

  def corporate_information
    corporate_information_groups.map do |group|
      {
        heading: content_tag(:h3, group["name"], id: group_title_id(group["name"])),
        links: normalised_group_links(group)
      }
    end
  end

  def corporate_information_heading_tag
    content_tag(:h2, corporate_information_heading[:text], id: corporate_information_heading[:id])
  end

private

  def corporate_information_heading
    heading_text = "Corporate information"

    {
      text: heading_text,
      id: group_title_id(heading_text)
    }
  end

  def group_title_id(title)
    title.tr(' ', '-').downcase
  end

  def normalised_group_links(group)
    group["contents"].map do |group_item|
      normalised_group_item_link(group_item)
    end
  end

  def normalised_group_item_link(group_item)
    if group_item.is_a?(String)
      group_item_link = corporate_information_page_links.find { |l| l["content_id"] == group_item }
      link_to(group_item_link["title"], group_item_link["base_path"])
    else
      link_to(group_item["title"], group_item["path"] || group_item["url"])
    end
  end

  def corporate_information_page_links
    expanded_links_from_content_item('corporate_information_pages')
  end

  def corporate_information_groups
    content_item["details"]["corporate_information_groups"] || []
  end
end
