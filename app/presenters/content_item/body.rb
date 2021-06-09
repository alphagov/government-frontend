module ContentItem
  module Body
    def body
      content_item["details"]["body"]
    end

    def govspeak_body
      {
        content: body.html_safe,
        direction: text_direction,
      }
    end

    def title_and_link_sections
      BodyParser.new(body.html_safe).title_and_link_sections
    end
  end
end
