require "test_helper"

class ContentItemAttachmentsTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::Attachments
    attr_reader :content_item, :attachment_id, :content_id

    def initialize
      @attachment_id = 1234
      @content_id = SecureRandom.uuid
      @content_item = {
        "content_id" => content_id,
        "details" => {
          "attachments" => [
            {
              "id" => attachment_id,
              "title" => "Some title",
              "url" => "some/url",
              "alternative_format_contact_email" => "alternative.formats@education.gov.uk",
            },
          ],
        },
      }
    end
  end

  test "returns attachment details for found attachment" do
    dummy = DummyContentItem.new

    details = dummy.attachment_details(dummy.attachment_id)

    assert_equal details, {
      "title" => "Some title",
      "url" => "some/url",
      "alternative_format_contact_email" => "alternative.formats@education.gov.uk",
      "attachment_id" => dummy.attachment_id,
      "owning_document_content_id" => dummy.content_id,
    }
  end

  test "returns nil if no attachment found" do
    attachment_id = 4321
    dummy = DummyContentItem.new

    details = dummy.attachment_details(attachment_id)

    assert_equal details, nil
  end
end
