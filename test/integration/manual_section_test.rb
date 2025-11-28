require "test_helper"

class ManualSectionTest < ActionDispatch::IntegrationTest
  test "page renders correctly" do
    setup_and_visit_manual_section

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
  end

  test "partial has 1 content id" do
    setup_and_visit_manual_section
    content_ids = page.all('[id="content"]')

    assert_equal 1, content_ids.count
  end

  test "renders contextual breadcrumbs from parent manuals tagging" do
    setup_and_visit_manual_section
    manual_taxonomy_topic = @manual["links"]["taxons"].first

    within ".gem-c-contextual-breadcrumbs" do
      assert page.has_link?(manual_taxonomy_topic["title"], href: manual_taxonomy_topic["base_path"])
    end
  end

  test "renders metadata" do
    setup_and_visit_manual_section

    assert_has_metadata(
      {
        from: { "Government Digital Service": "/government/organisations/government-digital-service" },
        first_published: "27 April 2015",
        other: {
          I18n.t("manuals.see_all_updates") => "#{@manual['base_path']}/updates",
        },
      },
      extra_metadata_classes: ".gem-c-metadata--inverse",
    )
  end

  test "renders search box" do
    setup_and_visit_manual_section

    within ".gem-c-search" do
      assert page.has_text?(I18n.t("manuals.search_this_manual"))
    end
  end

  test "renders document heading" do
    setup_and_visit_manual_section

    within "#manual-title .govuk-heading-l" do
      assert page.has_text?(@manual["title"])
    end
  end

  test "renders back link" do
    setup_and_visit_manual_section

    assert page.has_link?(I18n.t("manuals.breadcrumb_contents"), href: @manual["base_path"])
  end

  test "renders sections accordion" do
    setup_and_visit_manual_section

    assert page.has_css?(".gem-c-accordion")

    accordion_sections = page.all(".govuk-accordion__section")
    assert_equal 7, accordion_sections.count

    within accordion_sections[0] do
      assert page.has_text?("Designing content, not creating copy")
    end
  end

  test "renders expanded sections if visually expanded " do
    content_item = get_content_example("what-is-content-design")
    content_item["details"]["visually_expanded"] = true

    setup_and_visit_manual_section(content_item)

    within "#manuals-frontend" do
      assert_equal 7, page.all("h2").count
      first_section_heading = page.all("h2").first

      assert_equal "Designing content, not creating copy", first_section_heading.text
    end
  end

  test "renders content lists if published by MOJ" do
    content_item = get_content_example("what-is-content-design")
    organisations = { "organisations" => [{ "content_id" => "dcc907d6-433c-42df-9ffb-d9c68be5dc4d" }] }
    content_item["links"] = content_item["links"].merge(organisations)

    setup_and_visit_manual_section(content_item)

    assert_has_contents_list([
      { text: "Designing content, not creating copy", id: "designing-content-not-creating-copy" },
      { text: "Content design always starts with user needs", id: "content-design-always-starts-with-user-needs" },
    ])
  end

  def setup_and_visit_manual_section(content_item = get_content_example("what-is-content-design"))
    @manual = get_content_example_by_schema_and_name("manual", "content-design")
    @content_item = content_item
    manual_base_path = @content_item["links"]["manual"].first["base_path"]

    stub_content_store_has_item(manual_base_path, @manual.to_json)

    stub_content_store_has_item(@content_item["base_path"], @content_item.to_json)
    visit_with_cachebust(@content_item["base_path"].to_s)
  end
end
