module ABTestable
  def education_navigation_ab_testing_group
    request.headers["HTTP_GOVUK_ABTEST_EDUCATIONNAVIGATION"] == "B" ? "B" : "A"
  end
end
