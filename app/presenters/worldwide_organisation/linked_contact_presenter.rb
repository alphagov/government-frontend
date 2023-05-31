module WorldwideOrganisation
  class LinkedContactPresenter
    include ActionView::Helpers::TagHelper
    include ContentItem::ContactDetails

    attr_reader :content_item

    def initialize(content_item)
      @content_item = content_item
    end

    def title
      content_item["details"]["title"]
    end

    def post_address
      address = post_address_groups&.first
      return if address.nil?

      formatted_address = Govspeak::HCardPresenter.new(address.symbolize_keys).render

      tag.address formatted_address, class: %w[govuk-body]
    end

    def email
      email_address_groups.first&.dig("email")
    end

    def contact_form_link
      online_form_links.first&.dig("url")
    end

    def comments
      comments = content_item["details"]["description"]
      return if comments.nil?

      tag.p(comments.gsub("\r\n", "<br/>").html_safe, class: %w[govuk-body])
    end
  end
end
