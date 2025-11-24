ENV["RAILS_ENV"] ||= "test"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"
ENV["GOVUK_ASSET_ROOT"] = "http://static.test.gov.uk"

# Must go at top of file
require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch
  minimum_coverage 95
end

require "i18n/coverage"
require "i18n/coverage/printers/file_printer"
I18n::Coverage.config.printer = I18n::Coverage::Printers::FilePrinter
I18n::Coverage.start

require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "capybara/rails"
require "mocha/minitest"
require "capybara/minitest"
require "faker"
require "minitest/reporters"

Dir[Rails.root.join("test/support/*.rb")].sort.each { |f| require f }

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new(print_failure_summary: true)

GovukTest.configure

Capybara.default_driver = :headless_chrome

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :active_support
end

WebMock.disable_net_connect!(allow_localhost: true)

class ActiveSupport::TestCase
  include GovukContentSchemaExamples
end

# NOTE: This is so that slimmer is skipped, preventing network requests for
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
  include ActionView::Helpers::DateHelper
  include I18n

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def assert_has_component_metadata_pair(label, value)
    assert page.has_content?(label)
    assert page.has_content?(value)
  end

  def assert_has_component_title(title)
    assert page.has_css?("h1", text: title)
  end

  def assert_has_component_organisation_logo
    assert page.has_css?(".gem-c-organisation-logo")
  end

  def assert_has_contents_list(contents)
    assert page.has_css?(".gem-c-contents-list"), "Failed to find an element with a class of contents-list"
    within ".gem-c-contents-list" do
      contents.each do |heading|
        selector = "a[href=\"##{heading[:id]}\"]"
        text = heading.fetch(:text)
        assert page.has_css?(selector), "Failed to find an element matching: #{selector}"
        assert page.has_css?(selector, text:), "Failed to find an element matching #{selector} with text: #{text}"
      end
    end
  end

  def assert_has_published_dates(first_published = nil, last_updated = nil, history_link: false)
    text = []
    text << first_published if first_published
    text << last_updated if last_updated
    last_published_dates_element = all(".gem-c-published-dates").last

    within last_published_dates_element do
      assert page.has_text?(text.join("\n")), "Published dates #{text.join("\n")} not found"
      if history_link
        assert page.has_link?("see all updates", href: "#history"), "Updates link not found"
      end
    end
  end

  def assert_has_publisher_metadata_other(any_args)
    assert_has_metadata(any_args)
  end

  def assert_has_metadata(any_args, context_selector: nil, extra_metadata_classes: nil)
    within "#{context_selector} .gem-c-metadata#{extra_metadata_classes}" do
      any_args.each_value do |value|
        value = { value => nil } if value.is_a?(String)
        value.each do |text, href|
          if href
            assert page.has_link?(text, href:), "Metadata text '#{text} with link of #{href}' not found"
          else
            assert page.has_text?(text), "Metadata value '#{text}' not found"
          end
        end
      end
    end
  end

  def assert_has_metadata_local(metadata, term_selector, definition_selector)
    metadata.each do |key, value|
      assert page.has_css?(term_selector, text: key),
             "Metadata term '#{key}' not found"
      value = { value => nil } if value.is_a?(String)
      value.each do |text, href|
        within(definition_selector, text:) do
          if href
            assert page.has_link?(text, href:), "Metadata link '#{text}' not found"
          else
            assert page.has_text?(text), "Metadata value '#{text}' not found"
          end
        end
      end
    end
  end

  def assert_has_important_metadata(metadata)
    within(".important-metadata .gem-c-metadata") do
      assert_has_metadata_local(
        metadata, ".gem-c-metadata__term", ".gem-c-metadata__definition"
      )
    end
  end

  def assert_has_devolved_nations_component(text, nations = nil)
    within(".gem-c-devolved-nations") do
      assert page.has_text?(text)
      nations&.each do |nation|
        assert page.has_link?(nation[:text], href: nation[:alternative_url])
      end
    end
  end

  def assert_footer_has_published_dates(first_published = nil, last_updated = nil, history_link: false)
    assert_has_published_dates(first_published, last_updated, history_link:)
  end

  def setup_and_visit_content_item(name, overrides = {}, parameter_string = "")
    @content_item = get_content_example(name).tap do |item|
      content_item = item.deep_merge(overrides)
      setup_and_visit_content_item_by_example(content_item, parameter_string)
    end
  end

  def setup_and_visit_content_item_with_params(name, parameter_string = "")
    @content_item = get_content_example(name)
    setup_and_visit_content_item_by_example(@content_item, parameter_string)
  end

  def setup_and_visit_content_item_by_example(content_item, parameter_string = "")
    stub_content_store_has_item(content_item["base_path"], content_item.to_json)
    visit_with_cachebust("#{content_item['base_path']}#{parameter_string}")
  end

  def setup_and_visit_content_item_with_taxonomy_topic_email_override(name)
    @content_item = get_content_example(name).tap do |item|
      item["links"]["taxonomy_topic_email_override"] = [{
        "base_path": "/testpath",
      }]
      stub_content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust(item["base_path"])
    end
  end

  def setup_and_visit_a_page_with_specific_base_path(name, base_path, content_id = nil)
    @content_item = get_content_example(name).tap do |item|
      item["content_id"] = content_id if content_id.present?
      item["base_path"] = base_path
      stub_content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust(item["base_path"])
    end
  end

  def setup_and_visit_random_content_item(document_type: nil)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_type) do |payload|
      payload.merge!("document_type" => document_type) if document_type
      payload
    end

    content_id = content_item["content_id"]
    path = content_item["base_path"]

    stub_request(:get, %r{#{path}})
      .to_return(status: 200, body: content_item.to_json, headers: {})

    visit path

    assert_selector %(meta[name="govuk:content-id"][content="#{content_id}"]), visible: false
  end

  def get_content_example(name)
    get_content_example_by_schema_and_name(schema_type, name)
  end

  def get_content_example_by_schema_and_name(schema_type, name)
    GovukSchemas::Example.find(schema_type, example_name: name)
  end

  # Override this method if your test file doesn't match the convention
  def schema_type
    self.class.to_s.gsub("Test", "").underscore
  end

  def visit_with_cachebust(visit_uri)
    uri = Addressable::URI.parse(visit_uri)
    uri.query_values = uri.query_values.yield_self { |values| (values || {}).merge(cachebust: rand) }

    visit(uri)
  end

  def assert_has_structured_data(page, schema_name)
    assert find_structured_data(page, schema_name).present?
  end

  def find_structured_data(page, schema_name)
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    schemas.detect { |schema| schema["@type"] == schema_name }
  end

  def single_page_notification_button_ga4_tracking(index_link, section)
    {
      "event_name" => "navigation",
      "type" => "subscribe",
      "index_link" => index_link,
      "index_total" => 2,
      "section" => section,
      "url" => "/email/subscriptions/single-page/new",
    }
  end
end
