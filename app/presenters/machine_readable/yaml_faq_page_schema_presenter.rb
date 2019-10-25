module MachineReadable
  class YamlFaqPageSchemaPresenter
    attr_reader :content_item, :config_file

    def self.configured?(content_item)
      File.exist?(config_path(content_item))
    end

    def self.config_path(content_item)
      CONFIG_PATH.join(content_item.slug + ".yml").to_s
    end

    def initialize(content_item)
      @content_item = content_item
      @config_file = YAML.load_file(YamlFaqPageSchemaPresenter.config_path(content_item))
    end

    def structured_data
      # http://schema.org/FAQPage
      {
        "@context" => "http://schema.org",
        "@type" => "FAQPage",
        "headline" => config_file["title"],
        "description" => config_file["preamble"],
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

    CONFIG_PATH = Rails.root.join("config/machine_readable/").freeze

    def main_entity
      {
        "mainEntity" => questions_and_answers,
      }
    end

    def questions_and_answers
      config_file["faqs"].each_with_index.map do |faq|
        {
          "@type" => "Question",
          "name" => faq["question"],
          "acceptedAnswer" => {
            "@type" => "Answer",
            "text" => faq["answer"],
          },
        }
      end
    end

    def logo_url
      image_url("govuk_publishing_components/govuk-logo.png")
    end

    def image_url(image_file)
      ActionController::Base.helpers.asset_url(image_file, type: :image)
    end
  end
end
