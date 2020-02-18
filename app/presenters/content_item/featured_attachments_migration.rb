module ContentItem
  module FeaturedAttachmentsMigration
    def choose_field(new_field_name:, old_field_name:)
      new_list = content_item["details"][new_field_name]
      old_list = content_item["details"][old_field_name] || []

      # don't raise an error just because a document hasn't been
      # republished to have the new field yet.
      return old_list if new_list.nil?

      if new_list.length == old_list.length
        new_list
      else
        GovukError.notify(
          "Mismatch between attachments and documents",
          extra: { error_message: "Document with #{new_list.length} #{new_field_name} but #{old_list.length} #{old_field_name} at #{base_path}" },
        )

        old_list
      end
    end
  end
end
