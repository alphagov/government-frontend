module ContentItem
  module Shareable
    include ERB::Util

    def share_links
      [
        {
          href: facebook_share_url,
          text: '<span class="visually-hidden">Share on </span>Facebook'.html_safe,
          icon: 'facebook'
        },
        {
          href: twitter_share_url,
          text: '<span class="visually-hidden">Share on </span>Twitter'.html_safe,
          icon: 'twitter'
        }
      ]
    end

  private

    def facebook_share_url
      "https://www.facebook.com/sharer/sharer.php?u=#{share_url}"
    end

    def twitter_share_url
      "https://twitter.com/share?url=#{share_url}&text=#{url_encode(title)}"
    end

    def share_url
      url_encode(Plek.current.website_root + content_item["base_path"])
    end
  end
end
