module ContentItem
  module NewsImage
    def image
      content_item.dig("details", "image") || default_news_image || placeholder_image
    end

  private

    def default_news_image
      organisation = content_item.dig("links", "primary_publishing_organisation")
      organisation[0].dig("details", "default_news_image") if organisation.present?
    end

    def placeholder_image
      { "url" => "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg" }
    end
  end
end
