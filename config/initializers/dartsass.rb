APP_STYLESHEETS = {
  "application.scss" => "application.css",
  "components/_published-dates.scss" => "components/_published-dates.css",
  "views/_guide.scss" => "views/_guide.css",
  "views/_html-publication.scss" => "views/_html-publication.css",
  "views/_manual.scss" => "views/_manual.css",
  "views/_published-dates-button-group.scss" => "views/_published-dates-button-group.css",
  "views/_service_manual_guide.scss" => "views/_service_manual_guide.css",
  "views/_specialist-document.scss" => "views/_specialist-document.css",
}.freeze

all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.all_stylesheets)
Rails.application.config.dartsass.builds = all_stylesheets

Rails.application.config.dartsass.build_options << " --quiet-deps"
