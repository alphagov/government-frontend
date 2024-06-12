class CallForEvidencePresenter < ContentItemPresenter
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
    document_type == "open_call_for_evidence"
  end

  def closed?
    %w[closed_call_for_evidence call_for_evidence_outcome].include? document_type
  end

  def unopened?
    !open? && !closed?
  end

  def outcome?
    document_type == "call_for_evidence_outcome"
  end

  def outcome_detail
    content_item["details"]["outcome_detail"]
  end

  # Read the full outcome, top of page
  def outcome_documents
    # content_item["details"]["outcome_documents"]&.join("")
    documents.select { |doc| outcome_attachments.include? doc["id"] }
  end

  # Documents, bottom of page
  def general_documents
    documents.select { |doc| featured_attachments.include? doc["id"] }
  end

  def attachments_with_details
    items = [].push(*outcome_documents)
    items.push(*general_documents)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }.count
  end

  def outcome_attachments
    content_item["details"]["outcome_attachments"]
  end

  def featured_attachments
    content_item["details"]["featured_attachments"]
  end

  def documents
    # content_item["details"]["documents"]&.join("")
    return [] unless content_item["details"]["attachments"]

    docs = content_item["details"]["attachments"].select { |a| !a.key?("locale") || a["locale"] == locale }
    docs.each do |doc|
      doc["type"] = "html" unless doc["content_type"]
      doc["type"] = "external" if doc["attachment_type"] == "external"
      doc["preview_url"] = "#{doc['url']}/preview" if doc["preview_url"]
      doc["alternative_format_contact_email"] = nil if doc["accessible"] == true
    end
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
    outcome?
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
