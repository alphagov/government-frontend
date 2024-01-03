class WorldwideOfficePresenter < ContentItemPresenter
  include ContentItem::ContentsList
  include WorldwideOrganisation::Branding

  def formatted_title
    worldwide_organisation&.formatted_title
  end

  def body
    content_item.dig("details", "access_and_opening_times")
  end

  def contact
    contact = content_item.dig("links", "contact")&.first

    WorldwideOrganisation::LinkedContactPresenter.new(contact)
  end

  def show_default_breadcrumbs?
    false
  end

  def worldwide_organisation
    return unless content_item.dig("links", "worldwide_organisation")

    WorldwideOrganisationPresenter.new(content_item.dig("links", "worldwide_organisation").first, requested_path, view_context)
  end

  def sponsoring_organisations
    worldwide_organisation&.sponsoring_organisations
  end

private

  def show_contents_list?
    true
  end
end
