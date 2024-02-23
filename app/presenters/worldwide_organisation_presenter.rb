class WorldwideOrganisationPresenter < ContentItemPresenter
  include ContentItem::Body
  include WorldwideOrganisation::Branding
  include ActionView::Helpers::UrlHelper

  WorldwideOffice = Struct.new(:contact, :has_access_and_opening_times?, :public_url, keyword_init: true)

  def formatted_title
    content_item.dig("details", "logo", "formatted_title")
  end

  def sponsoring_organisation_links
    return if sponsoring_organisations.empty?

    links = sponsoring_organisations.map do |organisation|
      link_to(organisation["title"], organisation["base_path"], class: "sponsoring-organisation govuk-link")
    end

    links.to_sentence.html_safe
  end

  def world_location_links
    return if world_locations.empty?

    world_location_name_translations = content_item.dig("details", "world_location_names")

    links = world_locations.map do |location|
      world_location_translation = world_location_name_translations.find do |translation|
        translation["content_id"] == location["content_id"]
      end
      link_to(world_location_translation["name"], WorldLocationBasePath.for(location), class: "govuk-link")
    end

    links.to_sentence.html_safe
  end

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
    current_roles = roles_for_person(person["content_id"])

    {
      name: person["title"],
      href: person["web_url"],
      image_url: person["details"]["image"]["url"],
      image_alt: person["details"]["image"]["alt_text"],
      description: presented_title_for_roles(current_roles),
    }
  end

  def people_in_non_primary_roles
    secondary_role_person = content_item["links"]["secondary_role_person"] || []
    office_staff = content_item["links"]["office_staff"] || []
    people = secondary_role_person + office_staff
    return [] unless people.any?

    people.map do |person|
      current_roles = roles_for_person(person["content_id"])

      {
        name: person["title"],
        href: person["web_url"],
        description: presented_title_for_roles(current_roles),
      }
    end
  end

  def main_office
    return unless (office_item = content_item.dig("details", "main_office_parts")&.first)

    office_contact_item = linked_contact(office_item["contact_content_id"])
    return unless office_contact_item

    office(office_item, office_contact_item)
  end

  def home_page_offices
    return [] unless content_item.dig("details", "home_page_office_parts")

    content_item.dig("details", "home_page_office_parts").map { |office|
      contact = linked_contact(office["contact_content_id"])
      next unless contact

      office(office, contact)
    }.compact
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

  def sponsoring_organisations
    content_item.dig("links", "sponsoring_organisations") || []
  end

private

  def office(office, contact)
    WorldwideOffice.new(
      contact: WorldwideOrganisation::LinkedContactPresenter.new(contact),
      has_access_and_opening_times?: office["access_and_opening_times"].present?,
      public_url: "#{content_item['base_path'].gsub(/\..*?$/, '')}/#{office['slug']}",
    )
  end

  def linked_contact(contact_content_id)
    content_item.dig("links", "contacts").select { |contact|
      contact["content_id"] == contact_content_id
    }.first
  end

  def presented_title_for_roles(roles)
    roles
      .map { |role| role["title"] }
      .compact.join(", ")
  end

  def roles_for_person(person_content_id)
    content_item
    .dig("details", "people_role_associations")
    .select { |people_role_association| people_role_association["person_content_id"] == person_content_id }
    .first["role_appointments"]
    .pluck("role_content_id")
    .map { |role_content_id|
      content_item.dig("links", "roles").select do |role|
        role["content_id"] == role_content_id
      end
    }
    .flatten
  end

  def world_locations
    content_item.dig("links", "world_locations") || []
  end
end
