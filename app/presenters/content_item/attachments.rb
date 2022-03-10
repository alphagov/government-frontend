module ContentItem
  module Attachments
    def attachment_details(attachment_id)
      found_attachment = content_item.dig("details", "attachments")&.find do |attachment|
        attachment["id"] == attachment_id
      end

      return unless found_attachment

      found_attachment["attachment_id"] = found_attachment.delete("id")
      found_attachment["owning_document_content_id"] = content_item["content_id"]
      found_attachment
    end
  end
end
