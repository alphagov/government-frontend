require "test_helper"

class HmrcManualSectionTest < ActionDispatch::IntegrationTest
  test "page renders correctly" do
    setup_and_visit_manual_section

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within ".manual-type" do
      assert page.has_text?(I18n.t("manuals.hmrc_manual_type"))
    end
  end

  test "partial has no content id" do
    content_ids = page.all('[id="content"]')

    assert_equal 0, content_ids.count
  end

  test "renders metadata" do
    setup_and_visit_manual_section

    assert_has_metadata(
      {
        from: { "HM Revenue & Customs": "/government/organisations/hm-revenue-customs" },
        first_published: "11 February 2015",
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

  test "renders manual specific breadcrumbs" do
    setup_and_visit_manual_section

    manual_specific_breadcrumbs = page.all(".gem-c-breadcrumbs")[1]
    within manual_specific_breadcrumbs do
      assert page.has_text?(I18n.t("manuals.breadcrumb_contents"))
    end
  end

  test "renders section group" do
    setup_and_visit_manual_section

    within ".subsection-collection .section-list" do
      first_group_children = page.all("li")

      assert_equal 6, first_group_children.count

      within first_group_children[0] do
        assert page.has_link?(
          "Introduction: scope of the manual",
          href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb2100",
        )
        assert page.has_text?("VATGPB2100")
      end
    end
  end

  test "renders previous and next navigation" do
    setup_and_visit_manual_section

    within ".govuk-pagination" do
      assert page.has_link?(
        I18n.t("manuals.previous_page"),
        href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
      )

      assert page.has_link?(
        I18n.t("manuals.next_page"),
        href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb3000",
      )
    end
  end

  def setup_and_visit_manual_section(content_item = get_content_example("vatgpb2000"))
    @manual = get_content_example_by_schema_and_name("hmrc_manual", "vat-government-public-bodies")
    @content_item = content_item
    manual_base_path = @content_item["details"]["manual"]["base_path"]

    stub_content_store_has_item(manual_base_path, @manual.to_json)

    stub_content_store_has_item(@content_item["base_path"], @content_item.to_json)
    visit_with_cachebust((@content_item["base_path"]).to_s)
  end
end
