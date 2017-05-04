ENV['RAILS_ENV'] ||= 'test'
ENV['GOVUK_APP_DOMAIN'] = 'test.gov.uk'
ENV['GOVUK_ASSET_ROOT'] = 'http://static.test.gov.uk'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'slimmer/test_helpers/govuk_components'
require 'mocha/mini_test'

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

class Minitest::Test
  def teardown
    Capybara.current_session.driver.clear_memory_cache
  end
end

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :active_support
end

class ActiveSupport::TestCase
  include GovukContentSchemaExamples
  include Slimmer::TestHelpers::GovukComponents

  def setup
    stub_shared_component_locales
  end
end

# Note: This is so that slimmer is skipped, preventing network requests for
# content from static (i.e. core_layout.html.erb).
class ActionController::Base
  before_action proc {
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true" unless ENV["USE_SLIMMER"]
  }
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Slimmer::TestHelpers::GovukComponents

  def setup
    stub_shared_component_locales
  end

  def assert_has_component_metadata_pair(label, value)
    assert_component_parameter("metadata", label, value)
  end

  def assert_has_component_document_footer_pair(label, value)
    assert_component_parameter("document_footer", label, value)
  end

  def assert_component_parameter(component, label, value)
    within shared_component_selector(component) do
      # Flatten top level / "other" args, for consistent hash access
      component_args = JSON.parse(page.text).tap do |args|
        args.merge!(args.delete("other")) if args.key?("other")
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
    within_component_govspeak do
      assert_equal content.squish, JSON.parse(page.text).fetch("content").squish
    end
  end

  def within_component_govspeak
    within(shared_component_selector("govspeak")) do
      component_args = JSON.parse(page.text)
      yield component_args
    end
  end

  def assert_has_component_breadcrumbs(breadcrumbs)
    within shared_component_selector("breadcrumbs") do
      assert_equal breadcrumbs, JSON.parse(page.text).deep_symbolize_keys.fetch(:breadcrumbs)
    end
  end

  def assert_has_component_organisation_logo(logo, index = 1)
    within(shared_component_selector("organisation_logo") + ":nth-of-type(#{index})") do
      assert_equal logo, JSON.parse(page.text).deep_symbolize_keys
    end
  end

  def assert_has_component_government_navigation_active(active)
    assert_component_parameter("government_navigation", "active", active)
  end

  def assert_has_contents_list(contents)
    assert page.has_css?(".dash-list"), "Failed to find an element with a class of dash-list"
    within ".dash-list" do
      contents.each do |heading|
        selector = "a[href=\"##{heading[:id]}\"]"
        text = heading.fetch(:text)
        assert page.has_css?(selector), "Failed to find an element matching: #{selector}"
        assert page.has_css?(selector, text: text), "Failed to find an element matching #{selector} with text: #{text}"
      end
    end
  end

  def has_component_meta_tag(key, value, content)
    assert page.has_css? "meta[#{key}=\"#{value}\"][content=\"#{content}\"]", visible: false
  end

  def setup_and_visit_content_item(name, print = false)
    @content_item = JSON.parse(get_content_example(name)).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      print ? visit("#{item['base_path']}?medium=print") : visit(item['base_path'])
    end
  end

  def setup_and_visit_random_content_item(document_type: schema_format)
    schema = GovukSchemas::Schema.find(frontend_schema: schema_format)
    random_example = GovukSchemas::RandomExample.new(schema: schema)

    payload = random_example.merge_and_validate(document_type: document_type)
    path = payload["base_path"]

    stub_request(:get, %r{#{path}})
      .to_return(status: 200, body: payload.to_json, headers: {})

    visit path
  end

  def get_content_example(name)
    get_content_example_by_format_and_name(schema_format, name)
  end

  def get_content_example_by_format_and_name(format, name)
    GovukContentSchemaTestHelpers::Examples.new.get(format, name)
  end

  # Override this method if your test file doesn't match the convention
  def schema_format
    self.class.to_s.gsub('Test', '').underscore
  end
end
