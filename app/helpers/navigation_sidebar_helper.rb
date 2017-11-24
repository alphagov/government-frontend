module NavigationSidebarHelper
  def sidebar_link_to(link, section)
    if section === "related_items"
      link_to link[:text], link[:href], class: "app-c-navigation-sidebar__related-link"
    elsif section === "external_links"
      link_to link[:text], link[:href], class: "app-c-navigation-sidebar__external-related-link", rel: "external"
    else
      link_to link[:text], link[:href], class: "app-c-navigation-sidebar__section-link"
    end
  end
end
