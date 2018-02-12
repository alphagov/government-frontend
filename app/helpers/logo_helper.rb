module LogoHelper
  def content_logo(presenter)
    css_class = "metadata-logo"
    image_url = presenter.content_item.dig("details", "image", "url")

    if image_url
      return image_tag image_url, class: css_class
    elsif presenter.try(:national_statistics?)
      return image_tag "national-statistics.png", alt: "National Statistics", class: css_class
    end
  end
end
