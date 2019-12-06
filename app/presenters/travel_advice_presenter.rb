class TravelAdvicePresenter < ContentItemPresenter
  include ContentItem::Parts
  include ActionView::Helpers::TextHelper

  ATOM_CACHE_CONTROL_MAX_AGE = 300

  def page_title
    if is_summary?
      super
    else
      "#{current_part_title} - #{super}"
    end
  end

  def metadata
    reviewed_at = content_item["details"]["reviewed_at"]
    updated_at = content_item["details"]["updated_at"]

    other = {
      "Still current at" => I18n.l(Time.zone.now, format: "%-d %B %Y"),
      "Updated" => display_date(reviewed_at || updated_at),
    }

    other["Latest update"] = simple_format(latest_update) if latest_update.present?

    {
      other: other,
    }
  end

  def title_and_context
    {
      context: "Foreign travel advice",
      title: country_name,
    }
  end

  def country_name
    content_item["details"]["country"]["name"]
  end

  def is_summary?
    @part_slug.nil?
  end

  def map
    content_item["details"]["image"]
  end

  def map_download_url
    content_item["details"].dig("document", "url")
  end

  def email_signup_link
    content_item["details"]["email_signup_link"]
  end

  def feed_link
    "#{base_path}.atom"
  end

  def print_link
    "#{base_path}/print"
  end

  # Deprecated feature
  # Exists in travel advice publisher but isn't used by FCO
  # Feature included as it _could_ still be used
  # Remove when alert status boxes no longer in travel advice publisher
  def alert_status
    allowed_statuses = %w{
      avoid_all_but_essential_travel_to_parts
      avoid_all_travel_to_parts
      avoid_all_but_essential_travel_to_whole_country
      avoid_all_travel_to_whole_country
    }
    alert_statuses = content_item["details"]["alert_status"] || []
    alert_statuses = alert_statuses.map do |alert|
      if allowed_statuses.include?(alert)
        content_tag(:p, I18n.t("travel_advice.alert_status.#{alert}").html_safe)
      end
    end

    alert_statuses.join("").html_safe
  end

  def atom_change_description
    simple_format(HTMLEntities.new.encode(change_description, :basic, :decimal))
  end

  def atom_public_updated_at
    Time.zone.parse(content_item["public_updated_at"])
  end

  def cache_control_max_age(format)
    return ATOM_CACHE_CONTROL_MAX_AGE if format == "atom"

    content_item.cache_control.max_age
  end

private

  # Treat summary as the first part
  def raw_parts
    [summary_part].concat(super)
  end

  def summary_part
    {
      "title" => "Summary",
      "slug" => "",
      "body" => content_item["details"]["summary"],
    }
  end

  def change_description
    content_item["details"]["change_description"]
  end

  # FIXME: Update publishing app UI and remove from content
  # Change description is used as "Latest update" but isn't labelled that way
  # in the publisher. The frontend didn't add this label before.
  # This led to users appending (in a variety of formats)
  # "Latest update:" to the start of the change description. The frontend now
  # has a latest update label, so we can strip this out.
  # Avoids: "Latest update: Latest update - …"
  def latest_update
    change_description.sub(/^Latest update:?\s-?\s?/i, "").tap do |latest|
      latest[0] = latest[0].capitalize if latest.present?
    end
  end
end
