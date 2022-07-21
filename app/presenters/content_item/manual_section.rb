module ContentItem
  module ManualSection
    def title
      manual["title"]
    end

    def page_title
      "#{breadcrumb} - #{manual_page_title}"
    end

    def document_heading
      document_heading = []

      document_heading << details["section_id"] if details["section_id"]
      document_heading << content_item["title"] if content_item["title"]
    end

    def breadcrumb
      details["section_id"] || title
    end

    def manual_content_item
      @manual_content_item ||= Services.content_store.content_item(base_path)
    end

    def published
      display_date(manual_content_item["first_published_at"])
    end

    def other_metadata
      updated_metadata(manual_content_item["public_updated_at"])
    end
  end
end
