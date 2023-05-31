module WorldwideOrganisation
  class LinkedContactPresenter
    include ActionView::Helpers::TagHelper

    attr_reader :details

    def initialize(content_item)
      @details = content_item.with_indifferent_access["details"]
    end

    def post_address
      address = details["post_addresses"]&.first
      return if address.nil?

      formatted_address = Govspeak::HCardPresenter.new(address.symbolize_keys).render

      tag.address formatted_address, class: %w[govuk-body]
    end

    def email
      email_address = details["email_addresses"]&.first

      email_address&.dig("email")
    end

    def contact_form_link
      contact_form_link = details["contact_form_links"]&.first

      contact_form_link&.dig("link")
    end

    def phone_numbers
      details["phone_numbers"]
    end

    def comments
      tag.p(details["description"].gsub("\r\n", "<br/>").html_safe, class: %w[govuk-body]) if details["description"].present?
    end
  end
end
