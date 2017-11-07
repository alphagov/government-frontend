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
    TasklistABTestable::TASKLIST_PRIMARY_PAGES.include?(request.path)
  end

  def should_show_tasklist_header?
      tasklist_header_ab_test_applies? && tasklist_header_variant.variant_b?
  end

  def tasklist_header_variant
    @tasklist_header_variant ||=
      tasklist_header_ab_test.requested_variant(request.headers)
  end

  def set_tasklist_header_response_header
    tasklist_header_variant.configure_response(response) if tasklist_header_ab_test_applies?
  end
end
