module Parts
  include ActionView::Helpers::UrlHelper

  def parts
    content_item.dig("details", "parts") || []
  end

  def decorated_parts
    parts.each_with_index.map do |part, i|
      # Link to base_path for first part
      part['full_path'] = (i == 0) ? base_path : "#{base_path}/#{part['slug']}"
      part
    end
  end

  # When requesting a part, the content store will return a content item
  # with a base path that's different to the one requested. That content
  # item contains all the parts for that document.
  def requesting_a_part?
    parts.any? && requested_content_item_path && requested_content_item_path != base_path
  end

  def has_valid_part?
    !!current_part
  end

  def current_part_title
    current_part["title"]
  end

  def current_part_body
    current_part["body"]
  end

  def parts_navigation
    part_links.each_slice(part_navigation_group_size).to_a
  end

  def parts_navigation_second_list_start
    part_navigation_group_size + 1
  end

private

  def current_part
    if part_slug
      parts.find { |part| part["slug"] == part_slug }
    else
      parts.first
    end
  end

  def part_links
    decorated_parts.map do |part|
      if part['slug'] != current_part['slug']
        link_to part['title'], part['full_path']
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
end
