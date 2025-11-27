require "test_helper"

class HmrcManualTest < ActionDispatch::IntegrationTest
  test "page renders correctly" do
    setup_and_visit_content_item("vat-government-public-bodies")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within "#manual-title" do
      assert page.has_text?(I18n.t("manuals.hmrc_manual_type"))
    end
  end

  test "partial has 1 content id" do
    setup_and_visit_content_item("vat-government-public-bodies")
    content_ids = page.all('[id="content"]')

    assert_equal 1, content_ids.count
  end

  test "renders metadata" do
    setup_and_visit_content_item("vat-government-public-bodies")

    assert_has_metadata(
      {
        from: { "HM Revenue & Customs": "/government/organisations/hm-revenue-customs" },
        first_published: "11 February 2015",
        other: {
          I18n.t("manuals.see_all_updates") => "#{@content_item['base_path']}/updates",
        },
      },
      extra_metadata_classes: ".gem-c-metadata--inverse",
    )
  end

  test "renders search box" do
    setup_and_visit_content_item("vat-government-public-bodies")

    within ".gem-c-search" do
      assert page.has_text?(I18n.t("manuals.search_this_manual"))
    end
  end

  test "renders 'Summary' title if description field is present" do
    setup_and_visit_content_item("vat-government-public-bodies")

    assert page.has_text?(I18n.t("manuals.summary_title"))
  end

  test "renders contents title heading" do
    setup_and_visit_content_item("vat-government-public-bodies")

    assert page.has_selector?("h2", text: I18n.t("manuals.contents_title"))
  end

  test "renders sections title heading" do
    setup_and_visit_content_item("vat-government-public-bodies")

    assert page.has_selector?("h3", text: "Historic updates")
  end

  test "renders section groups" do
    setup_and_visit_content_item("vat-government-public-bodies")

    child_section_groups = page.all(".subsection-collection .section-list")

    assert_equal 2, child_section_groups.count

    within child_section_groups[0] do
      first_group_children = page.all("li")

      assert_equal 9, first_group_children.count

      within first_group_children[0] do
        assert page.has_link?(
          "Introduction: contents",
          href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
        )
        assert page.has_text?("VATGPB1000")
      end
    end

    within child_section_groups[1] do
      section_group_children = page.all("li")

      assert_equal 1, section_group_children.count

      within section_group_children[0] do
        assert page.has_link?(
          "VAT Government and public bodies: update index",
          href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpbupdate001",
        )
        assert page.has_text?("VATGPBUPDATE001")
      end
    end
  end

  test "does not render section groups with no sections inside" do
    content_item_override = {
      "details" => {
        "child_section_groups" => [
          {
            title: "Some section group title 1",
            child_sections: [],
          },
          {
            title: "Some section group title 2",
            child_sections: [
              {
                "section_id" => "VATGPB1000",
                "title" => "Introduction: contents",
                "description" => "",
                "base_path" => "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
              },
            ],
          },
        ],
      },
    }

    setup_and_visit_content_item("vat-government-public-bodies", content_item_override)
    assert page.has_no_text?("Some section group title 1")
    assert page.has_text?("Some section group title 2")
  end
end
