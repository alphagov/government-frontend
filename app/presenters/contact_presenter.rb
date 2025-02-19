class ContactPresenter < ContentItemPresenter
  include ContentItem::HeadingAndContext
  include ContentItem::ContactDetails

  def heading_and_context
    super.tap do |t|
      t[:font_size] = "xl"
      t.delete(:context)
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

  # Webchat

  def webchat
    Webchat.find(content_item["base_path"])
  end

  def show_webchat?
    webchat.present?
  end

  def webchat_body
    content_item.dig("details", "more_info_webchat").try(:html_safe)
  end

  def csp_connect_src
    webchat&.csp_connect_src
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

  def v_card_part(v_card_class, value)
    {
      v_card_class:,
      value: value.try(:strip).try(:html_safe),
    }
  end

  def related_contacts_links
    related = content_item["links"]["related"] || []
    related.map do |link|
      {
        title: link["title"],
        url: link["base_path"],
      }
    end
  end

  def quick_links
    quick = content_item["details"]["quick_links"] || []
    quick.map do |link|
      {
        title: link["title"],
        url: link["url"],
      }
    end
  end
end
