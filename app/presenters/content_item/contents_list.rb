module ContentItem
  module ContentsList
    include ActionView::Helpers::UrlHelper
    include TypographyHelper

    CHARACTER_LIMIT = 100
    CHARACTER_LIMIT_WITH_IMAGE = 50
    TABLE_ROW_LIMIT = 13

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
      first_item_has_long_content? ||
        first_item_has_long_table? ||
        first_item_has_image_and_long_content?
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
      element = first_item.next_element
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
      table = find_table
      return unless table.present?

      row_count = table.css('tr').count
      row_count > TABLE_ROW_LIMIT
    end

    def find_table
      element = first_item.next_element

      until element.name == 'h2' do
        return element if element.name == 'table'
        element = element.next_element
      end
    end

    def first_item_has_image?
      element = first_item.next_element

      until element.name == 'h2'
        return true if element.name == 'div' && element['class'] == 'img'
        element = element.next_element
      end
    end

    def first_item_has_image_and_long_content?
      first_item_has_image? && first_item_character_count > CHARACTER_LIMIT_WITH_IMAGE
    end

    def parsed_body
      @parsed_body ||= Nokogiri::HTML(body)
    end

    def first_item
      parsed_body.css('h2').first
    end
  end
end
