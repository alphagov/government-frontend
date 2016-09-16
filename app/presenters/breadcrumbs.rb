module Breadcrumbs
  def breadcrumbs
    return [] unless parent

    direct_parent = parent
    ordered_parents = []

    while direct_parent
      ordered_parents.unshift(
        title: direct_parent["title"],
        url: direct_parent["base_path"],
      )
      direct_parent = direct_parent = direct_parent.dig("links", "parent", 0)
    end

    ordered_parents.unshift(title: "Home", url: "/")
  end
end
