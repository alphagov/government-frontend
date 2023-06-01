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

  def show_corporate_info_section?
    corporate_information_pages.any? || secondary_corporate_information.present?
  end

  def corporate_information_pages
    cips = content_item.dig("links", "corporate_information_pages")
    return [] if cips.blank?

    ordered_cips = content_item.dig("details", "ordered_corporate_information_pages")
    return [] if ordered_cips.blank?

    ordered_cips.map do |cip|
      {
        text: cip["title"],
        url: cips.find { |cp| cp["content_id"] == cip["content_id"] }["web_url"],
      }
    end
  end

  def secondary_corporate_information
    content_item.dig("details", "secondary_corporate_information_pages").to_s
  end
end
