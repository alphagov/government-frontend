APP_STYLESHEETS = {
  "application.scss" => "application.css",
  "views/_html-publication.scss" => "views/_html-publication.css",
  "views/_manual.scss" => "views/_manual.css",
  "views/_published-dates-button-group.scss" => "views/_published-dates-button-group.css",
  "views/_specialist-document.scss" => "views/_specialist-document.css",
}.freeze

all_stylesheets = APP_STYLESHEETS.merge(GovukPublishingComponents::Config.component_guide_stylesheet)
Rails.application.config.dartsass.builds = all_stylesheets

Rails.application.config.dartsass.build_options << " --quiet-deps"
Rails.application.config.dartsass.build_options << " --silence-deprecation=import"
