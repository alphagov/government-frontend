module ContentItem
  module ContentsList
    include ActionView::Helpers::UrlHelper
    include TypographyHelper

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
      headings = parsed_body.css('h2').map do |heading|
        id = heading.attribute('id')
        { text: strip_trailing_colons(heading.text), id: id.value } if id
      end
      headings.compact
    end

    def first_item_has_long_content?
      first_item_character_count > CHARACTER_LIMIT
    end

    def first_item_content
      element = first_item
      first_item_text = ''

      until element.name == 'h2'
        first_item_text += element.text if element.name == 'p'
        element = element.next_element
      end
      first_item_text
    end

    def first_item_character_count
      @first_item_character_count ||= first_item_content.length
    end

    def first_item_has_long_table?
      first_item_table_rows > TABLE_ROW_LIMIT
    end

    def find_first_table
      element = first_item

      until element.name == 'h2' do
        return element if element.name == 'table'
        element = element.next_element
      end
    end

    def first_item_table_rows
      @table ||= find_first_table
      @table.present? ? @table.css('tr').count : 0
    end

    def first_item_has_image?
      element = first_item

      until element.name == 'h2'
        return true if element.name == 'div' && element['class'] == 'img'
        element = element.next_element
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
      parsed_body.css('h2').first.next_element
    end

    def no_first_item?
      first_item.nil?
    end
  end
end
