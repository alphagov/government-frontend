ENV['RAILS_ENV'] ||= 'test'
ENV['GOVUK_APP_DOMAIN'] = 'test.gov.uk'
ENV['GOVUK_ASSET_ROOT'] = 'http://static.test.gov.uk'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'mocha/minitest'
require 'capybara/minitest'
require 'faker'

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :active_support
end

class ActiveSupport::TestCase
  include GovukContentSchemaExamples
end

# Note: This is so that slimmer is skipped, preventing network requests for
# content from static (i.e. core_layout.html.erb).
class ActionController::Base
  before_action :set_skip_slimmer_header

  def set_skip_slimmer_header
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true" unless ENV["USE_SLIMMER"]
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def assert_has_component_metadata_pair(label, value)
    assert page.has_content?(label)
    assert page.has_content?(value)
  end

  def assert_has_component_title(title)
    assert page.has_css?('h1', text: title)
  end

  def assert_has_component_organisation_logo
    assert page.has_css?(".gem-c-organisation-logo")
  end

  def assert_has_component_government_navigation_active(active)
    assert page.has_css?("a", class: 'active', text: active)
  end

  def assert_has_contents_list(contents)
    assert page.has_css?(".gem-c-contents-list"), "Failed to find an element with a class of contents-list"
    within ".gem-c-contents-list" do
      contents.each do |heading|
        selector = "a[href=\"##{heading[:id]}\"]"
        text = heading.fetch(:text)
        assert page.has_css?(selector), "Failed to find an element matching: #{selector}"
        assert page.has_css?(selector, text: text), "Failed to find an element matching #{selector} with text: #{text}"
      end
    end
  end

  def assert_has_published_dates(published = nil, last_updated = nil, history_link = false, element_index = 0)
    text = []
    text << published if published
    text << last_updated if last_updated
    within(all(".app-c-published-dates")[element_index]) do
      assert page.has_text?(text.join("\n")), "Published dates #{text.join("\n")} not found"
      if history_link
        assert page.has_link?("see all updates", href: "#history"), "Updates link not found"
      end
    end
  end

  def assert_has_publisher_metadata_other(metadata)
    within(".app-c-publisher-metadata__other") do
      assert_has_metadata(
        metadata, ".app-c-publisher-metadata__term", ".app-c-publisher-metadata__definition"
      )
    end
  end

  def assert_has_metadata(metadata, term_selector, definition_selector)
    metadata.each do |key, value|
      assert page.has_css?(term_selector, text: key),
        "Metadata term '#{key}' not found"

      value = { value => nil } if value.is_a?(String)

      value.each do |text, href|
        within(definition_selector, text: text) do
          if href
            assert page.has_link?(text, href: href), "Metadata link '#{text}' not found"
          else
            assert page.has_text?(text), "Metadata value '#{text}' not found"
          end
        end
      end
    end
  end

  def assert_has_publisher_metadata(options)
    within(".app-c-publisher-metadata") do
      assert_has_published_dates(options[:published], options[:last_updated], options[:history_link])
      assert_has_publisher_metadata_other(options[:metadata])
    end
  end

  def assert_has_important_metadata(metadata)
    within(".app-c-important-metadata") do
      assert_has_metadata(
        metadata, ".app-c-important-metadata__term", ".app-c-important-metadata__definition"
      )
    end
  end

  def assert_footer_has_published_dates(published = nil, last_updated = nil, history_link = false)
    assert_has_published_dates(published, last_updated, history_link, 1)
  end

  def setup_and_visit_content_item(name, parameter_string = '')
    @content_item = get_content_example(name).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust("#{item['base_path']}#{parameter_string}")
    end
  end

  def setup_and_visit_content_item_with_taxons(name, taxons)
    @content_item = get_content_example(name).tap do |item|
      item["links"]["taxons"] = taxons
      content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust(item['base_path'])
    end
  end

  def setup_and_visit_random_content_item(document_type: nil)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_type) do |payload|
      payload.merge('document_type' => document_type) unless document_type.nil?
      payload
    end

    content_id = content_item["content_id"]
    path = content_item["base_path"]

    stub_request(:get, %r{#{path}})
      .to_return(status: 200, body: content_item.to_json, headers: {})
    visit path

    assert_selector %{meta[name="govuk:content-id"][content="#{content_id}"}, visible: false
  end

  def get_content_example(name)
    get_content_example_by_schema_and_name(schema_type, name)
  end

  def get_content_example_by_schema_and_name(schema_type, name)
    GovukSchemas::Example.find(schema_type, example_name: name)
  end

  # Override this method if your test file doesn't match the convention
  def schema_type
    self.class.to_s.gsub('Test', '').underscore
  end

  def visit_with_cachebust(visit_uri)
    uri = Addressable::URI.parse(visit_uri)
    uri.query_values = uri.query_values.yield_self { |values| (values || {}).merge(cachebust: rand) }

    visit(uri)
  end
end
