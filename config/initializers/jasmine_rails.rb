module JasmineRailsSkipSlimmer
  extend ActiveSupport::Concern

  included do
    before_action :skip_slimmer
  end

  def skip_slimmer
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true"
  end
end

JasmineRails::ApplicationController.include(JasmineRailsSkipSlimmer) if defined?(JasmineRails)
