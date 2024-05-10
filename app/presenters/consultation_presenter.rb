class ConsultationPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::Political
  include ContentItem::Shareable
  include ContentItem::TitleAndContext
  include ContentItem::Attachments
  include ContentItem::SinglePageNotificationButton

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
    display_date_and_time(closing_date_time, rollback_midnight: true)
  end

  def open?
    document_type == "open_consultation"
  end

  def closed?
    %w[closed_consultation consultation_outcome].include? document_type
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

  # Download the full outcome, top of page
  def final_outcome_attachments_for_components
    documents.select { |doc| final_outcome_attachments.include? doc["id"] }
  end

  # Feedback received, middle of page
  def public_feedback_attachments_for_components
    documents.select { |doc| public_feedback_attachments.include? doc["id"] }
  end

  # Documents, bottom of page
  def documents_attachments_for_components
    documents.select { |doc| featured_attachments.include? doc["id"] }
  end

  def attachments_with_details
    items = [].push(*final_outcome_attachments_for_components)
    items.push(*public_feedback_attachments_for_components)
    items.push(*documents_attachments_for_components)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }.count
  end

  def documents
    return [] unless content_item["details"]["attachments"]

    docs = content_item["details"]["attachments"].select { |a| !a.key?("locale") || a["locale"] == locale }
    docs.each do |doc|
      doc["type"] = "html" unless doc["content_type"]
      doc["type"] = "external" if doc["attachment_type"] == "external"
      doc["preview_url"] = "#{doc['url']}/preview" if doc["preview_url"]
      doc["alternative_format_contact_email"] = nil if doc["accessible"] == true
    end
  end

  def final_outcome_attachments
    content_item["details"]["final_outcome_attachments"] || []
  end

  def public_feedback_attachments
    content_item["details"]["public_feedback_attachments"] || []
  end

  def featured_attachments
    content_item["details"]["featured_attachments"] || []
  end

  def public_feedback_detail
    content_item["details"]["public_feedback_detail"]
  end

  def held_on_another_website?
    held_on_another_website_url.present?
  end

  def held_on_another_website_url
    content_item["details"]["held_on_another_website_url"]
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
    final_outcome? || public_feedback_detail || public_feedback_attachments.any?
  end

private

  def display_date_and_time(date, rollback_midnight: false)
    time = Time.zone.parse(date)
    date_format = "%-e %B %Y"
    time_format = "%l:%M%P"

    if rollback_midnight && (time.strftime(time_format) == "12:00am")
      # 12am, 12:00am and "midnight on" can all be misinterpreted
      # Use 11:59pm on the day before to remove ambiguity
      # 12am on 10 January becomes 11:59pm on 9 January
      time -= 1.second
    end
    I18n.l(time, format: "#{time_format} on #{date_format}").gsub(":00", "").gsub("12pm", "midday").gsub("12am on ", "").strip
  end

  def ways_to_respond
    content_item["details"]["ways_to_respond"]
  end
end
