require "test_helper"

class AttachmentsTest < ActiveSupport::TestCase
  setup do
    @subject = Class.new {
      attr_accessor :content_item

      include ContentItem::Attachments
    }.new
  end

  test "#attachments returns an empty array when there are no attachments" do
    attachments = []
    @subject.content_item = { "details" => { "attachments" => attachments } }
    assert_equal [], @subject.attachments
  end

  test "#attachments returns attachments with type html by default" do
    attachments = [
      { "any-key" => "any-value" },
    ]
    @subject.content_item = { "details" => { "attachments" => attachments } }
    assert_equal [{ "any-key" => "any-value", "type" => "html" }], @subject.attachments
  end

  test "#attachments returns attachments with preview_urls based on url" do
    attachments = [{
      "preview_url" => "some-preview-url",
      "url" => "assets.test.gov.uk/media/123/some-filename.csv",
      "content_type" => "text/csv",
      "filename" => "some-filename.csv",
    }]
    @subject.content_item = { "details" => { "attachments" => attachments } }
    assert_equal [{ "preview_url" => "/csv-preview/123/some-filename.csv", "url" => "assets.test.gov.uk/media/123/some-filename.csv", "content_type" => "text/csv", "filename" => "some-filename.csv" }], @subject.attachments
  end

  test "#attachments returns attachments with preview_urls based on asset_manager_id and filename" do
    attachments = [{
      "preview_url" => "some-preview-url",
      "url" => "some-url",
      "assets" => [{ "asset_manager_id" => "some-attachment-data-id", "filename" => "some-filename" }],
      "filename" => "some-filename",
      "content_type" => "text/csv",
    }]
    @subject.content_item = { "details" => { "attachments" => attachments } }
    assert_equal [{
      "preview_url" => "/csv-preview/some-attachment-data-id/some-filename",
      "url" => "some-url",
      "assets" => [{ "asset_manager_id" => "some-attachment-data-id", "filename" => "some-filename" }],
      "filename" => "some-filename",
      "content_type" => "text/csv",
    }], @subject.attachments
  end
end
