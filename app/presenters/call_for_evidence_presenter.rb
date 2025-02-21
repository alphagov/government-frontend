class CallForEvidencePresenter < ContentItemPresenter
  include ContentItem::Attachments
  include ContentItem::Body
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::Political
  include ContentItem::Shareable
  include ContentItem::SinglePageNotificationButton
  include ContentItem::HeadingAndContext

  def opening_date_time
    content_item["details"]["opening_date"]
  end

  def closing_date_time
    content_item["details"]["closing_date"]
  end

  def opening_date
    DateTimeHelper.display_date_and_time(opening_date_time)
  end

  def opening_date_midnight?
    Time.zone.parse(opening_date_time).strftime("%l:%M%P") == "12:00am"
  end

  def closing_date
    DateTimeHelper.display_date_and_time(closing_date_time, rollback_midnight: true)
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
    attachments_from(content_item["details"]["outcome_attachments"])
  end

  # Documents, bottom of page
  def general_documents
    attachments_from(content_item["details"]["featured_attachments"])
  end

  def attachments_with_details
    items = [].push(*outcome_documents)
    items.push(*general_documents)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }.count
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

  def ways_to_respond
    content_item["details"]["ways_to_respond"]
  end
end
