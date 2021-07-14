module GetInvolvedHelper
  def date_microformat(attribute_name)
    attribute_name.to_date.strftime("%d %B %Y")
  end

  # Gets the link to the search page for all consultations
  def get_consultations_link(filters = %w[open_consultations closed_consultations])
    "search/policy-papers-and-consultations?#{filters.to_query('content_store_document_type')}"
  end

private

  def time_until_closure(consultation)
    days_left = (consultation["end_date"].to_date - Time.zone.now.to_date).to_i
    case days_left
    when :negative?.to_proc
      "Closed"
    when :zero?.to_proc
      "Closing today"
    when 1
      "Closes tomorrow"
    else
      "#{days_left} days left"
    end
  end
end
