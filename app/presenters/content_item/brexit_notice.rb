module ContentItem
  module BrexitNotice
    def has_no_deal_notice?
      content_item.dig("details").key?("brexit_no_deal_notice")
    end

    def has_current_state_notice?
      content_item.dig("details").key?("brexit_current_state_notice")
    end

    def notice_type
      @notice_type ||=
        if has_no_deal_notice?
          "brexit_no_deal_notice"
        elsif has_current_state_notice?
          "brexit_current_state_notice"
        end
    end

    def brexit_notice_component
      if notice_type
        {
          title: notice_title,
          description: notice_description,
          link_intro: link_intro,
          links: formatted_links,
          featured_link: landing_page_cta,
        }
      end
    end

  private

    def notice_details
      @notice_details ||=
        content_item.dig("details", notice_type)
    end

    def notice_title
      @notice_title ||=
        notice_type == "brexit_no_deal_notice" ? "New rules for January 2021" : "Brexit transition: new rules for 2021"
    end

    def notice_description
      @notice_description ||=
        notice_type == "brexit_no_deal_notice" ? no_deal_notice_description : current_state_notice_description
    end

    def no_deal_notice_description
      ["The UK has left the EU, and the transition period after Brexit comes to an end this year.",
       "This page tells you what you'll need to do from 1 January 2021. It will be updated if anything changes."]
    end

    def current_state_notice_description
      ["The UK has left the EU. This page tells you the new rules from 1 January 2021",
       "It will be updated if there is new information that affects what you need to do."]
    end

    def link_intro
      "For current information, read: "
    end

    def featured_link_data_attributes
      notice_type.slice!("brexit_")
      {
        "module": "track-click",
        "track-category": notice_type,
        "track-action": "/transition",
        "track-label": "the transition period",
      }
    end

    def featured_link
      view_context.link_to("the transition period", "/transition", data: featured_link_data_attributes, class: "govuk-link")
    end

    def featured_link_intro
      formatted_links.any? ? "You can also read about" : "Check what else you need to do during"
    end

    def landing_page_cta
      (featured_link_intro + " " + featured_link + ".").html_safe
    end

    def link_data_attributes(link)
      notice_type.slice!("brexit_")
      {
        "module": "track-click",
        "track-category": notice_type,
        "track-action": link["href"],
        "track-label": link["title"],
      }
    end

    def formatted_links
      notice_details.map do |link|
        {
          title: link["title"],
          href: link["href"],
          data_attributes: link_data_attributes(link),
        }
      end
    end
  end
end
