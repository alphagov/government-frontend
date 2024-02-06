module ContentItem
  module Manual
    include Linkable
    include Updatable

    def page_title
      title = content_item["title"] || ""
      title += " - " if title.present?

      if hmrc?
        I18n.t("manuals.hmrc_title", title:)
      else
        I18n.t("manuals.title", title:)
      end
    end
    alias_method :manual_page_title, :page_title

    def breadcrumbs
      [{ title: I18n.t("manuals.breadcrumb_contents") }]
    end

    def section_groups
      content_item.dig("details", "child_section_groups") || []
    end

    def body
      details["body"]
    end

    def manual_metadata
      {
        from:,
        first_published: published,
        other: other_metadata,
        inverse: true,
        inverse_compress: true,
      }
    end

  private

    def other_metadata
      updated_metadata(public_updated_at)
    end

    def updated_metadata(updated_at)
      current_path = view_context.request.path

      if (hmrc? || manual?) && current_path == "#{base_path}/updates"
        update_at_text = display_date(updated_at).to_s
      else
        updates_link = view_context.link_to(I18n.t("manuals.see_all_updates"), "#{base_path}/updates")
        update_at_text = "#{display_date(updated_at)} - #{updates_link}"
      end

      { I18n.t("manuals.updated") => update_at_text }
    end

    def details
      content_item["details"]
    end

    def hmrc?
      %w[hmrc_manual hmrc_manual_section].include?(schema_name)
    end

    def manual?
      %w[manual manual_section].include?(schema_name)
    end
  end
end
