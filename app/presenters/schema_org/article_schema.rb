module SchemaOrg
  class ArticleSchema
    def initialize(presenter)
      @presenter = presenter
    end

    def structured_data
      # http://schema.org/Article
      {
        "@context" => "http://schema.org",
        "@type" => "Article",
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
        }
      }.merge(image_schema).merge(author_schema)
    end

  private

    attr_reader :presenter

    def image_schema
      return {} unless image

      {
        "image" => [
          image["url"],
        ]
      }
    end

    def author_schema
      return {} unless publishing_organisation

      {
        "author" => {
          "@type" => "Organization",
          "name" => publishing_organisation["title"],
          "url" => Plek.current.website_root + publishing_organisation["base_path"],
        }
      }
    end

    def publishing_organisation
      presenter.content_item.dig("links", "primary_publishing_organisation").to_a.first
    end

    def page_url
      Plek.current.website_root + presenter.content_item["base_path"]
    end

    def image
      presenter.try(:image)
    end
  end
end
