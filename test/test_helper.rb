ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
require 'support/govuk_content_schema_examples'

class ActiveSupport::TestCase
  include GovukContentSchemaExamples
end

# Note: This is so that slimmer is skipped, preventing network requests for
# content from static (i.e. core_layout.html.erb).
class ActionController::Base
  before_filter proc {
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true" unless ENV["USE_SLIMMER"]
  }
end
