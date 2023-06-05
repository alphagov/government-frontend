class WorldwideOfficePresenter < ContentItemPresenter
  DEFAULT_ORGANISATION_LOGO = "single-identity".freeze

  include ContentItem::ContentsList
  include ActionView::Helpers::UrlHelper

  def body
    content_item.dig("details", "access_and_opening_times")
  end

  def contact
    contact = content_item.dig("links", "contact")&.first

    WorldwideOrganisation::LinkedContactPresenter.new(contact)
  end

  def world_location_links
    return if world_locations.empty?

    links = world_locations.map do |location|
      link_to(location["title"], WorldLocationBasePath.for(location), class: "govuk-link")
    end

    links.to_sentence.html_safe
  end

  def sponsoring_organisation_links
    return if sponsoring_organisations.empty?

    links = sponsoring_organisations.map do |organisation|
      link_to(organisation["title"], organisation["base_path"], class: "sponsoring-organisation govuk-link")
    end

    links.to_sentence.html_safe
  end

  def organisation_logo
    first_sponsoring_organisation = sponsoring_organisations&.first

    {
      name: title,
      url: worldwide_organisation["base_path"],
      crest: first_sponsoring_organisation&.dig("details", "logo", "crest") || DEFAULT_ORGANISATION_LOGO,
      brand: first_sponsoring_organisation&.dig("details", "brand") || DEFAULT_ORGANISATION_LOGO,
    }
  end

private

  def worldwide_organisation
    content_item.dig("links", "worldwide_organisation")&.first
  end

  def sponsoring_organisations
    worldwide_organisation&.dig("links", "sponsoring_organisations") || []
  end

  def world_locations
    worldwide_organisation&.dig("links", "world_locations") || []
  end

  def show_contents_list?
    true
  end
end
