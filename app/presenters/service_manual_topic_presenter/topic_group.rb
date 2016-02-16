class ServiceManualTopicPresenter::TopicGroup
  attr_reader :name, :description, :data

  def initialize(data, linked_items)
    @data = data
    @linked_items = linked_items

    @name = data['name']
    @description = data['description']
  end

  def linked_items
    linked_items = Array(data['content_ids']).map do |content_id|
      ServiceManualTopicPresenter::LinkedItem.new(content_id, @linked_items)
    end
    linked_items.select(&:present?)
  end

  def present?
    linked_items.any?
  end
end
