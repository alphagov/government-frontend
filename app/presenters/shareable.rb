module Shareable
  include ERB::Util

  def share_urls
    {
      facebook: facebook_share_url,
      twitter: twitter_share_url
    }
  end

private

  def facebook_share_url
    "https://www.facebook.com/sharer/sharer.php?u=#{share_url}"
  end

  def twitter_share_url
    "https://twitter.com/share?url=#{share_url}&text=#{url_encode(title)}"
  end

  def share_url
    url_encode(ENV['WEBSITE_ROOT'] + content_item["base_path"])
  end
end
