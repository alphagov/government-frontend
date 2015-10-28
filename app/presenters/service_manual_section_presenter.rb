class ServiceManualSectionPresenter
  attr_reader :content_item, :title, :format, :description, :locale

  def initialize(content_item)
    @content_item = content_item

    @title = content_item["title"]
    @description = content_item["description"]
    @format = content_item["format"]
    @locale = content_item["locale"]
  end

  def link_groups
    links_data = content_item['links']['linked_items']
    Array(content_item['details']['link_groups']).map do |group_data|
      LinkGroup.new(group_data, links_data)
    end
  end

private

  class LinkGroup
    attr_reader :title, :description, :data

    def initialize(data, links)
      @data = data
      @links = links

      @title = data['title']
      @description = data['description']
    end

    def linked_items
      Array(data['linked_items']).map do |content_id|
        LinkedItem.new(content_id, @links)
      end
    end
  end

  class LinkedItem
    def initialize(content_id, links_data)
      @content_id = content_id
      @links_data = links_data
    end

    def label
      link_data['title']
    end

    def href
      link_data['base_path']
    end

  private

    def link_data
      @link_data ||= @links_data.find { |ld| ld['content_id'] == @content_id}
    end
  end

end
