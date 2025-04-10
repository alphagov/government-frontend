class ConsultationPresenter < ContentItemPresenter
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

  # Read the full outcome, top of page
  def final_outcome_attachments_for_components
    attachments_from(content_item["details"]["final_outcome_attachments"])
  end

  # Feedback received, middle of page
  def public_feedback_attachments_for_components
    attachments_from(content_item["details"]["public_feedback_attachments"])
  end

  # Documents, bottom of page
  def documents_attachments_for_components
    attachments_from(content_item["details"]["featured_attachments"])
  end

  def attachments_with_details
    items = [].push(*final_outcome_attachments_for_components)
    items.push(*public_feedback_attachments_for_components)
    items.push(*documents_attachments_for_components)
    items.select { |doc| doc["accessible"] == false && doc["alternative_format_contact_email"] }.count
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

private

  def ways_to_respond
    content_item["details"]["ways_to_respond"]
  end
end
