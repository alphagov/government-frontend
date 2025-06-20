class DevelopmentController < ApplicationController
  layout false

  def index
    @schema_names = %w[call_for_evidence
                       case_study
                       consultation
                       contact
                       corporate_information_page
                       detailed_guide
                       document_collection
                       guide
                       html_publication
                       placeholder_corporate_information_page
                       publication
                       service_sign_in
                       specialist_document
                       statistical_data_set
                       statistics_announcement
                       topical_event_about_page
                       working_group]

    @paths = YAML.load_file(Rails.root.join("config/govuk_examples.yml"))
  end

private

  helper_method :remove_secrets

  def remove_secrets(original_url)
    parsed_url = URI.parse(original_url)
    original_url = original_url.gsub(parsed_url.user, "***") if parsed_url.user
    original_url = original_url.gsub(parsed_url.password, "***") if parsed_url.password
    original_url
  end
end
