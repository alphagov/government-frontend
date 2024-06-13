module ContentItem
  module Attachments
    def attachments
      return [] unless content_item["details"]["attachments"]

      docs = content_item["details"]["attachments"].select { |a| !a.key?("locale") || a["locale"] == locale }
      docs.each do |doc|
        doc["type"] = "html" unless doc["content_type"]
        doc["type"] = "external" if doc["attachment_type"] == "external"
        doc["preview_url"] = "#{doc['url']}/preview" if doc["preview_url"]
        doc["alternative_format_contact_email"] = nil if doc["accessible"] == true
      end
    end

    def attachments_from(attachment_id_list)
      attachments.select { |doc| (attachment_id_list || []).include? doc["id"] }
    end
  end
end
