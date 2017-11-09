module TasklistHeaderABTestable
  TASKLIST_HEADER_DIMENSION = 44

  def self.included(base)
    base.helper_method(
      :tasklist_header_variant,
      :tasklist_header_ab_test_applies?,
      :should_show_tasklist_header?
    )

    base.after_action :set_tasklist_header_response_header
  end

  def tasklist_header_ab_test
    @tasklist_header_ab_test ||=
      GovukAbTesting::AbTest.new(
        "TaskListHeader",
        dimension: TASKLIST_HEADER_DIMENSION
     )
  end

  def tasklist_header_ab_test_applies?
    page_is_included_in_test?
  end

  def should_show_tasklist_header?
    tasklist_header_ab_test_applies? && tasklist_header_variant.variant?("B")
  end

  def tasklist_header_variant
    @tasklist_header_variant ||=
      tasklist_header_ab_test.requested_variant(request.headers)
  end

  def set_tasklist_header_response_header
    tasklist_header_variant.configure_response(response) if tasklist_header_ab_test_applies?
  end

  def page_is_included_in_test?
    TasklistPages::PRIMARY_PAGES.include?(request.path) ||
      TasklistPages::SECONDARY_PAGES.include?(request.path) ||
      TasklistPages::MATCHING_PAGES.include?(request.path)
  end
end
