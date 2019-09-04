class FAQPagePresenter
  attr_reader :content_item, :image_placeholder_urls, :logo_url

  def initialize(content_item, logo_url, image_placeholder_urls)
    @content_item = content_item
    @logo_url = logo_url
    @image_placeholder_urls = image_placeholder_urls
  end

  def structured_data
    {
      "@context": "http://schema.org",
      "@type": "FAQPage",
      "primaryImageOfPage": govuk_image,
      "headline": content_item.title,
      "description": content_item.description,
      "image": image_placeholder_urls,
      "author": gds_organisation,
      "publisher": govuk_organisation,
      "mainEntity": questions_and_answers,
    }
  end

private

  def govuk_image
    @govuk_image ||= {
      "@type": "ImageObject",
      "name": logo_url
    }
  end

  def govuk_organisation
    {
      "@type": "Organization",
      "name": "GOV.UK",
      "url": "https://www.gov.uk",
      "logo": govuk_image
    }
  end

  def gds_organisation
    {
      "@type": "Organization",
      "name": "Government Digital Service",
      "url": "https://www.gov.uk/government/organisations/government-digital-service",
      "logo": govuk_image
    }
  end

  def questions_and_answers
    content_item.parts.map do |part|
      {
        "@type": "Question",
        "author": gds_organisation,
        "image": govuk_image,
        "name": part['title'],
        "url": page_url(part),
        "acceptedAnswer": {
          "@type": "Answer",
          "author": gds_organisation,
          "url": page_url(part),
          "text": part['body']
        }
      }
    end
  end

  def page_url(part)
    URI.join(Plek.new.website_root, content_item.base_path, part['slug'])
  end

  def image_url(image_path)
    ActionController::Base.helpers.image_url(image_path)
  end
end
