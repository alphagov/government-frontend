require "gds_api/test_helpers/content_store"

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
    include GdsApi::TestHelpers::ContentStore
  end

  def content_store_has_schema_example(schema_name, example_name)
    document = govuk_content_schema_example(schema_name, example_name)
    stub_content_store_has_item(document["base_path"], document)
    document
  end

  def content_store_has_example_item(base_path, schema:, example: nil)
    content_item = GovukSchemas::Example.find(schema, example_name: example || schema)

    content_item["links"] ||= {}
    content_item["base_path"] = base_path

    stub_content_store_has_item(base_path, content_item)
    content_item
  end

  def govuk_content_schema_example(schema_name, example_name)
    GovukSchemas::Example.find(schema_name, example_name: example_name)
  end

  module ClassMethods
    def all_examples_for_supported_schemas
      GovukSchemas::Example.find_all(supported_schemas)
    end

    def supported_schemas
      %w[
        case_study
        coming_soon
        html_publication
        redirect
        statistics_announcement
        take_part
        topical_event_about_page
        unpublishing
        working_group
      ]
    end
  end
end
