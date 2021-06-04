require "presenter_test_helper"

class ContentItemPresenterTest < PresenterTestCase
  test "#title" do
    presenter = create_presenter(ContentItemPresenter, content_item: { "title" => "Title" })
    assert_equal "Title", presenter.title
  end

  test "#description" do
    presenter = create_presenter(ContentItemPresenter, content_item: { "description" => "Description" })
    assert_equal "Description", presenter.description
  end

  test "#schema_name" do
    presenter = create_presenter(ContentItemPresenter, content_item: { "schema_name" => "Schema name" })
    assert_equal "Schema name", presenter.schema_name
  end

  test "#locale" do
    presenter = create_presenter(ContentItemPresenter, content_item: { "locale" => "ar" })
    assert_equal "ar", presenter.locale
  end

  test "#document_type" do
    presenter = create_presenter(ContentItemPresenter, content_item: { "document_type" => "Type" })
    assert_equal "Type", presenter.document_type
  end

  test "#canonical_url without a part" do
    presenter = create_presenter(ContentItemPresenter, content_item: { "base_path" => "/test" })
    assert_equal "https://www.test.gov.uk/test", presenter.canonical_url
  end

  test "#canonical_url with a part" do
    example_with_parts = govuk_content_schema_example("travel_advice", "full-country")
    request_path = "#{example_with_parts['base_path']}/safety-and-security"
    presenter = create_presenter(
      TravelAdvicePresenter,
      content_item: example_with_parts,
      requested_path: request_path,
    )

    assert_equal "https://www.test.gov.uk/foreign-travel-advice/albania/safety-and-security", presenter.canonical_url
  end

  test "available_translations sorts languages by locale with English first" do
    translated = govuk_content_schema_example("case_study", "translated")
    presenter = create_presenter(ContentItemPresenter, content_item: translated)
    assert_equal %w[en ar es], (presenter.available_translations.map { |t| t[:locale] })
  end

  test "available_translations returns native locale names using native_language_name_for" do
    translated = govuk_content_schema_example("case_study", "translated")
    presenter = create_presenter(ContentItemPresenter, content_item: translated)
    assert_equal %w[English العربية Español], (presenter.available_translations.map { |t| t[:text] })
  end

  test "part slug is nil when requesting a content item without parts" do
    example_without_parts = govuk_content_schema_example("case_study", "translated")
    presenter = create_presenter(
      TravelAdvicePresenter,
      content_item: example_without_parts,
      requested_path: example_without_parts["base_path"],
    )

    assert_not presenter.requesting_a_part?
    assert presenter.part_slug.nil?
  end
end
