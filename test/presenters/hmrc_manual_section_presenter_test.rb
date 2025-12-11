require "presenter_test_helper"

class HmrcManualSectionPresenterTest
  class HmrcManualSectionPresenterTestCase < PresenterTestCase
    def schema_name
      "hmrc_manual_section"
    end
  end

  class PresentedHmrcManualSectionTest < HmrcManualSectionPresenterTestCase
    test "has metadata" do
      assert presented_manual_section.is_a?(ContentItem::Metadata)
    end

    test "has manual" do
      assert presented_manual_section.is_a?(ContentItem::Manual)
    end

    test "has manual section" do
      assert presented_manual_section.is_a?(ContentItem::ManualSection)
    end

    test "is linkable" do
      assert presented_manual_section.is_a?(ContentItem::Linkable)
    end

    test "is updatable" do
      assert presented_manual_section.is_a?(ContentItem::Updatable)
    end

    test "presents base_path" do
      manual = schema_item("vatgpb2000")["details"]["manual"]
      assert_equal manual["base_path"], presented_manual_section.base_path
    end

    test "presents manual title" do
      manual_base_path = schema_item("vatgpb2000")["details"]["manual"]["base_path"]
      manual = schema_item("vat-government-public-bodies", "hmrc_manual")
      stub_content_store_has_item(manual_base_path, manual.to_json)

      assert_equal manual["title"], presented_manual_section.title
    end

    test "presents basic breadcrumbs" do
      presented_section = presented_manual_section
      presented_section.view_context.stubs(:request)
        .returns(ActionDispatch::TestRequest.create("PATH_INFO" => schema_item("vatgpb2000")["base_path"]))

      expected_breadcrumbs = [
        {
          title: I18n.t("manuals.breadcrumb_contents"),
          url: presented_section.base_path,
        },
      ]
      assert_equal expected_breadcrumbs, presented_section.breadcrumbs
    end

    test "presents additional breadcrumbs if provided" do
      content_item = schema_item("vatgpb2000")
      additional_breadcrumbs = [
        {
          "section_id" => "VATGPB1100",
          "section_url" => "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1100",
        },
      ]
      content_item["details"] = content_item["details"].merge("breadcrumbs" => additional_breadcrumbs)

      presented_section = presented_manual_section(content_item)

      presented_section.view_context.stubs(:request)
        .returns(ActionDispatch::TestRequest.create("PATH_INFO" => content_item["base_path"]))

      expected_breadcrumbs = [
        {
          title: I18n.t("manuals.breadcrumb_contents"),
          url: presented_section.base_path,
        },
        {
          title: additional_breadcrumbs.first["section_id"],
          url: additional_breadcrumbs.first["url"],
        },
      ]
      assert_equal expected_breadcrumbs, presented_section.breadcrumbs
    end

    test "presents previous and next links" do
      manual_base_path = schema_item("vatgpb2000")["details"]["manual"]["base_path"]
      manual = schema_item("vat-government-public-bodies", "hmrc_manual")

      stub_content_store_has_item(manual_base_path, manual.to_json)

      expected_previous_and_next_links = {
        previous_page: {
          title: I18n.t("manuals.previous_page"),
          href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
        },
        next_page: {
          title: I18n.t("manuals.next_page"),
          href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb3000",
        },
      }

      assert_equal expected_previous_and_next_links, presented_manual_section.previous_and_next_links
    end

    test "presents only previous link if there is no next section" do
      manual_base_path = schema_item("vatgpb2000")["details"]["manual"]["base_path"]
      manual = schema_item("vat-government-public-bodies", "hmrc_manual")
      child_section_groups = manual["details"]["child_section_groups"]

      first_child_section = child_section_groups.first["child_sections"].first
      next_child_sections = child_section_groups.first["child_sections"] - [first_child_section]

      manual["details"]["child_section_groups"] = [{ "child_sections" => next_child_sections }]

      stub_content_store_has_item(manual_base_path, manual.to_json)

      expected_next_link = {
        next_page: {
          title: I18n.t("manuals.next_page"),
          href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb3000",
        },
      }

      assert_equal expected_next_link, presented_manual_section.previous_and_next_links
    end

    test "presents only next link if there is no previous section" do
      manual_base_path = schema_item("vatgpb2000")["details"]["manual"]["base_path"]
      manual = schema_item("vat-government-public-bodies", "hmrc_manual")
      child_section_groups = manual["details"]["child_section_groups"]

      first_two_child_section = child_section_groups.first["child_sections"][0..1]

      manual["details"]["child_section_groups"] = [{ "child_sections" => first_two_child_section }]

      stub_content_store_has_item(manual_base_path, manual.to_json)

      expected_previous_link = {
        previous_page: {
          title: I18n.t("manuals.previous_page"),
          href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
        },
      }

      assert_equal expected_previous_link, presented_manual_section.previous_and_next_links
    end

    test "presents no previous or next links if there is no previous or next section" do
      manual_base_path = schema_item("vatgpb2000")["details"]["manual"]["base_path"]
      manual = schema_item("vat-government-public-bodies", "hmrc_manual")

      manual["details"]["child_section_groups"] = []

      stub_content_store_has_item(manual_base_path, manual.to_json)

      expected_links = {}

      assert_equal expected_links, presented_manual_section.previous_and_next_links
    end

    def presented_manual_section(overrides = {})
      presented_item("vatgpb2000", overrides)
    end
  end
end
