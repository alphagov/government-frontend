module ContentItem
  module NoDealNotice
    def has_no_deal_notice?
      content_item.dig("details").key?("brexit_no_deal_notice")
    end

    def no_deal_notice_component
      if has_no_deal_notice?
        {
          title: no_deal_notice_title,
          description: no_deal_notice_description,
          link_intro: no_deal_notice_link_intro,
          links: no_deal_links,
          featured_link: no_deal_landing_page_cta,
        }
      end
    end

  private

    def no_deal_notice_links
      content_item.dig("details", "brexit_no_deal_notice")
    end

    def no_deal_notice_title
      "The UK has left the EU and the transition period after Brexit comes to an end this year."
    end

    def no_deal_notice_description
      "This page tells you what you'll need to do from 1 January 2021. It will be updated if anything changes."
    end

    def no_deal_notice_link_intro
      "For current information, read: "
    end

    def no_deal_landing_page_cta
      data_attributes = {
        "module": "track-click",
        "track-category": "no_deal_notice",
        "track-action": "/transition",
        "track-label": "the transition period",
      }

      featured_link = view_context.link_to("the transition period", "/transition", data: data_attributes, class: "govuk-link")
      featured_link_intro = no_deal_notice_links.any? ? "You can also read about" : "Check what else you need to do during"

      (featured_link_intro + " " + featured_link + ".").html_safe
    end

    def no_deal_links
      no_deal_notice_links.map do |link|
        {
          title: link["title"],
          href: link["href"],
          data_attributes: {
            "module": "track-click",
            "track-category": "no_deal_notice",
            "track-action": link["href"],
            "track-label": link["title"],
          },
        }
      end
    end
  end
end
