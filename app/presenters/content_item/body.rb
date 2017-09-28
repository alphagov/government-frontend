module ContentItem
  module Body
    def body
      content_item["details"]["body"]
    end

    def govspeak_body
      {
        content: body,
        direction: text_direction
      }
    end
  end
end
