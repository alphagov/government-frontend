class WorldwideOrganisationPagePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include WorldwideOrganisation::Branding

  def formatted_title
    worldwide_organisation&.formatted_title
  end

  def title
    page["title"]
  end

  def summary
    page["summary"]
  end

  def body
    page["body"]
  end

  def show_default_breadcrumbs?
    false
  end

  def page
    pages = content_item.dig("details", "page_parts")

    pages.select { |page|
      page["slug"] == requested_path.gsub("#{content_item['base_path']}/", "")
    }.first
  end

  def worldwide_organisation
    WorldwideOrganisationPresenter.new(content_item, requested_path, view_context)
  end

  def sponsoring_organisations
    worldwide_organisation&.sponsoring_organisations
  end

private

  def show_contents_list?
    true
  end
end
