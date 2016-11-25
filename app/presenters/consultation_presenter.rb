class ConsultationPresenter < ContentItemPresenter
  include Linkable
  include Updatable
  include NationalApplicability
  include Political
  include Withdrawable

  def body
    content_item["details"]["body"]
  end

  def opening_date_time
    content_item["details"]["opening_date"]
  end

  def closing_date_time
    content_item["details"]["closing_date"]
  end

  def opening_date
    display_date_and_time(opening_date_time)
  end

  def closing_date
    display_date_and_time(closing_date_time)
  end

  def open?
    document_type == "open_consultation"
  end

  def closed?
    %w(closed_consultation consultation_outcome).include? document_type
  end

  def unopened?
    !open? && !closed?
  end

  def pending_final_outcome?
    closed? && !final_outcome?
  end

  def final_outcome?
    document_type == "consultation_outcome"
  end

  def final_outcome_detail
    content_item["details"]["final_outcome_detail"]
  end

  def final_outcome_documents?
    final_outcome_documents_list.any?
  end

  def final_outcome_documents
    final_outcome_documents_list.join('')
  end

  def public_feedback_documents?
    public_feedback_documents_list.any?
  end

  def public_feedback_documents
    public_feedback_documents_list.join('')
  end

  def public_feedback_detail
    content_item["details"]["public_feedback_detail"]
  end

  def held_on_another_website?
    content_item["details"].include?("held_on_another_website_url")
  end

  def held_on_another_website_url
    content_item["details"]["held_on_another_website_url"]
  end

  def documents?
    documents_list.any?
  end

  def documents
    documents_list.join('')
  end

private

  def display_date_and_time(date)
    time = Time.parse(date)
    date_format = "%-e %B %Y"
    time_format = "%l:%M%P"

    # 12am, 12:00am and "midnight on" can all be misinterpreted
    # Use 11:59pm on the day before to remove ambiguity
    # 12am on 10 January becomes 11:59pm on 9 January
    time = time - 1.second if time.strftime(time_format) == "12:00am"
    I18n.l(time, format: "#{time_format} on #{date_format}").gsub(':00', '').gsub('12pm', 'midday').strip
  end

  def final_outcome_documents_list
    content_item["details"]["final_outcome_documents"] || []
  end

  def public_feedback_documents_list
    content_item["details"]["public_feedback_documents"] || []
  end

  def documents_list
    content_item["details"]["documents"] || []
  end
end
