require "test_helper"

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

  test "#canonical_url without a part" do
    assert_equal "https://www.test.gov.uk/test", ContentItemPresenter.new("base_path" => "/test").canonical_url
  end

  test "#canonical_url with a part" do
    example_with_parts = govuk_content_schema_example("travel_advice", "full-country")
    request_path = example_with_parts["base_path"] + "/safety-and-security"
    presented_example = TravelAdvicePresenter.new(example_with_parts, request_path)

    assert_equal "https://www.test.gov.uk/foreign-travel-advice/albania/safety-and-security", presented_example.canonical_url
  end

  test "available_translations sorts languages by locale with English first" do
    translated = govuk_content_schema_example("case_study", "translated")
    locales = ContentItemPresenter.new(translated).available_translations
    assert_equal %w(en ar es), (locales.map { |t| t[:locale] })
  end

  test "available_translations returns native locale names using native_language_name_for" do
    translated = govuk_content_schema_example("case_study", "translated")
    locales = ContentItemPresenter.new(translated).available_translations

    assert_equal %w(English العربية Español), (locales.map { |t| t[:text] })
  end

  test "part slug is nil when requesting a content item without parts" do
    example_without_parts = govuk_content_schema_example("case_study", "translated")
    presented_example = ContentItemPresenter.new(example_without_parts, example_without_parts["base_path"])

    assert_not presented_example.requesting_a_part?
    assert presented_example.part_slug.nil?
  end
end
