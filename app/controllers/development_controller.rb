class DevelopmentController < ApplicationController
  layout false

  def index
    @schema_names = %w[consultation
                       contact
                       corporate_information_page
                       placeholder_corporate_information_page
                       publication
                       specialist_document
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
