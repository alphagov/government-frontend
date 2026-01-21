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

  def govuk_content_schema_example(schema_name, example_name)
    GovukSchemas::Example.find(schema_name, example_name:)
  end

  def stub_parent_breadcrumbs(document, schema)
    parents = document.dig("links", "parent")
    return if parents.nil?

    stub_content_store_has_item(parents.first["base_path"], document) if schema == "html_publication"
  end

  module ClassMethods
    def all_examples_for_supported_schemas
      supported_schemas.flat_map { |format| GovukSchemas::Example.find_all(format) }
    end

    def supported_schemas
      %w[
        html_publication
        topical_event_about_page
        working_group
      ]
    end
  end
end
