require "test_helper"

class ManualUpdatesTest < ActionDispatch::IntegrationTest
  test "page renders correctly" do
    setup_and_visit_manual_updates

    assert_has_component_title(I18n.t("manuals.updates_title", title: @content_item["title"]))
  end

  test "partial has 1 content id" do
    setup_and_visit_manual_updates
    content_ids = page.all('[id="content"]')

    assert_equal 1, content_ids.count
  end

  test "renders metadata" do
    setup_and_visit_manual_updates

    assert_has_metadata(
      {
        from: { "Government Digital Service": "/government/organisations/government-digital-service" },
        first_published: "27 April 2015",
        other: {},
      },
      extra_metadata_classes: ".gem-c-metadata--inverse",
    )
  end

  test "renders search box" do
    setup_and_visit_manual_updates

    within ".gem-c-search" do
      assert page.has_text?(I18n.t("manuals.search_this_manual"))
    end
  end

  test "renders manual specific breadcrumbs" do
    setup_and_visit_manual_updates

    manual_specific_breadcrumbs = page.all(".gem-c-breadcrumbs")[1]
    within manual_specific_breadcrumbs do
      assert page.has_link?(I18n.t("manuals.breadcrumb_contents"), href: @content_item["base_path"])
    end
  end

  test "renders change note updates" do
    setup_and_visit_manual_updates
    assert page.has_css?(".gem-c-accordion")

    accordion_sections = page.all(".govuk-accordion__section")
    assert_equal 2, accordion_sections.count

    within accordion_sections[0] do
      assert page.has_link?("What is content design?", href: "/guidance/content-design/what-is-content-design")
      assert page.has_text?("New section added.")
    end

    within accordion_sections[1] do
      assert page.has_link?("Content types", href: "/guidance/content-design/content-types")
      assert page.has_text?("New section added.")
    end
  end

  def schema_type
    "manual"
  end

  def setup_and_visit_manual_updates
    @content_item = get_content_example("content-design").tap do |item|
      stub_content_store_has_item("#{item['base_path']}/updates", item.to_json)
      visit_with_cachebust("#{item['base_path']}/updates")
    end
  end
end
