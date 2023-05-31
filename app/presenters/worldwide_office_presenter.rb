class WorldwideOfficePresenter < ContentItemPresenter
  include ContentItem::ContentsList

  def body
    content_item.dig("details", "access_and_opening_times")
  end

  def contact
    contact = content_item.dig("links", "contact")&.first

    WorldwideOrganisation::LinkedContactPresenter.new(contact)
  end

  private

  def show_contents_list?
    true
  end
end
