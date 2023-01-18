class ServiceManualServiceToolkitPresenter < ServiceManualPresenter
  def include_search_in_header?
    false
  end

  def collections
    details.fetch("collections", [])
  end
end
