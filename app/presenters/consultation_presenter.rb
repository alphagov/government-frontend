class ConsultationPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::Political
  include ContentItem::Shareable
  include ContentItem::TitleAndContext

  def opening_date_time
    content_item["details"]["opening_date"]
  end

  def closing_date_time
    content_item["details"]["closing_date"]
  end

  def opening_date
    display_date_and_time(opening_date_time)
  end

  def opening_date_midnight?
    Time.zone.parse(opening_date_time).strftime("%l:%M%P") == "12:00am"
  end

  def closing_date
    display_date_and_time(closing_date_time, true)
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

  def final_outcome_documents
    content_item["details"]["final_outcome_documents"].to_a.join("")
  end

  def public_feedback_documents
    content_item["details"]["public_feedback_documents"].to_a.join("")
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

  def documents
    content_item["details"]["documents"].to_a.join("")
  end

  def ways_to_respond?
    open? && ways_to_respond && (respond_online_url || email || postal_address)
  end

  def email
    ways_to_respond["email"]
  end

  def postal_address
    ways_to_respond["postal_address"]
  end

  def respond_online_url
    ways_to_respond["link_url"]
  end

  def response_form?
    attachment_url && (email || postal_address)
  end

  def attachment_url
    ways_to_respond["attachment_url"]
  end

  def add_margin?
    final_outcome? || public_feedback_detail ||
      public_feedback_documents.present?
  end

private

  def display_date_and_time(date, rollback_midnight = false)
    time = Time.zone.parse(date)
    date_format = "%-e %B %Y"
    time_format = "%l:%M%P"

    if rollback_midnight
      # 12am, 12:00am and "midnight on" can all be misinterpreted
      # Use 11:59pm on the day before to remove ambiguity
      # 12am on 10 January becomes 11:59pm on 9 January
      time = time - 1.second if time.strftime(time_format) == "12:00am"
    end
    I18n.l(time, format: "#{time_format} on #{date_format}").gsub(":00", "").gsub("12pm", "midday").gsub("12am on ", "").strip
  end

  def ways_to_respond
    content_item["details"]["ways_to_respond"]
  end
end
