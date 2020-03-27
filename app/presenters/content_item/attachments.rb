module ContentItem
  module Attachments
    def attachment_details(attachment_id)
      content_item["details"]["attachments"].find do |attachment|
        attachment["id"] == attachment_id
      end
    end
  end
end
