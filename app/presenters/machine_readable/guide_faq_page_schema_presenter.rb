module MachineReadable
  class GuideFaqPageSchemaPresenter
    attr_reader :guide

    def initialize(guide)
      @guide = guide
    end

    def structured_data
      # http://schema.org/FAQPage
      {
        "@context" => "http://schema.org",
        "@type" => "FAQPage",
        "headline" => guide.title,
        "description" => guide.description,
        "publisher" => {
          "@type" => "Organization",
          "name" => "GOV.UK",
          "url" => "https://www.gov.uk",
          "logo" => {
            "@type" => "ImageObject",
            "url" => logo_url,
          },
        },
      }
      .merge(main_entity)
    end

  private

    def main_entity
      {
        "mainEntity" => questions_and_answers,
      }
    end

    def questions_and_answers
      guide.parts.each_with_index.map do |part, index|
        part_url = part_url(part, index)

        {
          "@type" => "Question",
          "name" => part["title"],
          "url" => part_url,
          "acceptedAnswer" => {
            "@type" => "Answer",
            "url" => part_url,
            "text" => part["body"],
          },
        }
      end
    end

    def part_url(part, index)
      if index.zero?
        guide_url
      else
        guide_url + "/" + part["slug"]
      end
    end

    def guide_url
      Plek.new.website_root + guide.base_path
    end

    def logo_url
      image_url("govuk_publishing_components/govuk-logo.png")
    end

    def image_url(image_file)
      ActionController::Base.helpers.asset_url(image_file, type: :image)
    end
  end
end
