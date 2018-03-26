module ContextualCommsAbTestable
  GOOGLE_ANALYTICS_CUSTOM_DIMENSION = 70

  def self.included(base)
    base.helper_method(
      :contextual_comms_test_variant,
    )
    base.after_action :set_test_response_header
  end

  def contextual_comms_test
    @contextual_comms_test ||= GovukAbTesting::AbTest.new(
      "ContextualComms",
      dimension: GOOGLE_ANALYTICS_CUSTOM_DIMENSION,
      allowed_variants: %w(NoCampaign BlueBoxCampaign NativeCampaign),
      control_variant: "NoCampaign"
    )
  end

  def contextual_comms_test_variant
    @contextual_comms_test_variant ||= contextual_comms_test.requested_variant(request.headers)
  end

  def set_test_response_header
    contextual_comms_test_variant.configure_response(response)
  end
  end
end
