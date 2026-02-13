module ContentItem
  module Shareable
    include ERB::Util

    def share_links
      [
        {
          href: facebook_share_url,
          text: "Facebook",
          icon: "facebook",
        },
      ]
    end

  private

    def facebook_share_url
      "https://www.facebook.com/sharer/sharer.php?u=#{share_url}"
    end

    def share_url
      url_encode(Plek.new.website_root + content_item["base_path"])
    end
  end
end
