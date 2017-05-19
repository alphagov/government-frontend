module EpilepsyDrivingStartButtonVariantABTestable
  EPILEPSY_AND_DRIVING_PATH = ['/epilepsy-and-driving'].freeze

  def should_show_dvla_start_button_variant?
    epilepsy_driving_start_button_variant.variant_b? && is_epilepsy_driving_tested_path?
  end

  def is_epilepsy_driving_tested_path?
    EPILEPSY_AND_DRIVING_PATH.include? request.path
  end

  def epilepsy_driving_start_button_variant
    @epilepsy_driving_start_button_variant ||= epilepsy_driving_ab_test.requested_variant request.headers
  end

  def set_epilepsy_driving_start_button_response_header
    epilepsy_driving_start_button_variant.configure_response response
  end

private

  def epilepsy_driving_ab_test
    @ab_test ||= GovukAbTesting::AbTest.new("EpilepsyDrivingStart", dimension: 13)
  end
end
