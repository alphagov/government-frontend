module ContentItem
  module ManualUpdates
    def page_title
      I18n.t("manuals.updates_page_title", title: manual_page_title)
    end

    def breadcrumbs
      [
        {
          title: I18n.t("manuals.breadcrumb_contents"),
          url: base_path,
        },
      ]
    end

    def description
      I18n.t("manuals.updates_description", title: manual_page_title)
    end

    def presented_change_notes
      group_updates_by_year(change_notes)
    end

  private

    def change_notes
      details.fetch("change_notes", [])
    end

    def updated_at(published_at)
      Date.parse(published_at)
    end

    def group_updates_by_year(updates)
      updates.group_by { |update| updated_at(update["published_at"]).year }
             .sort_by { |year, _| year }
             .map { |year, grouped_updates| [year, group_updates_by_day(grouped_updates)] }.reverse
    end

    def group_updates_by_day(updates)
      updates.group_by { |update| updated_at(update["published_at"]) }
             .sort_by { |day, _| day }
             .map { |day, grouped_updates| [marked_up_date(day), group_updates_by_document(grouped_updates)] }.reverse
    end

    def group_updates_by_document(updates)
      updates.group_by { |update| update["base_path"] }
    end

    def marked_up_date(date)
      formatted_date = I18n.l(date, format: "%-d %B %Y") if date
      updates_span = view_context.content_tag("span",
                                              I18n.t("manuals.updates_amendments"),
                                              class: "govuk-visually-hidden")

      formatted_date = "#{formatted_date} #{updates_span}"
      view_context.sanitize(formatted_date)
    end
  end
end
