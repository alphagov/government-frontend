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
      content_item["details"].include?("government") && !content_item["details"]["government"]["current"]
    end
  end
end
