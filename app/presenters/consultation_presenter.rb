class ConsultationPresenter < ContentItemPresenter
  include Linkable
  include Updatable
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
    display_time(opening_date_time)
  end

  def closing_date
    display_time(closing_date_time)
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

  def final_outcome_documents?
    final_outcome_documents_list.any?
  end

  def final_outcome_documents
    final_outcome_documents_list.join('')
  end

private

  def final_outcome_documents_list
    content_item["details"]["final_outcome_documents"] || []
  end

  def documents_list
    content_item["details"]["documents"] || []
  end
end
