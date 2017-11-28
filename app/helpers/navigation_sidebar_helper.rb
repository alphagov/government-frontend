module NavigationSidebarHelper
  def sidebar_link_to(link, section)
    if section === "related_items"
      link_to link[:text], link[:path], class: "app-c-navigation-sidebar__related-link", rel: link[:type]
    else
      link_to link[:text], link[:path], class: "app-c-navigation-sidebar__section-link", rel: link[:type]
    end
  end
end
