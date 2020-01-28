module ContentItem
  module NoDealNotice
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include ActionView::Context

    def has_no_deal_notice?
      content_item.dig("details").has_key?("brexit_no_deal_notice")
    end

    def no_deal_notice_component
      if has_no_deal_notice?
        {
          title: no_deal_notice_title,
          description: no_deal_notice_description,
          link_intro: no_deal_notice_link_intro,
          links: no_deal_links,
        }
      end
    end

  private

    def no_deal_notice_links
      content_item.dig("details", "brexit_no_deal_notice")
    end

    def no_deal_notice_title
      "The UK is leaving the EU"
    end

    def no_deal_notice_description
      "This page tells you what you will need to do from January 2021. <a class='govuk-link' href='/email-signup?topic=%2Ftransition'>Sign up for email alerts</a> to find out when it is updated.".html_safe
    end

    def no_deal_notice_link_intro
      "For current information, read: "
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
