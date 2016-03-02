ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/minitest'
require 'support/govuk_content_schema_examples'
require 'capybara/rails'
require 'slimmer/test_helpers/shared_templates'
require "minitest/pride"

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

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Slimmer::TestHelpers::SharedTemplates

  def assert_has_component_metadata_pair(label, value)
    within shared_component_selector("metadata") do
      # Flatten top level / "other" args, for consistent hash access
      component_args = JSON.parse(page.text).tap do |args|
        args.merge!(args.delete("other"))
      end
      assert_equal value, component_args.fetch(label)
    end
  end

  def assert_has_component_title(title)
    within shared_component_selector("title") do
      assert_equal title, JSON.parse(page.text).fetch("title")
    end
  end

  def assert_has_component_govspeak(content)
    within shared_component_selector("govspeak") do
      assert_equal content, JSON.parse(page.text).fetch("content")
    end
  end

  def assert_has_component_breadcrumbs(breadcrumbs)
    within shared_component_selector("breadcrumbs") do
      assert_equal breadcrumbs, JSON.parse(page.text).deep_symbolize_keys.fetch(:breadcrumbs)
    end
  end

  def assert_has_contents_list(contents)
    within ".dash-list" do
      contents.each do |heading|
        assert page.has_css?("a[href=\"##{heading[:id]}\"]", text: heading[:text])
      end
    end
  end

  def setup_and_visit_content_item(name)
    @content_item = JSON.parse(get_content_example(name)).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit item["base_path"]
    end
  end

  def get_content_example(name)
    GovukContentSchemaTestHelpers::Examples.new.get(schema_format, name)
  end

  # Override this method if your test file doesn't match the convention
  def schema_format
    self.class.to_s.gsub('Test', '').underscore
  end
end
