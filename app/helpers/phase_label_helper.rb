module PhaseLabelHelper
  def render_phase_label(presented_object, message)
    if show_new_navigation?
      beta_message = <<~BETA_MESSAGE.html_safe
        This is a test version of the layout of this page.
        <a id=taxonomy-navigation-survey
          href='https://www.smartsurvey.co.uk/s/navigationsurvey2018?c=#{current_path_without_query_string}'
          target='_blank'
          rel='noopener noreferrer'>Take the survey to help us improve it</a>
      BETA_MESSAGE

      render 'govuk_publishing_components/components/phase_banner', phase: 'beta', message: beta_message

    elsif presented_object.respond_to?(:phase) && %w(alpha beta).include?(presented_object.phase)
      locals = {}
      locals[:message] = message if message.present?

      render 'govuk_publishing_components/components/phase_banner', locals.merge(phase: presented_object.phase)
    end
  end
end
