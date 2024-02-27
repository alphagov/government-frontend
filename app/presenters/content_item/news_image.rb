module ContentItem
  module NewsImage
    def image
      content_item.dig("details", "image") || default_news_image || placeholder_image
    end

  private

    def default_news_image
      return first_worldwide_organisation_default_news_image if world_news_story?

      first_primary_publishing_organisation_default_news_image
    end

    def placeholder_image
      # this image has been uploaded to asset-manager
      if world_news_story?
        { "url" => "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg" }
      else
        { "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" }
      end
    end

    def first_worldwide_organisation_default_news_image
      worldwide_organisation = content_item.dig("links", "worldwide_organisations")
      worldwide_organisation[0].dig("details", "default_news_image") if worldwide_organisation.present?
    end

    def first_primary_publishing_organisation_default_news_image
      organisation = content_item.dig("links", "primary_publishing_organisation")
      organisation[0].dig("details", "default_news_image") if organisation.present?
    end

    def world_news_story?
      content_item["document_type"] == "world_news_story"
    end
  end
end
