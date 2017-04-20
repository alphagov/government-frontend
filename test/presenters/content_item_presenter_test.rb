require 'test_helper'

class ContentItemPresenterTest < ActiveSupport::TestCase
  test "#title" do
    assert_equal "Title", ContentItemPresenter.new("title" => "Title").title
  end

  test "#description" do
    assert_equal "Description", ContentItemPresenter.new("description" => "Description").description
  end

  test "#format" do
    assert_equal "Format", ContentItemPresenter.new("schema_name" => "Format").format
  end

  test "#locale" do
    assert_equal "ar", ContentItemPresenter.new("locale" => "ar").locale
  end

  test "#document_type" do
    assert_equal "Type", ContentItemPresenter.new("document_type" => "Type").document_type
  end

  test "available_translations sorts languages by locale with English first" do
    translated = govuk_content_schema_example('case_study', 'translated')
    locales = ContentItemPresenter.new(translated).available_translations
    assert_equal %w(en ar es), locales.map { |t| t["locale"] }
  end

  test "part slug is nil when requesting a content item without parts" do
    example_without_parts = govuk_content_schema_example('case_study', 'translated')
    presented_example = ContentItemPresenter.new(example_without_parts, example_without_parts['base_path'])

    refute presented_example.requesting_a_part?
    assert presented_example.part_slug.nil?
  end

  test "part slug set to nil when content item has parts but base path requested" do
    example_with_parts = govuk_content_schema_example('travel_advice', 'full-country')
    presented_example = ContentItemPresenter.new(example_with_parts, example_with_parts['base_path'])

    refute presented_example.requesting_a_part?
    assert presented_example.part_slug.nil?
  end

  test "part slug set to last segment of requested content item path when content item has parts" do
    example_with_parts = govuk_content_schema_example('travel_advice', 'full-country')
    first_part = example_with_parts['details']['parts'].first
    first_part_path = "#{example_with_parts['base_path']}/#{first_part['slug']}"
    presented_example = ContentItemPresenter.new(example_with_parts, first_part_path)

    assert presented_example.requesting_a_part?
    assert_equal presented_example.part_slug, first_part['slug']
    assert presented_example.has_valid_part?
  end

  test "knows when an invalid part has been requested" do
    example_with_parts = govuk_content_schema_example('travel_advice', 'full-country')
    invalid_part_path = "#{example_with_parts['base_path']}/not-a-valid-part"
    presented_example = ContentItemPresenter.new(example_with_parts, invalid_part_path)

    assert presented_example.requesting_a_part?
    assert_equal presented_example.part_slug, 'not-a-valid-part'
    refute presented_example.has_valid_part?
  end
end
