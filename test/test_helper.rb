ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  def read_content_store_fixture(basename)
    File.read(Rails.root.join("test", "fixtures", "content_store", "#{basename}.json"))
  end
end

# Include this module to get access to the GOVUK Content Schema examples in test
# files.
#
# By default, the govuk-content-schemas repository is expected to be located
# at ../govuk-content-schemas. This can be overridden with the
# GOVUK_CONTENT_SCHEMAS_PATH environment variable, for example:
#
#   $ GOVUK_CONTENT_SCHEMAS_PATH=/some/dir/govuk-content-schemas bundle exec rake
#
module GovukContentSchemaExamples
  extend ActiveSupport::Concern

  included do
    include GdsApi::TestHelpers::ContentStore

    setup do
      self.class.govuk_content_schema_examples.each_value do |content_item|
        content_store_has_item(content_item['base_path'], content_item)
      end
    end
  end

  module ClassMethods
    # Returns an array of all the govuk content examples in govuk-content-schemas
    def govuk_content_schema_example_files
      Dir.glob Rails.root.join(govuk_content_schemas_path).join("formats/*/frontend/examples/*.json")
    end

    # Returns a hash representing all the content examples in govuk-content-schemas
    def govuk_content_schema_examples
      govuk_content_schema_example_files.each_with_object({}) do |file_path, hash|
        filename = File.basename(file_path)
        hash[filename] = JSON.parse(File.read(file_path))
      end
    end

    def govuk_content_schemas_path
      ENV['GOVUK_CONTENT_SCHEMAS_PATH'] || '../govuk-content-schemas'
    end
  end
end
