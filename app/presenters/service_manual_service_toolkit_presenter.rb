class ServiceManualServiceToolkitPresenter < ServiceManualPresenter
  def include_search_in_header?
    false
  end

  def collections
    details.fetch("collections", [])
  end

  def exclude_main_wrapper_class?
    true
  end

  def show_default_breadcrumbs?
    false
  end
end
