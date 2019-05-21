require 'test_helper'

class ContentItemPresenterTest < ActiveSupport::TestCase
  def presenter_with_content_secondary_to_one_step_by_step
    one_step_by_step = govuk_content_schema_example('publication', 'best-practice-guidance')
    ContentItemPresenter.new(one_step_by_step, one_step_by_step['base_path'])
  end

  def presenter_with_content_secondary_to_multiple_step_by_steps
    multiple_step_by_step = govuk_content_schema_example('publication', 'best-practice-regulation')
    ContentItemPresenter.new(multiple_step_by_step, multiple_step_by_step['base_path'])
  end

  def presenter_with_content_secondary_to_no_step_by_steps
    no_step_by_step = govuk_content_schema_example('publication', 'best-practice-research')
    ContentItemPresenter.new(no_step_by_step, no_step_by_step['base_path'])
  end

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

  test "is_secondary_to_one_step_nav? returns true if tagged as secondary to a single step_by_step" do
    assert presenter_with_content_secondary_to_one_step_by_step.is_secondary_to_one_step_nav?
  end

  test "is_secondary_to_one_step_nav? returns false if not tagged to a step_by_step" do
    refute presenter_with_content_secondary_to_no_step_by_steps.is_secondary_to_one_step_nav?
  end

  test "is_secondary_to_one_step_nav? returns false if tagged to more than one step_by_step" do
    refute presenter_with_content_secondary_to_multiple_step_by_steps.is_secondary_to_one_step_nav?
  end

  test "is_secondary_to_multiple_step_navs? returns true if tagged to more than one step_by_step" do
    assert presenter_with_content_secondary_to_multiple_step_by_steps.is_secondary_to_multiple_step_navs?
  end

  test "is_secondary_to_multiple_step_navs? returns false if not tagged to a step_by_step" do
    refute presenter_with_content_secondary_to_one_step_by_step.is_secondary_to_multiple_step_navs?
  end

  test "is_secondary_to_multiple_step_navs? returns false if tagged as secondary to a single step_by_step" do
    refute presenter_with_content_secondary_to_one_step_by_step.is_secondary_to_multiple_step_navs?
  end

  test "multiple_step_nav_links contains correct href and text values" do
    expected_result = [
                        { href: "/learn-to-drive-a-car", text: "Learn to drive a car: step by step" },
                        { href: "/get-a-divorce", text: "Get a divorce: step by step" }
                      ]
    assert_equal expected_result, presenter_with_content_secondary_to_multiple_step_by_steps.multiple_step_nav_links
  end

  test "step_by_step_nav is correct for content secondary to a single step by step" do
    step_by_step_nav = presenter_with_content_secondary_to_one_step_by_step.step_by_step_nav
    assert step_by_step_nav.keys.include?(:steps)
    assert_equal %i(title contents), step_by_step_nav[:steps].first.keys
  end

  test "single_step_by_step_header is correct for content secondary to a single step by step" do
    single_step_by_step_header = presenter_with_content_secondary_to_one_step_by_step.single_step_by_step_header
    expected_header = { title: 'Learn to drive a car: step by step' }
    assert_equal expected_header, single_step_by_step_header
  end
end
