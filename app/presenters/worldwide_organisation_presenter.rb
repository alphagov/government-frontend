class WorldwideOrganisationPresenter < ContentItemPresenter
  include ContentItem::Body

  def show_default_breadcrumbs?
    false
  end

  def social_media_accounts
    content_item.dig("details", "social_media_links") || []
  end

  def show_our_people_section?
    person_in_primary_role || people_in_non_primary_roles.any?
  end

  def person_in_primary_role
    return unless content_item["links"]["primary_role_person"]

    person = content_item.dig("links", "primary_role_person").first
    current_roles = person.dig("links", "role_appointments").select { |role_app| role_app.dig("details", "current") }

    {
      name: person["title"],
      href: person["web_url"],
      image_url: person["details"]["image"]["url"],
      image_alt: person["details"]["image"]["alt_text"],
      description: current_roles.map { |role_app| role_app.dig("links", "role").first["title"] }.join,
    }
  end

  def people_in_non_primary_roles
    secondary_role_person = content_item["links"]["secondary_role_person"] || []
    office_staff = content_item["links"]["office_staff"] || []
    people = secondary_role_person + office_staff
    return [] unless people.any?

    people.map do |person|
      current_roles = person.dig("links", "role_appointments").select { |role_app| role_app.dig("details", "current") }

      {
        name: person["title"],
        href: person["web_url"],
        description: current_roles.map { |role_app| role_app.dig("links", "role").first["title"] }.join,
      }
    end
  end
end
