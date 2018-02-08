class DocumentCollectionPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Metadata
  include ContentItem::Political
  include ContentItem::TitleAndContext
  include ContentItem::ContentsList

  def contents_items
    groups.map do |group|
      title = group["title"]
      { text: title, id: group_title_id(title) }
    end
  end

  def groups
    groups = content_item["details"]["collection_groups"].reject { |group|
      group_documents(group).empty?
    }

    groups.map { |group|
      group["documents"] = reject_withdrawn_documents(group)
      group
    }
  end

  def group_document_links(group, group_index)
    group_documents(group).each_with_index.map do |link, link_index|
      {
        link: {
          text: link["title"],
          path: link["base_path"],
          data_attributes: {
            track_category: 'navDocumentCollectionLinkClicked',
            track_action: "#{group_index + 1}.#{link_index + 1}",
            track_label: link["base_path"],
            track_options: {
              dimension28: group['documents'].count.to_s,
              dimension29: link["title"]
            }
          }
        },
        metadata: {
          public_updated_at: Time.zone.parse(link["public_updated_at"]),
          document_type: link["document_type"],
        },
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

  def first_item
    @body ||= body.present? ? parsed_body : Nokogiri::HTML(groups.first["body"])
    @body.css('div').first.first_element_child
  end
end
