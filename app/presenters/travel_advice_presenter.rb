class TravelAdvicePresenter < ContentItemPresenter
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::UrlHelper

  attr_reader :part_slug

  def initialize(content_item, part_slug = nil)
    super(content_item)
    @part_slug = part_slug
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

private

  def summary_part
    {
      "title" => "Summary",
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

  def country_name
    content_item["details"]["country"]["name"]
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

  # FIXME: Update publishing app UI and remove from content
  # Change description is used as "Latest update" but isn't labelled that way
  # in the publisher. The frontend didn't add this label before.
  # This led to users appending (in a variety of formats)
  # "Latest update:" to the start of the change description. The frontend now
  # has a latest update label, so we can strip this out.
  # Avoids: "Latest update: Latest update - …"
  def latest_update
    change_description = content_item['details']['change_description']
    change_description.sub(/^Latest update:?\s-?\s?/i, '').tap do |latest|
      latest[0] = latest[0].capitalize
    end
  end
end
