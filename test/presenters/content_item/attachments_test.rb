require "test_helper"

class AttachmentsTest < ActiveSupport::TestCase
  setup do
    @subject = (Class.new do
      attr_accessor :content_item

      include ContentItem::Attachments
    end).new
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
    attachments = [
      { "preview_url" => "some-preview-url", "url" => "some-url" },
    ]
    @subject.content_item = { "details" => { "attachments" => attachments } }
    assert_equal [{ "preview_url" => "some-url/preview", "url" => "some-url", "type" => "html" }], @subject.attachments
  end

  test "#attachments returns attachments with preview_urls based on attachment_data_id and filename" do
    attachments = [{
      "preview_url" => "some-preview-url",
      "url" => "some-url",
      "attachment_data_id" => "some-attachment-data-id",
      "filename" => "some-filename",
    }]
    @subject.content_item = { "details" => { "attachments" => attachments } }
    assert_equal [{
      "preview_url" => "/csv-preview/some-attachment-data-id/some-filename",
      "url" => "some-url",
      "attachment_data_id" => "some-attachment-data-id",
      "filename" => "some-filename",
      "type" => "html",
    }], @subject.attachments
  end

  test "#attachments raises an error if preview_url is present, but both url and attachment_data_id / filename are absent" do
    attachments = [{
      "preview_url" => "some-preview-url",
    }]
    @subject.content_item = { "details" => { "attachments" => attachments } }
    assert_raises(NoMatchingPatternError) { @subject.attachments }
  end
end
