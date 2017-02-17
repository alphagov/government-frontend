class ContactPresenter < ContentItemPresenter
  include TitleAndContext

  def title_and_context
    super.tap do |t|
      t.delete(:average_title_length)
      t.delete(:context)
    end
  end

  def related_items
    sections = []
    sections << {
      title: "Elsewhere on GOV.UK",
      items: quick_links
    } if quick_links.any?

    sections << {
      title: "Other contacts",
      items: related_contacts_links
    } if related_contacts_links.any?

    {
      sections: sections
    }
  end

  def online_form_links
    content_item["details"]["contact_form_links"].map do |link|
      {
        url: link['link'],
        title: link['title'],
        description: link['description'].html_safe
      }
    end
  end

  def online_form_body
    content_item["details"]["more_info_contact_form"].html_safe
  end

  def phone
    phone_number_groups.map do |group|
      details = {
        numbers: [
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
        ],
        title: group['title'],
        description: group['description'].strip.html_safe,
        opening_times: group['open_hours'].strip.html_safe,
        best_time_to_call: group['best_time_to_call'].strip.html_safe
      }

      details[:numbers].select! { |n| n[:number].present? }
      details
    end
  end

  def phone_body
    content_item["details"]["more_info_phone_number"].html_safe
  end

  def post
    post_address_groups.map do |group|
      details = {
        description: group['description'].strip.html_safe,
        v_card: [
          v_card_part('fn', group['title']),
          v_card_part('street-address', group['street_address']),
          v_card_part('locality', group['locality']),
          v_card_part('postal-code', group['postal_code']),
          v_card_part('region', group['region']),
          v_card_part('country-name', group['world_location']),
        ]
      }

      details[:v_card].select! { |v| v[:value].present? }
      details
    end
  end

  def post_body
    content_item["details"]["more_info_post_address"].html_safe
  end

  def email
    email_address_groups.map do |group|
      details = {
        description: group['description'] ? group['description'].strip.html_safe : '',
        email: group['email'].strip,
        v_card: [v_card_part('fn', group['title'])],
      }

      details[:v_card].select! { |v| v[:value].present? }
      details
    end
  end

  def email_body
    content_item["details"]["more_info_email_address"].html_safe
  end

private

  def v_card_part(v_card_class, value)
    {
      v_card_class: v_card_class,
      value: value.strip.html_safe
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
