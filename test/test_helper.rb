ENV['RAILS_ENV'] ||= 'test'
ENV['GOVUK_APP_DOMAIN'] = 'test.gov.uk'
ENV['GOVUK_ASSET_ROOT'] = 'http://static.test.gov.uk'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'slimmer/test_helpers/govuk_components'
require 'mocha/mini_test'
require 'faker'

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
  before_action :set_skip_slimmer_header

  def set_skip_slimmer_header
    response.headers[Slimmer::Headers::SKIP_HEADER] = "true" unless ENV["USE_SLIMMER"]
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  include Slimmer::TestHelpers::GovukComponents

  def setup
    stub_shared_component_locales
  end

  def assert_no_component(name)
    assert page.has_no_css?(shared_component_selector(name)), "Found a component named #{name}"
  end

  def assert_component_locals(name, locals)
    within shared_component_selector(name) do
      assert_equal locals, JSON.parse(page.text).deep_symbolize_keys
    end
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
    assert page.has_css?(".app-c-contents-list"), "Failed to find an element with a class of contents-list"
    within ".app-c-contents-list" do
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

  def assert_has_related_navigation_section_and_links(section_name, section_text, links)
    unless section_name == "related-nav-related_items"
      assert page.has_css?("##{section_name}", text: section_text),
        "Related navigation section '#{section_text}' not found"
    end

    within("nav[aria-labelledby='#{section_name}']") do
      links.each do |text, href|
        assert page.has_link?(text, href: href),
          "Related navigation link '#{text}' not found in '#{section_text}' links"
      end
    end
  end

  def assert_has_related_navigation(sections)
    within(".app-c-related-navigation") do
      assert page.has_css?(".app-c-related-navigation__main-heading", text: "Related content"),
        "Related navigation 'Related content' section not found"

      sections = [sections] unless sections.is_a?(Array)
      sections.each do |section|
        assert_has_related_navigation_section_and_links(
          section[:section_name], section[:section_text], section[:links]
        )
      end
    end
  end

  def assert_has_link_to_finder(text, path, params)
    href_value = "#{path}?#{params.to_query}"
    within(".app-c-related-navigation") do
      assert page.has_link?(text, href: href_value),
        "Finder link '#{text}' (href: #{href_value}) not found."
    end
  end

  def has_component_metadata(key, value)
    assert page.has_css? "meta[#{key}=\"#{value}\"]", visible: false
  end

  def setup_and_visit_content_item(name, parameter_string = '')
    @content_item = get_content_example(name).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit("#{item['base_path']}#{parameter_string}")
    end
  end

  def setup_and_visit_random_content_item(document_type: nil)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_type) do |payload|
      payload.merge('document_type' => document_type) unless document_type.nil?
      payload
    end
    path = content_item["base_path"]

    stub_request(:get, %r{#{path}})
      .to_return(status: 200, body: content_item.to_json, headers: {})
    visit path
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
end
