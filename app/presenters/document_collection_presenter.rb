class DocumentCollectionPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Metadata
  include ContentItem::Political
  include ContentItem::TitleAndContext
  include ContentItem::ContentsList
  include ContentItem::SinglePageNotificationButton
  include DocumentCollection::SignupLink

  def contents_items
    super + groups.map do |group|
      title = group["title"]
      { text: title, id: group_title_id(title) }
    end
  end

  def groups
    groups = content_item["details"]["collection_groups"].reject do |group|
      group_documents(group).empty?
    end

    groups.map do |group|
      group["documents"] = reject_withdrawn_documents(group)
      group
    end
  end

  def group_document_links(group)
    group_documents(group).each.map do |link|
      {
        link: {
          text: link["title"],
          path: link["base_path"],
        },
        metadata: {
          public_updated_at: group_document_link_public_updated_at(link),
          document_type: I18n.t(
            "content_item.schema_name.#{link['document_type']}",
            count: 1,
            default: nil,
          ),
        },
      }
    end
  end

  def group_heading(group)
    title = group["title"]
    heading_level = show_contents_list? ? :h3 : :h2
    view_context.content_tag(
      heading_level,
      title,
      class: "govuk-heading-m govuk-!-font-size-27",
      id: group_title_id(title),
    )
  end

private

  def group_document_link_public_updated_at(link)
    disallowed_document_types = %w[answer
                                   completed_transaction
                                   guide
                                   help_page
                                   local_transaction
                                   place
                                   simple_smart_answer
                                   transaction
                                   smart_answer]

    return nil if disallowed_document_types.include?(link["document_type"])

    link["public_updated_at"]&.then { |time| Time.zone.parse(time) }
  end

  def group_documents(group)
    group["documents"].map { |id| documents_hash[id] }.compact
  end

  def group_title_id(title)
    title.tr(" ", "-").downcase
  end

  def documents_hash
    @documents_hash ||= Array(content_item["links"]["documents"]).index_by { |d| d["content_id"] }
  end

  def reject_withdrawn_documents(group)
    group_documents(group)
      .reject { |document| document["withdrawn"] }
      .map { |document| document["content_id"] }
  end

  def first_item
    @body ||= body.present? ? parsed_body : Nokogiri::HTML(groups.first["body"])
    @body.css("div").first.first_element_child
  end
end
