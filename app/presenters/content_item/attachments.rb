module ContentItem
  module Attachments
    def attachment_details(attachment_id)
      content_item.dig("details", "attachments")&.find do |attachment|
        attachment["id"] == attachment_id
      end
    end
  end
end
