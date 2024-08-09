class ServiceManualPresenter < ContentItemPresenter
  def links
    @links ||= content_item["links"] || {}
  end

  def details
    @details ||= content_item["details"] || {}
  end

  def include_search_in_header?
    true
  end

  def service_manual?
    true
  end

  def service_manual_homepage?
    content_item["document_type"] == "service_manual_homepage"
  end

  def show_phase_banner?
    false
  end

  def show_default_breadcrumbs?
    false
  end
end
