class WorldwideOrganisationPresenter < ContentItemPresenter
  include ContentItem::Body

  def show_default_breadcrumbs?
    false
  end

  def social_media_accounts
    content_item.dig("details", "social_media_links") || []
  end
end
