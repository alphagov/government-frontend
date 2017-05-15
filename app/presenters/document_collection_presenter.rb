class DocumentCollectionPresenter < ContentItemPresenter
  include Body
  include Metadata
  include Political
  include TitleAndContext
  include ContentsList

  def contents_items
    groups.map do |group|
      title = group["title"]
      { text: title, id: group_title_id(title) }
    end
  end

  def groups
    groups = content_item["details"]["collection_groups"].reject { |group|
      group_document_links(group).empty?
    }

    groups.map { |group|
      group["documents"] = reject_withdrawn_documents(group)
      group
    }
  end

  def group_document_links(group)
    group_documents(group).map do |link|
      {
        public_updated_at: Time.zone.parse(link["public_updated_at"]),
        document_type: link["document_type"],
        title: link["title"],
        base_path: link["base_path"]
      }
    end
  end

  def group_heading(group)
    title = group["title"]
    content_tag :h3, title, class: "group-title", id: group_title_id(title)
  end

private

  def group_documents(group)
    group["documents"].map { |id| documents_hash[id] }.compact
  end

  def group_title_id(title)
    title.tr(' ', '-').downcase
  end

  def documents_hash
    @documents_hash ||= Array(content_item["links"]["documents"]).map { |d| [d["content_id"], d] }.to_h
  end

  def reject_withdrawn_documents(group)
    group_documents(group)
      .reject { |document| document["withdrawn"] }
      .map { |document| document["content_id"] }
  end
end
