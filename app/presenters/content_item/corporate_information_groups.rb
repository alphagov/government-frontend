module ContentItem
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

    def further_information
      [
        further_information_about("publication_scheme"),
        further_information_about("welsh_language_scheme"),
        further_information_about("personal_information_charter"),
        further_information_about("social_media_use"),
        further_information_about("about_our_services")
      ].join(' ').html_safe
    end

  private

    def further_information_link(type)
      link = corporate_information_page_links.find { |l| l["document_type"] == type }
      link_to(link["title"], link["base_path"]) if link
    end

    def further_information_about(type)
      link = further_information_link(type)
      I18n.t("corporate_information_page.#{type}_html", link: link) if link
    end

    def corporate_information_heading
      heading_text = I18n.t('corporate_information_page.corporate_information')

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
end
