module SchemaOrg
  class NewsArticleSchema
    def initialize(presenter)
      @presenter = presenter
    end

    def structured_data
      return {} unless enough_structured_data?

      # http://schema.org/NewsArticle
      {
        "@context" => "http://schema.org",
        "@type" => "NewsArticle",
        "mainEntityOfPage" => {
          "@type" => "WebPage",
          "@id" => page_url,
        },
        "headline" => presenter.title,
        "datePublished" => presenter.first_public_at,
        "dateModified" => presenter.public_updated_at,
        "description" => presenter.description,
        "publisher" => {
          "@type" => "Organization",
          "name" => "GOV.UK",
          "url" => "https://www.gov.uk",
          "logo" => {
            "@type" => "ImageObject",
            # TODO: change this to a better image, without the URL hard coded.
            "url" => "https://assets.publishing.service.gov.uk/static/opengraph-image-a1f7d89ffd0782738b1aeb0da37842d8bd0addbd724b8e58c3edbc7287cc11de.png",
          },
        },
        "image" => [
          image["url"],
        ],
        "author" => {
          "@type" => "Organization",
          "name" => publishing_organisation["title"],
          "url" => Plek.current.website_root + publishing_organisation["base_path"],
        },
      }
    end

  private

    attr_reader :presenter

    def enough_structured_data?
      # The author (for which we use the publishing org) and image are required
      # fields. If the news article doesn't have them, don't use structured data
      # at all.
      publishing_organisation && image
    end

    def publishing_organisation
      presenter.content_item.dig("links", "primary_publishing_organisation").to_a.first
    end

    def page_url
      Plek.current.website_root + presenter.content_item["base_path"]
    end

    def image
      presenter.image
    end
  end
end
