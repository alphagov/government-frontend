module TasklistABTestable
  TASKLIST_DIMENSION = 66

  TASKLIST_PRIMARY_PAGES = %w(
    /legal-obligations-drivers-riders
    /driving-lessons-learning-to-drive
    /government/publications/car-show-me-tell-me-vehicle-safety-questions
    /theory-test/revision-and-practice
    /theory-test/what-to-take
    /pass-plus
  ).freeze

  TASKLIST_SECONDARY_PAGES = %w(
    /driving-eyesight-rules
    /complain-about-a-driving-instructor
    /driving-test-cost
    /government/publications/driving-instructor-grades-explained
    /guidance/rules-for-observing-driving-tests
    /speed-limits
    /seat-belts-law
    /vehicle-insurance
    /report-an-illegal-driving-instructor
    /government/publications/know-your-traffic-signs
    /apply-for-your-full-driving-licence
    /driving-licence-fees
    /report-driving-test-impersonation
    /government/publications/application-for-refunding-out-of-pocket-expenses
    /government/publications/l-plate-size-rules
    /automatic-driving-licence-to-manual
    /government/publications/drivers-record-for-learner-drivers
  ).freeze

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
    TASKLIST_PRIMARY_PAGES.include?(request.path) ||
      TASKLIST_SECONDARY_PAGES.include?(request.path)
  end
end
