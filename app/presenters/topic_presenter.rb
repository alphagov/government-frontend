class TopicPresenter
  ContentOwner = Struct.new(:title, :href)
  attr_reader :content_item, :title, :format, :description, :locale

  def initialize(content_item)
    @content_item = content_item

    @title = content_item["title"]
    @description = content_item["description"]
    @format = content_item["format"]
    @locale = content_item["locale"]
  end

  def breadcrumbs
    combined_breadcrumbs = parent_breadcrumbs << topic_breadcrumb

    if combined_breadcrumbs.length > 1
      combined_breadcrumbs
    else
      []
    end
  end

  def groups
    linked_items = content_item['links']['linked_items']
    topic_groups = Array(content_item['details']['groups']).map do |group_data|
      TopicPresenter::TopicGroup.new(group_data, linked_items)
    end
    topic_groups.select(&:present?)
  end

  def content_owners
    @content_owners ||= Array(content_item['links']['content_owners']).map do |data|
      ContentOwner.new(data['title'], data['base_path'])
    end
  end

private

  def topic_breadcrumb
    { title: title }
  end

  def parent_breadcrumbs
    Array(content_item['links']['parent']).map do |parent|
      {
        title: parent['title'],
        url: parent['base_path']
      }
    end
  end
end
