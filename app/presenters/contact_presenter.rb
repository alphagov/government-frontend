class ContactPresenter < ContentItemPresenter
  include ContentItem::TitleAndContext

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
      t.delete(:context)
    end
  end

  def webchat_body
    content_item.dig("details", "more_info_webchat").try(:html_safe)
  end

  def leadingpara_body
    if webchat_provider_id == "k2c"
      content_item.dig("details", "description").try(:html_safe)
    end
  end

  def online_form_links
    contact_form_links = content_item["details"]["contact_form_links"] || []
    contact_form_links.map do |link|
      {
        url: link["link"],
        title: link["title"],
        description: link["description"].try(:html_safe),
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
        title: group["title"],
        description: group["description"].try(:strip).try(:html_safe),
        opening_times: group["open_hours"].try(:strip).try(:html_safe),
        best_time_to_call: group["best_time_to_call"].try(:strip).try(:html_safe),
      }
    end
  end

  def phone_body
    content_item.dig("details", "more_info_phone_number").try(:html_safe)
  end

  def post
    post_address_groups.map do |group|
      details = {
        description: group["description"].try(:strip).try(:html_safe),
        v_card: [
          v_card_part("fn", group["title"]),
          v_card_part("street-address", group["street_address"]),
          v_card_part("locality", group["locality"]),
          v_card_part("region", group["region"]),
          v_card_part("postal-code", group["postal_code"]),
          v_card_part("country-name", group["world_location"]),
        ],
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
        description: group["description"].try(:strip).try(:html_safe),
        email: group["email"].strip,
        v_card: [v_card_part("fn", group["title"])],
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
    case webchat_provider_id
    when "k2c"
      "https://hmpowebchat.klick2contact.com/v03/providers/serviceStatus/v3/#{webchat_id}.json"
    else
      "https://www.tax.service.gov.uk/csp-partials/availability/#{webchat_id}"
    end
  end

  def webchat_open_url
    case webchat_provider_id
    when "k2c"
      "https://hmpowebchat.klick2contact.com/v03/providers/HMPO2/window/windowChat.html"
    else
      "https://www.tax.service.gov.uk/csp-partials/open/#{webchat_id}"
    end
  end

  def webchat_provider
    webchat_provider_id.to_s
  end

  def webchat_provider_config
    {
      "chat-provider": webchat_provider,
      "open-url": webchat_open_url,
      "availability-url": webchat_availability_url,
    }
  end

private

  def phone_numbers_in_group(group)
    [
      {
        label: "Telephone",
        number: group["number"],
      },
      {
        label: "Textphone",
        number: group["textphone"],
      },
      {
        label: "Outside UK",
        number: group["international_phone"],
      },
      {
        label: "Fax",
        number: group["fax"],
      },
    ].select { |n| n[:number].present? }
  end

  def webchat_id
    webchat_ids[content_item["base_path"]]
  end

  def webchat_ids
    {
      "/government/organisations/hm-revenue-customs/contact/child-benefit" => 1027,
      "/government/organisations/hm-revenue-customs/contact/income-tax-enquiries-for-individuals-pensioners-and-employees" => 1030,
      "/government/organisations/hm-revenue-customs/contact/vat-online-services-helpdesk" => 1026,
      "/government/organisations/hm-revenue-customs/contact/national-insurance-numbers" => 1021,
      "/government/organisations/hm-revenue-customs/contact/self-assessment" => 1004,
      "/government/organisations/hm-revenue-customs/contact/tax-credits-enquiries" => 1016,
      "/government/organisations/hm-revenue-customs/contact/vat-enquiries" => 1028,
      "/government/organisations/hm-revenue-customs/contact/customs-international-trade-and-excise-enquiries" => 1034,
      "/government/organisations/hm-revenue-customs/contact/employer-enquiries" => 1023,
      "/government/organisations/hm-revenue-customs/contact/online-services-helpdesk" => 1003,
      "/government/organisations/hm-revenue-customs/contact/charities-and-community-amateur-sports-clubs-cascs" => 1087,
      "/government/organisations/hm-revenue-customs/contact/enquiries-from-employers-with-expatriate-employees" => 1089,
      "/government/organisations/hm-revenue-customs/contact/share-schemes-for-employees" => 1088,
      "/government/organisations/hm-revenue-customs/contact/non-uk-expatriate-employees-expats" => 1089,
      "/government/organisations/hm-revenue-customs/contact/non-resident-landlords" => 1086,
      "/government/organisations/hm-passport-office/contact/passport-advice-and-complaints" => 72,

    }
  end

  def webchat_provider_id
    webchat_provider_ids[content_item["base_path"]] if webchat_provider_ids[content_item["base_path"]].present?
  end

  def webchat_provider_ids
    {
      "/government/organisations/hm-passport-office/contact/passport-advice-and-complaints" => "k2c",
    }
  end

  def v_card_part(v_card_class, value)
    {
      v_card_class: v_card_class,
      value: value.try(:strip).try(:html_safe),
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
        url:  link["base_path"],
      }
    end
  end

  def quick_links
    quick = content_item["details"]["quick_links"] || []
    quick.map do |link|
      {
        title: link["title"],
        url:  link["url"],
      }
    end
  end
end
