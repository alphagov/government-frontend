class SpecialistDocumentPresenter < ContentItemPresenter
  include Updatable
  include Linkable
  include ContentsList
  include TitleAndContext
  include Metadata

  def body
    content_item["details"]["body"]
  end

  def title_and_context
    super.tap do |t|
      t.delete(:context)
    end
  end

private

  # first_published_at does not have reliable data
  # at time of writing dates could be after public_updated_at
  # details.first_public_at is not provided
  # https://trello.com/c/xCJ3RN6W/
  #
  # Instead use first date in change history
  def first_public_at
    changes = reverse_chronological_change_history
    changes.any? ? changes.last[:timestamp] : nil
  end
end
