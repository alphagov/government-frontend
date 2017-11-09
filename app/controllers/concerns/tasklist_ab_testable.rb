module TasklistABTestable
  TASKLIST_DIMENSION = 66

  def self.included(base)
    base.helper_method(
      :tasklist_variant,
      :tasklist_ab_test_applies?,
      :should_show_tasklist_sidebar?
    )

    base.after_action :set_tasklist_response_header
  end

  def tasklist_ab_test
    @tasklist_ab_test ||=
      GovukAbTesting::AbTest.new(
        "TaskListSidebar",
        dimension: TASKLIST_DIMENSION
      )
  end

  def tasklist_ab_test_applies?
    page_is_included_in_test?
  end

  def should_show_tasklist_sidebar?
    tasklist_ab_test_applies? && tasklist_variant.variant?('B')
  end

  def tasklist_variant
    @tasklist_variant ||=
      tasklist_ab_test.requested_variant(request.headers)
  end

  def set_tasklist_response_header
    tasklist_variant.configure_response(response) if tasklist_ab_test_applies?
  end

  def page_is_included_in_test?
    TasklistPages::PRIMARY_PAGES.include?(request.path) ||
      TasklistPages::SECONDARY_PAGES.include?(request.path) ||
      TasklistPages::MATCHING_PAGES.include?(request.path)
  end
end
