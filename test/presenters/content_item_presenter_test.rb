require 'test_helper'

class ContentItemPresenterTest < ActiveSupport::TestCase
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

  test "#related_navigation retrieves content for related navigation component" do
    expected = {
      related_items: [],
      collections: [],
      topics: [],
      policies: [],
      publishers: [],
      world_locations: [],
      other: [[], []]
    }

    assert_equal expected, ContentItemPresenter.new("schema_name" => "Schema name").related_navigation
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
end
