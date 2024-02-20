class WorldwideOrganisationOfficePresenter < ContentItemPresenter
  include ContentItem::ContentsList
  include WorldwideOrganisation::Branding

  def formatted_title
    worldwide_organisation&.formatted_title
  end

  def body
    office["access_and_opening_times"]
  end

  def contact
    associated_contact = content_item.dig("links", "contacts").select { |contact|
      contact["content_id"] == office["contact_content_id"]
    }.first

    WorldwideOrganisation::LinkedContactPresenter.new(associated_contact)
  end

  def show_default_breadcrumbs?
    false
  end

  def office
    all_offices = content_item.dig("details", "main_office_parts") + content_item.dig("details", "home_page_office_parts")

    all_offices.select { |office|
      office["slug"] == requested_path.gsub("#{content_item['base_path']}/", "")
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
