module PhaseLabelHelper
  def render_phase_label(presented_object, message)
    if presented_object.respond_to?(:phase) && %w(alpha beta).include?(presented_object.phase)
      locals = {}
      locals[:message] = message if message.present?

      render "govuk_publishing_components/components/phase_banner", locals.merge(phase: presented_object.phase)
    end
  end
end
