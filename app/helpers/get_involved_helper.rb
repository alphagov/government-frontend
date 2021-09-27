module GetInvolvedHelper
  def date_microformat(attribute_name)
    attribute_name.to_date.strftime("%d %B %Y")
  end

  # Gets the link to the search page for all consultations
  def get_consultations_link(filters = %w[open_consultations closed_consultations])
    "/search/policy-papers-and-consultations?#{filters.to_query('content_store_document_type')}"
  end

  def page_title
    t("get_involved.page_title")
  end

  def page_class(css_class)
    content_for(:page_class, css_class)
  end

private

  def time_until_closure(consultation)
    days_left = (consultation["end_date"].to_date - Time.zone.now.to_date).to_i
    case days_left
    when :negative?.to_proc
      t("get_involved.closed")
    when :zero?.to_proc
      t("get_involved.closing_today")
    when 1
      t("get_involved.closing_tomorrow")
    else
      t("get_involved.days_left", number_of_days: days_left)
    end
  end
end
