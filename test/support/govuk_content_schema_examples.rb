require 'gds_api/test_helpers/content_store'

# Include this module to get access to the GOVUK Content Schema examples in the
# tests.
#
# By default, the govuk-content-schemas repository is expected to be located
# at ../govuk-content-schemas. This can be overridden with the
# GOVUK_CONTENT_SCHEMAS_PATH environment variable, for example:
#
#   $ GOVUK_CONTENT_SCHEMAS_PATH=/some/dir/govuk-content-schemas bundle exec rake
#
# Including this module will automatically stub out all the available examples
# with the content store.
module GovukContentSchemaExamples
  extend ActiveSupport::Concern

  included do
    unless Dir.exists?(govuk_content_schemas_path)
      raise "Could not find govuk-content-schemas in #{govuk_content_schemas_path}. Make sure it is present to run test suite."
    end

    include GdsApi::TestHelpers::ContentStore

    setup do
      stub_example_content_items_in_content_store
    end

    # Returns a hash representing an example content item from govuk-content-schemas
    def govuk_content_schema_example(name)
      self.class.govuk_content_schema_examples[name + '.json']
    end

  private

    def stub_example_content_items_in_content_store
      self.class.govuk_content_schema_examples.each_value do |content_item|
        content_store_has_item(content_item['base_path'], content_item)
      end
    end
  end

  module ClassMethods
    def govuk_content_schema_examples
      govuk_content_schema_example_files.each_with_object({}) do |file_path, hash|
        filename = File.basename(file_path)
        hash[filename] = JSON.parse(File.read(file_path))
      end
    end

    def govuk_content_schema_example_files
      Dir.glob Rails.root.join(govuk_content_schemas_path).join("formats/*/frontend/examples/*.json")
    end


    def govuk_content_schemas_path
      ENV['GOVUK_CONTENT_SCHEMAS_PATH'] || '../govuk-content-schemas'
    end
  end
end
