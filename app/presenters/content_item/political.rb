module ContentItem
  module Political
    def historically_political?
      political? && historical?
    end

    def publishing_government
      content_item["details"]["government"]["title"]
    end

  private

    def political?
      content_item["details"].include?("political") && content_item["details"]["political"]
    end

    def historical?
      government_current = content_item.dig(
        "links", "government", 0, "details", "current"
      )

      # Treat no government as not historical
      return false if government_current.nil?

      !government_current
    end
  end
end
