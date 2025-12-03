require "test_helper"

class HmrcManualUpdatesTest < ActionDispatch::IntegrationTest
  test "page renders correctly" do
    setup_and_visit_manual_updates

    assert_has_component_title(I18n.t("manuals.updates_title", title: @content_item["title"]))

    within "#manual-title" do
      assert page.has_text?(I18n.t("manuals.hmrc_manual_type"))
    end
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
        from: { "HM Revenue & Customs": "/government/organisations/hm-revenue-customs" },
        first_published: "11 February 2015",
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

  test "renders back link" do
    setup_and_visit_manual_updates

    assert page.has_link?(I18n.t("manuals.breadcrumb_contents"), href: @content_item["base_path"])
  end

  test "renders change note updates" do
    setup_and_visit_manual_updates
    assert page.has_css?(".gem-c-accordion")

    accordion_sections = page.all(".govuk-accordion__section")
    assert_equal 2, accordion_sections.count

    within accordion_sections[0] do
      assert page.has_link?("Police authorities: summary of activities: liabilities T to Z",
                            href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb5390")
      assert page.has_text?("Updated content")
    end

    within accordion_sections[1] do
      assert page.has_link?("Police authorities: summary of activities: liabilities I to M",
                            href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb5350")
      assert page.has_text?("Updated content")
    end
  end

  def schema_type
    "hmrc_manual"
  end

  def setup_and_visit_manual_updates
    @content_item = get_content_example("vat-government-public-bodies").tap do |item|
      stub_content_store_has_item("#{item['base_path']}/updates", item.to_json)
      visit_with_cachebust("#{item['base_path']}/updates")
    end
  end
end
