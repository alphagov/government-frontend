module ContentItem
  module BrexitNotice
    def has_brexit_notice?
      content_item.dig("details").key?("brexit_no_deal_notice")
    end

    def brexit_notice_component
      if has_brexit_notice?
        {
          title: brexit_notice_title,
          description: brexit_notice_description,
          link_intro: brexit_notice_link_intro,
          links: brexit_links,
          featured_link: brexit_landing_page_cta,
        }
      end
    end

  private

    def brexit_notice_links
      content_item.dig("details", "brexit_no_deal_notice")
    end

    def brexit_notice_title
      "This guidance has been withdrawn"
    end

    def brexit_notice_description
      "The Brexit transition period has ended and new rules now apply. This page has been withdrawn because it’s out of date. "
    end

    def brexit_notice_link_intro
      "For current information about what you need to do, read: "
    end

    def brexit_landing_page_cta
      data_attributes = {
        "module": "track-click",
        "track-category": "no_deal_notice",
        "track-action": "/transition",
        "track-label": "Get your personalised list of actions",
      }

      featured_link = view_context.link_to("other actions you need to take",
                                           "/transition",
                                           data: data_attributes,
                                           class: "govuk-link")

      ("You can also get a personalised list of the " + featured_link + ".").html_safe
    end

    def brexit_links
      brexit_notice_links.map do |link|
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
