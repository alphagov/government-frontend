module ContentItem
  module ContactDetails
    def email_address_groups
      content_item["details"]["email_addresses"] || []
    end

    def post_address_groups
      content_item["details"]["post_addresses"] || []
    end

    def phone_number_groups
      content_item["details"]["phone_numbers"] || []
    end

    def online_form_links
      contact_form_links = content_item["details"]["contact_form_links"] || []
      contact_form_links.map do |link|
        {
          url: link["link"],
          title: link["title"],
          description: link["description"].try(:html_safe),
        }.with_indifferent_access
      end
    end
  end
end
