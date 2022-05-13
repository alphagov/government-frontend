require "presenter_test_helper"

class ManualSectionPresenterTest
  class ManualSectionPresenterTestCase < PresenterTestCase
    def schema_name
      "manual_section"
    end
  end

  class PresentedManualSectionTest < ManualSectionPresenterTestCase
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
      manuals = schema_item("what-is-content-design")["links"]["manual"]
      assert_equal manuals.first["base_path"], presented_manual_section.base_path
    end

    test "strips content under h2 and presents intro" do
      assert_equal "", presented_manual_section.intro
    end

    test "presents intro with valid elements" do
      body = "<p>Paragraph to be kept</p><h2>This is a heading to be stripped<\h2><p>This is a following paragraph to be stripped</p>"
      manual_section = schema_item("what-is-content-design")
      manual_section["details"] = manual_section["details"].merge("body" => body)

      assert_equal "<p>Paragraph to be kept</p>", present_example(manual_section).intro.to_html
    end

    test "returns empty string if intro only contains h2 headings" do
      manual_section = schema_item("what-is-content-design")

      assert_equal "", present_example(manual_section).intro
    end

    test "returns false if section isn't visually expanded" do
      assert_equal false, presented_manual_section.visually_expanded?
    end

    test "returns true if section is visually expanded" do
      manual_section = schema_item("what-is-content-design")
      manual_section["details"] = manual_section["details"].merge("visually_expanded" => true)

      assert_equal true, present_example(manual_section).visually_expanded?
    end

    test "returns main object ready to be consumed by the accordion component" do
      first_section_heading = {
        heading: {
          text: "Designing content, not creating copy",
          id: "designing-content-not-creating-copy",
        },
      }
      first_section_content_sample = "<p>Good content design allows people to do"

      assert_equal 7, presented_manual_section.main.count
      assert_equal first_section_heading[:heading], presented_manual_section.main.first[:heading]
      assert_match first_section_content_sample, presented_manual_section.main.first[:content]
    end

    def presented_manual_section(overrides = {})
      presented_item("what-is-content-design", overrides)
    end
  end
end
