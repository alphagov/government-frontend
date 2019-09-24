module ContentItem
  module Parts
    include ActionView::Helpers::UrlHelper

    def parts
      raw_parts.each_with_index.map do |part, i|
        # Link to base_path for first part
        part["full_path"] = i.zero? ? base_path : "#{base_path}/#{part['slug']}"
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
      !!current_part && current_part != parts.first
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

    def previous_and_next_navigation
      nav = {}

      if previous_part
        nav[:previous_page] = {
          url: previous_part["full_path"],
          title: I18n.t("multi_page.previous_page"),
          label: previous_part["title"]
        }
      end

      if next_part
        nav[:next_page] = {
          url: next_part["full_path"],
          title: I18n.t("multi_page.next_page"),
          label: next_part["title"]
        }
      end

      nav
    end

    def part_link_elements
      parts.map do |part|
        if part["slug"] != current_part["slug"]
          { href: part["full_path"], text: part["title"] }
        else
          { href: part["full_path"], text: part["title"], active: true }
        end
      end
    end

  private

    def raw_parts
      content_item.dig("details", "parts") || []
    end

    def current_part
      if part_slug
        parts.find { |part| part["slug"] == part_slug }
      else
        parts.first
      end
    end

    def part_links
      parts.map.with_index(1) do |part, position|
        if part["slug"] != current_part["slug"]
          link_to part["title"], part["full_path"], class: "govuk-link",
            data: {
            track_category: "contentsClicked",
            track_action: "content_item #{position}",
            track_label: part["full_path"],
            track_options: {
              dimension29: part["title"]
             }
           }
        else
          part["title"]
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

    def next_part
      parts[current_part_index + 1]
    end

    def previous_part
      parts[current_part_index - 1] if current_part_index.positive?
    end

    def current_part_index
      parts.index(current_part)
    end
  end
end
