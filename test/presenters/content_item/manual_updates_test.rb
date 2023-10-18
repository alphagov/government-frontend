require "test_helper"

class ContentItemManualUpdatesTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::ManualUpdates
    attr_reader :content_item, :view_context, :manual_page_title, :details

    def initialize
      @view_context = ApplicationController.new.view_context
      @content_item = {
        "base_path" => "/a/base/path",
        "public_updated_at" => "2022-03-23T08:30:20.000+00:00",
        "details" => {
          "change_notes" => [
            {
              "base_path" => "/guidance/content-design/what-is-content-design",
              "title" => "What is content design?",
              "change_note" => "New section added.",
              "published_at" => "2014-10-06T19:49:25Z",
            },
            {
              "base_path" => "/guidance/content-design/content-policy",
              "title" => "Content policy",
              "change_note" => "New section added.",
              "published_at" => "2014-10-06T22:49:25Z",
            },
            {
              "base_path" => "/guidance/content-design/user-needs",
              "title" => "User needs",
              "change_note" => "New section added.",
              "published_at" => "2014-08-06T10:49:25Z",
            },
            {
              "base_path" => "/guidance/content-design/random-section",
              "title" => "Random section",
              "change_note" => "New section added.",
              "published_at" => "2013-09-06T23:49:25Z",
            },
          ],
        },
        "links" => {
          "organisations" => [
            { "content_id" => SecureRandom.uuid, "title" => "blah", "base_path" => "/blah" },
          ],
        },
      }
      @manual_page_title = "Super Title - Guidance"
      @details = content_item["details"]
    end
  end

  test "returns page title" do
    item = DummyContentItem.new

    assert_equal "Updates - Super Title - Guidance", item.page_title
  end

  test "returns description" do
    item = DummyContentItem.new

    assert_equal I18n.t("manuals.updates_description", title: item.manual_page_title),
                 item.description
  end

  test "returns grouped change notes" do
    item = DummyContentItem.new
    first_note, second_note, third_note, fourth_note = item.details["change_notes"]
    expected_grouped_changes_notes = [
      [
        2014,
        [
          [
            "6 October 2014 <span class=\"govuk-visually-hidden\">#{I18n.t('manuals.updates_amendments')}</span>",
            {
              (first_note["base_path"]).to_s => [first_note],
              (second_note["base_path"]).to_s => [second_note],
            },
          ],
          [
            "6 August 2014 <span class=\"govuk-visually-hidden\">#{I18n.t('manuals.updates_amendments')}</span>",
            {
              (third_note["base_path"]).to_s => [third_note],
            },
          ],
        ],
      ],
      [
        2013,
        [
          [
            "7 September 2013 <span class=\"govuk-visually-hidden\">#{I18n.t('manuals.updates_amendments')}</span>",
            {
              (fourth_note["base_path"]).to_s => [fourth_note],
            },
          ],
        ],
      ],
    ]

    assert_equal expected_grouped_changes_notes, item.presented_change_notes
  end
end
