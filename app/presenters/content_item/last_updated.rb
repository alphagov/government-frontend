module ContentItem
  module LastUpdated
    def last_updated
      display_date(content_item["public_updated_at"]) if content_item["public_updated_at"]
    end
  end
end
