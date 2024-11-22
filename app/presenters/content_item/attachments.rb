module ContentItem
  module Attachments
    def attachments
      content_item_attachments = content_item.dig("details", "attachments")
      return [] unless content_item_attachments

      docs = content_item_attachments.select { |a| !a.key?("locale") || a["locale"] == locale }
      docs.each do |doc|
        doc["type"] = "html" unless doc["content_type"]
        doc["type"] = "external" if doc["attachment_type"] == "external"
        doc["preview_url"] = preview_url(doc) if doc["preview_url"]
        doc["alternative_format_contact_email"] = nil if doc["accessible"] == true
      end
    end

    def attachments_from(attachment_id_list)
      attachments.select { |doc| (attachment_id_list || []).include? doc["id"] }
    end

  private

    def preview_url(doc)
      case doc.symbolize_keys
      in { preview_url: String, attachment_data_id:, filename: }
        # We have attachment_data_id and filename, so we can redirect to a new style CSV preview
        # Note: using a path rather than a full URL so the user doesn't flip from a draft frontend
        #       to a live frontend if previewing a live asset of a draft document
        "/csv-preview/#{attachment_data_id}/#{filename}"
      in { preview_url: String, url: }
        # TODO: remove this branch once we're confident attachment_data_id is present everywhere
        Rails.logger.warn("Attachment at #{url} using old style preview, because no attachment_data_id present")
        # NOTE: we're using "#{url}/preview" here because the preview_url fields have the wrong ids in them
        "#{url}/preview"
      end
    end
  end
end
