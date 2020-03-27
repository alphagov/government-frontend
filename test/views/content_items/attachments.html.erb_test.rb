require "test_helper"

class ContentItemsAttachmentsTest < ActionView::TestCase
  test "it shows pre-rendered attachments by default" do
    render(partial: "content_items/attachments",
           locals: { title: "Documents",
                     legacy_pre_rendered_documents: "some html" })

    assert_includes rendered, "gem-c-govspeak"
    assert_includes rendered, "some html"
  end

  test "can render attachments using their metadata" do
    @content_item = PublicationPresenter.new(
      "details" => {
        "attachments" => [{ "id" => "attachment_id",
                            "title" => "Some title",
                            "url" => "some/url" }],
      },
    )

    render(partial: "content_items/attachments",
           locals: { title: "Documents",
                     legacy_pre_rendered_documents: "",
                     attachments: %w(attachment_id) })

    assert_includes rendered, "gem-c-attachment"
    assert_includes rendered, "Some title"
  end

  test "it prioritises pre-rendered attachments" do
    render(partial: "content_items/attachments",
           locals: { title: "Documents",
                     legacy_pre_rendered_documents: "some html",
                     attachments: %w(attachment_id) })

    assert_includes rendered, "gem-c-govspeak"
    assert_includes rendered, "some html"
  end
end
