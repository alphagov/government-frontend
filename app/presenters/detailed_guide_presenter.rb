class DetailedGuidePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::Metadata
  include ContentItem::NationalApplicability
  include ContentItem::Political
  include ContentItem::TitleAndContext

  def title_and_context
    super.tap do |t|
      t[:context] = I18n.t("content_item.schema_name.guidance", count: 1)
    end
  end

  def image
    content_item["details"]["image"]["url"] if content_item["details"]["image"]
  end

  def document_footer
    super.tap do |m|
      m[:other][related_guides_title] = related_guides
    end
  end

  def related_navigation
    nav = super
    nav[:related_items] += related_links("related_mainstream_content")
    nav[:related_guides] = related_links("related_guides")
    nav
  end

  # FIXME: This is a temporary removal of National Applicability
  # Once all formats have moved to new publisher/important metadata
  # components, we can remove here: app/presenters/content_item/national_applicability.rb:33
  def publisher_metadata
    super.tap { |m| m[:other].delete(:"Applies to") }
  end

private

  def related_links(key)
    raw_links = content_item["links"]
    guides = raw_links.fetch(key, [])
    guides.map { |g| { text: g["title"], path: g["base_path"] } }
  end

  def related_guides_title
    I18n.t('detailed_guide.related_guides')
  end
end
