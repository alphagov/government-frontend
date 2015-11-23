module PhaseLabelHelper
  def render_phase_label(presented_object)
    if presented_object.respond_to?(:phase) && %w(alpha beta).include?(presented_object.phase)
      render partial: "govuk_component/#{presented_object.phase}_label"
    end
  end
end
