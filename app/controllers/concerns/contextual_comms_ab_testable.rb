module ContextualCommsAbTestable
  GOOGLE_ANALYTICS_CUSTOM_DIMENSION = 70

  def self.included(base)
    base.helper_method(
      :contextual_comms_test_variant,
      :show_blue_box_campaign?,
      :show_native_campaign?,
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

  def show_blue_box_campaign?
    contextual_comms_test_variant.variant?("BlueBoxCampaign")
  end

  def show_native_campaign?
    contextual_comms_test_variant.variant?("NativeCampaign")
  end
end
