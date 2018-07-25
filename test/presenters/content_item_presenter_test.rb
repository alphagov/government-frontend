require 'test_helper'

class ContentItemPresenterTest < ActiveSupport::TestCase
  include RummagerHelpers

  test "#title" do
    assert_equal "Title", ContentItemPresenter.new("title" => "Title").title
  end

  test "#description" do
    assert_equal "Description", ContentItemPresenter.new("description" => "Description").description
  end

  test "#schema_name" do
    assert_equal "Schema name", ContentItemPresenter.new("schema_name" => "Schema name").schema_name
  end

  test "#locale" do
    assert_equal "ar", ContentItemPresenter.new("locale" => "ar").locale
  end

  test "#document_type" do
    assert_equal "Type", ContentItemPresenter.new("document_type" => "Type").document_type
  end

  test "#canonical_url without a part" do
    assert_equal "https://www.test.gov.uk/test", ContentItemPresenter.new("base_path" => "/test").canonical_url
  end

  test "#canonical_url with a part" do
    example_with_parts = govuk_content_schema_example('travel_advice', 'full-country')
    request_path = example_with_parts['base_path'] + '/safety-and-security'
    presented_example = TravelAdvicePresenter.new(example_with_parts, request_path)

    assert_equal "https://www.test.gov.uk/foreign-travel-advice/albania/safety-and-security", presented_example.canonical_url
  end

  test "available_translations sorts languages by locale with English first" do
    translated = govuk_content_schema_example('case_study', 'translated')
    locales = ContentItemPresenter.new(translated).available_translations
    assert_equal %w(en ar es), (locales.map { |t| t[:locale] })
  end

  test "available_translations returns native locale names using native_language_name_for" do
    translated = govuk_content_schema_example('case_study', 'translated')
    locales = ContentItemPresenter.new(translated).available_translations

    assert_equal %w(English العربية Español), (locales.map { |t| t[:text] })
  end

  test "part slug is nil when requesting a content item without parts" do
    example_without_parts = govuk_content_schema_example('case_study', 'translated')
    presented_example = ContentItemPresenter.new(example_without_parts, example_without_parts['base_path'])

    refute presented_example.requesting_a_part?
    assert presented_example.part_slug.nil?
  end

  test "has_guidance_and_regulation_links? is false if there are no taxons" do
    example_without_links = govuk_content_schema_example('guide', 'no-part-guide')
    assert_nil example_without_links["links"]["taxons"]
    presenter = ContentItemPresenter.new(example_without_links)
    assert_not presenter.has_guidance_and_regulation_links?
  end

  test "has_guidance_and_regulation_links? is false if there are some taxons but no results" do
    example_with_links = govuk_content_schema_example('guide', 'guide')
    stub_most_popular_content(example_with_links, 0, "guidance_and_regulation")
    presenter = ContentItemPresenter.new(example_with_links)
    assert_not presenter.has_guidance_and_regulation_links?
  end

  test "has_guidance_and_regulation_links? is true if there are some taxons" do
    example_with_links = govuk_content_schema_example('guide', 'guide')
    stub_most_popular_content(example_with_links, 1, "guidance_and_regulation")
    presenter = ContentItemPresenter.new(example_with_links)
    assert presenter.has_guidance_and_regulation_links?
  end

  test "guidance_and_regulation_links_content returns empty array if there are no contents" do
    example_without_links = govuk_content_schema_example('guide', 'no-part-guide')
    assert_nil example_without_links["links"]["taxons"]
    presenter = ContentItemPresenter.new(example_without_links)
    assert_equal [], presenter.guidance_and_regulation_links_content
  end

  test "guidance_and_regulation_links_content returne empty array if there are some taxons but no results" do
    example_with_links = govuk_content_schema_example('guide', 'guide')
    stub_most_popular_content(example_with_links, 0, "guidance_and_regulation")
    presenter = ContentItemPresenter.new(example_with_links)
    assert_equal [], presenter.guidance_and_regulation_links_content
  end

  test "guidance_and_regulation_links_content is an array with that number of entries if there are some taxons" do
    example_with_links = govuk_content_schema_example('guide', 'guide')
    stub_most_popular_content(example_with_links, 2, "guidance_and_regulation")
    presenter = ContentItemPresenter.new(example_with_links)
    assert_equal 2, presenter.guidance_and_regulation_links_content.count
    assert_equal [{ link: { text: "Content item 0", path: "/content-item-0" }, metadata: { document_type: "guidance_and_regulation" } },
                  { link: { text: "Content item 1", path: "/content-item-1" }, metadata: { document_type: "guidance_and_regulation" } }], presenter.guidance_and_regulation_links_content
  end
end
