module ServiceManualPhaseLabelHelper
  def render_phase_label(presented_object, message)
    if presented_object.respond_to?(:phase) && %w[alpha beta].include?(presented_object.phase)
      render "govuk_publishing_components/components/phase_banner",
             phase: presented_object.phase,
             ga4_tracking: true,
             message:
    end
  end
end
