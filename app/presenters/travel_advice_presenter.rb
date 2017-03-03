class TravelAdvicePresenter < ContentItemPresenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper

  attr_reader :part_slug

  def initialize(content_item, part_slug = nil)
    super(content_item)
    @part_slug = part_slug
  end

  def page_title
    if is_summary?
      title
    else
      "#{current_part_title} - #{title}"
    end
  end

  def metadata
    reviewed_at = content_item['details']['reviewed_at']
    updated_at = content_item['details']['updated_at']

    {
      other: {
        "Still current at" => I18n.l(Time.now, format: "%-d %B %Y"),
        "Updated" => display_date(reviewed_at || updated_at),
        "Latest update" => simple_format(latest_update)
      }
    }
  end

  def title_and_context
    {
      context: 'Foreign travel advice',
      title: country_name
    }
  end

  def country_name
    content_item["details"]["country"]["name"]
  end

  def related_items
    items = ordered_related_items.map do |link|
      {
        title: link["title"],
        url:  link["base_path"]
      }
    end

    {
      sections: [
        {
          title: 'Elsewhere on GOV.UK',
          items: items
        }
      ]
    }
  end

  def parts_navigation
    part_links.each_slice(part_navigation_group_size).to_a
  end

  def parts_navigation_second_list_start
    part_navigation_group_size + 1
  end

  def is_summary?
    @part_slug.nil?
  end

  def current_part_title
    current_part["title"]
  end

  def current_part_body
    current_part["body"]
  end

  def map
    content_item["details"]["image"]
  end

  def map_download_url
    content_item["details"].dig("document", "url")
  end

  def has_valid_part?
    !!current_part
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
    alert_statuses = content_item["details"]["alert_status"] || []
    alert_statuses = alert_statuses.map do |alert|
      content_tag(:p, I18n.t("travel_advice.alert_status.#{alert}").html_safe)
    end

    alert_statuses.join('').html_safe
  end

  def atom_change_description
    simple_format(HTMLEntities.new.encode(change_description, :basic, :decimal))
  end

  def atom_public_updated_at
    DateTime.parse(content_item["public_updated_at"])
  end

  def web_url
    Plek.current.website_root + content_item["base_path"]
  end

private

  def summary_part
    {
      "title" => "Current travel advice",
      "body" => content_item["details"]["summary"]
    }
  end

  def current_part
    if is_summary?
      summary_part
    else
      parts.find { |part| part["slug"] == @part_slug }
    end
  end

  def parts
    content_item["details"]["parts"] || []
  end

  def part_links
    summary_link_title = 'Current travel advice'
    summary_part_link = is_summary? ? summary_link_title : link_to(summary_link_title, @base_path)

    [summary_part_link] + parts.map do |part|
      if part['slug'] != @part_slug
        link_to part['title'], "#{@base_path}/#{part['slug']}"
      else
        part['title']
      end
    end
  end

  def part_navigation_group_size
    size = part_links.size.to_f / 2
    if size < 2
      3
    else
      size.ceil
    end
  end

  def ordered_related_items
    content_item["links"]["ordered_related_items"] || []
  end

  def change_description
    content_item['details']['change_description']
  end

  # FIXME: Update publishing app UI and remove from content
  # Change description is used as "Latest update" but isn't labelled that way
  # in the publisher. The frontend didn't add this label before.
  # This led to users appending (in a variety of formats)
  # "Latest update:" to the start of the change description. The frontend now
  # has a latest update label, so we can strip this out.
  # Avoids: "Latest update: Latest update - …"
  def latest_update
    change_description.sub(/^Latest update:?\s-?\s?/i, '').tap do |latest|
      latest[0] = latest[0].capitalize
    end
  end
end
