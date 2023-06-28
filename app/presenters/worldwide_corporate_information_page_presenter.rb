class WorldwideCorporateInformationPagePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include WorldwideOrganisation::Branding

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

  def organisation_logo
    super.merge!(name: worldwide_organisation&.title)
  end

private

  def show_contents_list?
    true
  end
end
