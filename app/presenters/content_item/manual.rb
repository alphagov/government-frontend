module ContentItem
  module Manual
    include Linkable
    include Updatable

    def page_title
      title = content_item["title"] || ""
      title += " - " if title.present?

      if hmrc?
        I18n.t("manuals.hmrc_title", title: title)
      else
        I18n.t("manuals.title", title: title)
      end
    end

    def breadcrumbs
      crumbs = []

      if view_context.request.path == base_path
        crumbs.push({
          title: I18n.t("manuals.breadcrumb_contents"),
        })
      else
        crumbs.push({
          title: I18n.t("manuals.breadcrumb_contents"),
          url: base_path,
        })
      end
    end

    def section_groups
      content_item.dig("details", "child_section_groups") || []
    end

    def body
      details["body"]
    end

    def manual_metadata
      {
        from: from,
        first_published: published,
        other: other_metadata,
        inverse: true,
      }
    end

  private

    def other_metadata
      updates_link = view_context.link_to(I18n.t("manuals.see_all_updates"), "#{base_path}/updates")
      { I18n.t("manuals.updated") => "#{display_date(public_updated_at)}, #{updates_link}" }
    end

    def details
      content_item["details"]
    end

    def hmrc?
      %w[hmrc_manual hmrc_manual_section].include?(schema_name)
    end
  end
end
