class WorldwideOfficePresenter < ContentItemPresenter
  include ContentItem::ContentsList

  def body
    content_item.dig("details", "access_and_opening_times")
  end

  private

  def show_contents_list?
    true
  end
end
