require "test_helper"

class ContentItemsAttachmentsTest < ActionView::TestCase
  def test_data
    {
      accessible: true,
      attachment_type: "file",
      command_paper_number: "",
      content_type: "application/pdf",
      file_size: "1570742",
      filename: "aa1-interactive-claim-form.pdf",
      hoc_paper_number: "",
      id: "7556005",
      isbn: "",
      locale: "en",
      number_of_pages: 30,
      title: "Attendance Allowance claim form",
      unique_reference: "AA1",
      unnumbered_command_paper: false,
      unnumbered_hoc_paper: false,
      url: "https://assets.publishing.service.gov.uk/media/64132b818fa8f55576ac627e/aa1-interactive-claim-form.pdf",
    }
  end

  test "it can display pre-rendered attachments" do
    render(
      partial: "content_items/attachments",
      locals: {
        title: "Documents",
        attachments_html: "some html",
      },
    )

    assert_includes rendered, "gem-c-govspeak"
    assert_includes rendered, "some html"
  end

  test "it can render an array of attachments" do
    render(
      partial: "content_items/attachments",
      locals: {
        title: "Documents",
        attachments: [
          test_data,
        ],
      },
    )

    assert_includes rendered, "gem-c-attachment"
    assert_includes rendered, "govuk-link", text: "Attendance Allowance claim form"
    assert_not_includes rendered, "gem-c-details"
  end

  test "can render attachments using their metadata" do
    @content_item = PublicationPresenter.new(
      { "details" => { "attachments" => [{ "id" => "attachment_id",
                                           "title" => "Some title",
                                           "url" => "some/url" }] } },
      "/publication",
      ApplicationController.new.view_context,
    )

    render(
      partial: "content_items/attachments",
      locals: { title: "Documents",
                attachments: "",
                featured_attachments: %w[attachment_id] },
    )

    assert_includes rendered, "gem-c-attachment"
    assert_includes rendered, "Some title"
  end

  test "it prioritises pre-rendered attachments" do
    render(
      partial: "content_items/attachments",
      locals: {
        title: "Documents",
        attachments: [
          test_data,
        ],
        featured_attachments: %w[attachment_id],
      },
    )

    assert_includes rendered, "gem-c-attachment"
    assert_includes rendered, "govuk-link", text: "Attendance Allowance claim form"
  end

  test "it shows extra information for inaccessible attachments" do
    data = test_data
    data[:accessible] = false
    data[:alternative_format_contact_email] = "accessible.formats@dwp.gov.uk"
    render(
      partial: "content_items/attachments",
      locals: {
        title: "Documents",
        attachments: [
          data,
        ],
      },
    )

    assert_includes rendered, "gem-c-attachment"
    assert_includes rendered, "govuk-link", text: "Attendance Allowance claim form"
    assert_includes rendered, "gem-c-attachment__metadata", text: "This file may not be suitable for users of assistive technology."
    assert_includes rendered, "govuk-details__summary-text", text: "Request an accessible format."
  end
end
