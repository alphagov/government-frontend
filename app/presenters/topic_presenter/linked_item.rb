class TopicPresenter::LinkedItem
  attr_reader :content_id

  def initialize(content_id, linked_items)
    @content_id = content_id
    @linked_items = linked_items
  end

  def label
    details['title']
  end

  def href
    details['base_path']
  end

  def present?
    details.present?
  end

private

  def details
    @details ||= @linked_items.find { |ld| ld['content_id'] == content_id }
  end
end
