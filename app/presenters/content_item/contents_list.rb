module ContentItem
  module ContentsList
    MINIMUM_CHARACTER_COUNT = 415
    MINIMUM_CHARACTER_COUNT_IF_IMAGE_PRESENT = 224
    MINIMUM_TABLE_ROW_COUNT = 13
    MINIMUM_TABLE_ROW_COUNT_IF_IMAGE_PRESENT = 6

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
      return true if contents_items.present?
      return false if no_first_item?

      first_item_size_requirements_met?(character_count, table_row_count)
    end

  private

    def first_item_size_requirements_met?(char_count, table_row_count)
      first_item_character_count > char_count || first_item_table_rows > table_row_count
    end

    def character_count
      first_item_has_image? ? MINIMUM_CHARACTER_COUNT_IF_IMAGE_PRESENT : MINIMUM_CHARACTER_COUNT
    end

    def table_row_count
      first_item_has_image? ? MINIMUM_TABLE_ROW_COUNT_IF_IMAGE_PRESENT : MINIMUM_TABLE_ROW_COUNT
    end

    def extract_headings_with_ids
      headings = parsed_body.css("h2").map do |heading|
        id = heading.attribute("id")
        { text: view_context.strip_trailing_colons(heading.text), id: id.value } if id
      end
      headings.compact
    end

    def first_item_content
      element = first_item
      first_item_text = ""
      allowed_elements = %w[p ul ol]

      until element.name == "h2"
        first_item_text += element.text if element.name.in?(allowed_elements)
        element = element.next_element
        break if element.nil?
      end
      first_item_text
    end

    def first_item_character_count
      @first_item_character_count ||= first_item_content.length
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

    def parsed_body
      @parsed_body ||= Nokogiri::HTML(body)
    end

    def first_item
      parsed_body.css("h2").first.try(:next_element)
    end

    def no_first_item?
      first_item.nil?
    end
  end
end
