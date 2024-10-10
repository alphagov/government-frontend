module ContentItem
  module ContentsList
    CHARACTER_LIMIT = 415
    CHARACTER_LIMIT_WITH_IMAGE = 224
    TABLE_ROW_LIMIT = 13
    TABLE_ROW_LIMIT_WITH_IMAGE = 6

    def contents
      @contents ||=
        if show_contents_list?
          contents_items.each { |item| item[:href] = "##{item[:id]}" }
        else
          []
        end
    end

    def contents_items
      extract_headings_with_ids
    end

    def show_contents_list?
      return false if exclude_contents_list_for_manual_section?
      return false if contents_items.count < 2
      return true if contents_items.count > 2
      return false if no_first_item?

      first_item_has_long_content? ||
        first_item_has_long_table? ||
        first_item_has_image_and_long_content? ||
        first_item_has_image_and_long_table?
    end

  private

    def extract_headings_with_ids
      headings = parsed_body.css("h2").map do |heading|
        id = heading.attribute("id")
        { text: view_context.strip_trailing_colons(heading.text), id: id.value } if id
      end
      headings.compact
    end

    def first_item_has_long_content?
      first_item_character_count > CHARACTER_LIMIT
    end

    def first_item_content
      element = first_item
      return "" unless element

      content = ""

      until element.nil? || element.name == "h2"
        content += extract_content_from_element(element)
        element = element.next_element
      end

      content.strip
    end

    def extract_content_from_element(element)
      case element.name
      when "div"
        extract_nested_content(element)
      when "p", "ul", "ol"
        element.text
      else
        ""
      end
    end

    def extract_nested_content(element)
      element.children.each_with_object("") do |child, content|
        content << extract_content_from_element(child)
      end
    end

    def first_item_character_count
      @first_item_character_count ||= first_item_content.length
    end

    def first_item_has_long_table?
      first_item_table_rows > TABLE_ROW_LIMIT
    end

    def find_first_table
      element = first_item

      until element.name == "h2"
        return element if element.name == "table"

        element = element.next_element
        break if element.nil?
      end
    end

    def first_item_table_rows
      @table ||= find_first_table
      @table.present? ? @table.css("tr").count : 0
    end

    def first_item_has_image?
      element = first_item

      until element.name == "h2"
        return true if element.name == "div" && element["class"] == "img"

        element = element.next_element
        return false if element.nil?
      end
    end

    def first_item_has_image_and_long_content?
      first_item_has_image? && first_item_character_count > CHARACTER_LIMIT_WITH_IMAGE
    end

    def first_item_has_image_and_long_table?
      first_item_has_image? && first_item_table_rows > TABLE_ROW_LIMIT_WITH_IMAGE
    end

    def parsed_body
      @parsed_body ||= Nokogiri::HTML(body)
    end

    def first_item
      parsed_body.css("h2").first.try(:next_element)
    end

    def no_first_item?
      first_item.nil?
    end

    def exclude_contents_list_for_manual_section?
      # MOJ require contents lists for manual section pages.

      moj_content = content_item.dig("links", "organisations", 0, "content_id") == "dcc907d6-433c-42df-9ffb-d9c68be5dc4d"
      document_type == "manual_section" && !moj_content
    end
  end
end
