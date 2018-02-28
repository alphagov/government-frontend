class ContactPresenter < ContentItemPresenter
  include ContentItem::TitleAndContext

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
      t.delete(:context)
    end
  end

  def related_items
    sections = []
    if quick_links.any?
      sections << {
        title: "Elsewhere on GOV.UK",
        items: quick_links
      }
    end

    if related_contacts_links.any?
      sections << {
        title: "Other contacts",
        items: related_contacts_links
      }
    end

    {
      sections: sections
    }
  end

  def online_form_links
    contact_form_links = content_item["details"]["contact_form_links"] || []
    contact_form_links.map do |link|
      {
        url: link['link'],
        title: link['title'],
        description: link['description'].try(:html_safe)
      }
    end
  end

  def online_form_body
    content_item.dig("details", "more_info_contact_form").try(:html_safe)
  end

  def phone
    phone_number_groups.map do |group|
      {
        numbers: phone_numbers_in_group(group),
        title: group['title'],
        description: group['description'].try(:strip).try(:html_safe),
        opening_times: group['open_hours'].try(:strip).try(:html_safe),
        best_time_to_call: group['best_time_to_call'].try(:strip).try(:html_safe)
      }
    end
  end

  def phone_body
    content_item.dig("details", "more_info_phone_number").try(:html_safe)
  end

  def post
    post_address_groups.map do |group|
      details = {
        description: group['description'].try(:strip).try(:html_safe),
        v_card: [
          v_card_part('fn', group['title']),
          v_card_part('street-address', group['street_address']),
          v_card_part('locality', group['locality']),
          v_card_part('region', group['region']),
          v_card_part('postal-code', group['postal_code']),
          v_card_part('country-name', group['world_location']),
        ]
      }

      details[:v_card].select! { |v| v[:value].present? }
      details
    end
  end

  def post_body
    content_item.dig("details", "more_info_post_address").try(:html_safe)
  end

  def email
    email_address_groups.map do |group|
      details = {
        description: group['description'].try(:strip).try(:html_safe),
        email: group['email'].strip,
        v_card: [v_card_part('fn', group['title'])],
      }

      details[:v_card].select! { |v| v[:value].present? }
      details
    end
  end

  def email_body
    content_item.dig("details", "more_info_email_address").try(:html_safe)
  end

  def show_webchat?
    webchat_ids.include?(content_item["base_path"])
  end

  def webchat_availability_url
    "https://www.tax.service.gov.uk/csp-partials/availability/#{webchat_id}"
  end

  def webchat_open_url
    "https://www.tax.service.gov.uk/csp-partials/open/#{webchat_id}"
  end

  def breadcrumbs
    return [] if content_item["links"]['organisations'].try(:length) != 1

    org         = content_item["links"]['organisations'].first
    title       = org['title']
    base        = org['base_path']
    contact_url = "#{base}/contact"

    [
      {
        title: "Home",
        url: "/",
      },
      {
        title: title,
        url: base,
      },
      {
        title: "Contact #{title}",
        url: contact_url,
      }
    ]
  end

private

  def phone_numbers_in_group(group)
    [
      {
        label: 'Telephone',
        number: group['number']
      },
      {
        label: 'Textphone',
        number: group['textphone']
      },
      {
        label: 'Outside UK',
        number: group['international_phone']
      },
      {
        label: 'Fax',
        number: group['fax']
      }
    ].select { |n| n[:number].present? }
  end

  def webchat_id
    webchat_ids[content_item["base_path"]]
  end

  def webchat_ids
    {
      '/government/organisations/hm-revenue-customs/contact/child-benefit' => 1027,
      '/government/organisations/hm-revenue-customs/contact/income-tax-enquiries-for-individuals-pensioners-and-employees' => 1030,
      '/government/organisations/hm-revenue-customs/contact/vat-online-services-helpdesk' => 1026,
      '/government/organisations/hm-revenue-customs/contact/national-insurance-numbers' => 1021,
      '/government/organisations/hm-revenue-customs/contact/self-assessment' => 1004,
      '/government/organisations/hm-revenue-customs/contact/tax-credits-enquiries' => 1016,
      '/government/organisations/hm-revenue-customs/contact/vat-enquiries' => 1028,
      '/government/organisations/hm-revenue-customs/contact/customs-international-trade-and-excise-enquiries' => 1034,
      '/government/organisations/hm-revenue-customs/contact/trusts' => 1036,
      '/government/organisations/hm-revenue-customs/contact/employer-enquiries' => 1023,
      '/government/organisations/hm-revenue-customs/contact/construction-industry-scheme' => 1048,
      '/government/organisations/hm-revenue-customs/contact/online-services-helpdesk' => 1003,
    }
  end

  def v_card_part(v_card_class, value)
    {
      v_card_class: v_card_class,
      value: value.try(:strip).try(:html_safe)
    }
  end

  def email_address_groups
    content_item["details"]["email_addresses"] || []
  end

  def post_address_groups
    content_item["details"]["post_addresses"] || []
  end

  def phone_number_groups
    content_item["details"]["phone_numbers"] || []
  end

  def related_contacts_links
    related = content_item["links"]["related"] || []
    related.map do |link|
      {
        title: link["title"],
        url:  link["base_path"]
      }
    end
  end

  def quick_links
    quick = content_item["details"]["quick_links"] || []
    quick.map do |link|
      {
        title: link["title"],
        url:  link["url"]
      }
    end
  end
end
