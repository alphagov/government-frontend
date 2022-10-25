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
  end
end
