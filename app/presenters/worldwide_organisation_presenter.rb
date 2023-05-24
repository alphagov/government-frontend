class WorldwideOrganisationPresenter < ContentItemPresenter
  def body
    content_item.dig("details", "body")
  end
end
