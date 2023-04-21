require "test_helper"

class ManualTest < ActionDispatch::IntegrationTest
  test "page renders correctly" do
    setup_and_visit_content_item("content-design")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
  end

  test "partial has 1 content id" do
    setup_and_visit_content_item("content-design")
    content_ids = page.all('[id="content"]')

    assert_equal 1, content_ids.count
  end

  test "renders metadata" do
    setup_and_visit_content_item("content-design")

    assert_has_metadata(
      {
        from: { "Government Digital Service": "/government/organisations/government-digital-service" },
        first_published: "27 April 2015",
        other: {
          I18n.t("manuals.see_all_updates") => "#{@content_item['base_path']}/updates",
        },
      },
      extra_metadata_classes: ".gem-c-metadata--inverse",
    )
  end

  test "renders search box" do
    setup_and_visit_content_item("content-design")

    within ".gem-c-search" do
      assert page.has_text?(I18n.t("manuals.search_this_manual"))
    end
  end

  test "renders manual specific breadcrumbs" do
    setup_and_visit_content_item("content-design")

    manual_specific_breadcrumbs = page.all(".gem-c-breadcrumbs")[1]
    within manual_specific_breadcrumbs do
      assert page.has_text?(I18n.t("manuals.breadcrumb_contents"))
    end
  end

  test "renders body govspeak" do
    setup_and_visit_content_item("content-design")

    within ".gem-c-govspeak" do
      assert page.has_text?("If you like yoga")
    end
  end

  test "renders sections" do
    setup_and_visit_content_item("content-design")

    within ".gem-c-document-list" do
      list_items = page.all(".gem-c-document-list__item")

      assert_equal 3, list_items.count

      within list_items[0] do
        assert page.has_link?("What is content design?", href: "/guidance/content-design/what-is-content-design")
        assert page.has_text?("Introduction to content design.")
      end
    end
  end
end
