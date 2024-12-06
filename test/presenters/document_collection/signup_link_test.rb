require "test_helper"

class DocumentCollectionSignupLinkTest < ActiveSupport::TestCase
  class DummyContentItem
    include DocumentCollection::SignupLink
    attr_accessor :content_item

    def initialize
      @content_item = {}
      @content_item["links"] = {}
    end
  end

  test "taxonomy_topic_email_override_base_path returns nil if field is empty" do
    item = DummyContentItem.new
    assert_nil item.taxonomy_topic_email_override_base_path
  end

  test "show_email_signup_link? returns false if there is no linked taxonomy_topic_email_override" do
    item = DummyContentItem.new
    assert_equal false, item.show_email_signup_link?
  end

  test "show_email_signup_link? returns true if there is a linked taxonomy_topic_email_override" do
    item = DummyContentItem.new
    item.content_item["links"]["taxonomy_topic_email_override"] = [
      {
        "base_path" => "/a-taxonomy-topic",
      },
    ]
    assert item.show_email_signup_link?
  end
end
