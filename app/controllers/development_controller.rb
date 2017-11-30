class DevelopmentController < ApplicationController
  layout false

  def index
    @schema_names = %w[answer case_study coming_soon consultation contact
                       corporate_information_page detailed_guide document_collection
                       fatality_notice guide help_page html_publication news_article
                       placeholder_corporate_information_page publication service_sign_in specialist_document
                       speech statistical_data_set statistics_announcement take_part
                       topical_event_about_page travel_advice working_group
                       world_location_news_article]

    @paths = YAML.load_file("test/wraith/config.yaml")["paths"]
  end
end
