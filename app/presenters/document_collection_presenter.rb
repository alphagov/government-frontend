class DocumentCollectionPresenter < ContentItemPresenter
  include Political
  include Linkable
  include Updatable
  include Withdrawable
  include ActionView::Helpers::UrlHelper

  def contents
    groups.map do |group|
      title = group["title"]
      link_to(title, "##{group_title_id(title)}")
    end
  end

  def groups
    content_item["details"]["collection_groups"]
  end

  def group_document_links(group)
    group_documents(group).map do |link|
      link_to(link["title"], link["base_path"])
    end
  end

  def group_heading(group)
    title = group["title"]
    content_tag :h3, title, class: "group-title", id: group_title_id(title)
  end

private

  def group_documents(group)
    group["documents"].map { |id| documents_hash[id] }
  end

  def group_title_id(title)
    title.tr(' ', '-').downcase
  end

  def documents_hash
    @documents_hash ||= content_item["links"]["documents"].map { |d| [d["content_id"], d] }.to_h
  end
end
