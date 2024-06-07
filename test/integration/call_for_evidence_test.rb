require "test_helper"

class CallForEvidenceTest < ActionDispatch::IntegrationTest
  def setup
    super
    Timecop.freeze(Time.zone.local(2023))
  end

  def teardown
    super
    Timecop.return
  end

  general_overrides = {
    "details" => {
      "attachments" => [
        {
          "accessible" => false,
          "alternative_format_contact_email" => "publications@ofqual.gov.uk",
          "attachment_type" => "file",
          "command_paper_number" => "",
          "content_type" => "application/pdf",
          "file_size" => 803,
          "filename" => "Setting_grade_standards_part_2.pdf",
          "hoc_paper_number" => "",
          "id" => "01",
          "isbn" => "",
          "number_of_pages" => 33,
          "title" => "Setting the grade standards of new GCSEs in England – part 2",
          "unique_reference" => "Ofqual/16/5939",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "url" => "https://assets.publishing.service.gov.uk/media/5a7f7b63ed915d74e33f6b3d/Setting_grade_standards_part_2.pdf",
        },
        {
          "accessible" => false,
          "alternative_format_contact_email" => "publications@ofqual.gov.uk",
          "attachment_type" => "file",
          "command_paper_number" => "",
          "content_type" => "application/pdf",
          "file_size" => 365,
          "filename" => "Decisions_-_setting_GCSE_grade_standards_-_part_2.pdf",
          "hoc_paper_number" => "",
          "id" => "02",
          "isbn" => "",
          "number_of_pages" => 10,
          "title" => "Decisions on setting the grade standards of new GCSEs in England - part 2",
          "unique_reference" => "Ofqual/16/6102",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "url" => "https://assets.publishing.service.gov.uk/media/5a817d87ed915d74e62328cf/Decisions_-_setting_GCSE_grade_standards_-_part_2.pdf",
        },
        {
          "accessible" => false,
          "alternative_format_contact_email" => "publications@ofqual.gov.uk",
          "attachment_type" => "file",
          "command_paper_number" => "",
          "content_type" => "application/pdf",
          "file_size" => 646,
          "filename" => "Grading-consulation-Equalities-Impact-Assessment.pdf",
          "hoc_paper_number" => "",
          "id" => "03",
          "isbn" => "",
          "number_of_pages" => 5,
          "title" => "Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2",
          "unique_reference" => "Ofqual/16/6104",
          "unnumbered_command_paper" => false,
          "unnumbered_hoc_paper" => false,
          "url" => "https://assets.publishing.service.gov.uk/media/5a8014d6ed915d74e622c5af/Grading-consulation-Equalities-Impact-Assessment.pdf",
        },
        {
          "accessible" => false,
          "alternative_format_contact_email" => "publications@ofqual.gov.uk",
          "attachment_type" => "file",
          "content_type" => "application/pdf",
          "file_size" => 175,
          "filename" => "Grading-consultation-analysis-of-responses.pdf",
          "id" => "04",
          "number_of_pages" => 24,
          "title" => "Analysis of responses to our consultation on setting the grade standards of new GCSEs in England – part 2",
          "url" => "https://assets.publishing.service.gov.uk/media/5a819d85ed915d74e6233377/Grading-consultation-analysis-of-responses.pdf",
        },
      ],
      "outcome_attachments" => %w[01],
      "featured_attachments" => %w[02],
    },
  }

  test "call for evidence" do
    setup_and_visit_content_item("open_call_for_evidence", {
      "public_updated_at" => "2022-05-15T15:52:59.000+00:00",
      "updated_at" => "2022-05-24T22:45:10.294Z",
      "first_published_at" => "2022-04-11T13:01:57.000+00:00",
      "details" => {
        "first_public_at" => "2022-04-11T13:01:57.000+00:00",
        "closing_date" => "2022-05-28T13:01:57.000+00:00",
      },
    })

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_metadata({
      published: "11 April 2022",
      last_updated: "15 May 2022",
      from: {
        "Office for Health Improvement and Disparities": "/government/organisations/office-for-health-improvement-and-disparities",
      },
    })

    assert_footer_has_published_dates("Published 11 April 2022", "Last updated 15 May 2022")

    within ".call-for-evidence-description" do
      assert page.has_text?("The government is holding this call for evidence to identify opportunities to reduce the number of children (people aged under 18) accessing and using vape products, while ensuring they are still easily available as a quit aid for adult smokers.")
    end
  end

  test "renders document attachments" do
    setup_and_visit_content_item("closed_call_for_evidence", general_overrides)

    assert page.has_text?("Documents")
    within "#documents" do
      assert page.has_text?("Decisions on setting the grade standards of new GCSEs in England - part 2")
    end
  end

  test "renders featured document attachments" do
    setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments")

    assert page.has_text?("Documents")
    within "#documents" do
      assert page.has_text?("Setting the grade standards of new GCSEs in England – part 2")
    end
  end

  test "renders accessible format option when accessible is false and email is supplied" do
    overrides = {
      "details" => {
        "attachments" => [
          {
            "accessible" => false,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "attachment_type" => "file",
            "id" => "01",
            "title" => "Number of ex-regular service personnel now part of FR20",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
        ],
        "featured_attachments" => %w[01],
      },
    }
    setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments", overrides)
    within "#documents" do
      assert page.has_text?("Request an accessible format")
    end
  end

  test "doesn't render accessible format option when accessible is true and email is supplied" do
    overrides = {
      "details" => {
        "attachments" => [
          {
            "accessible" => true,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "attachment_type" => "file",
            "id" => "01",
            "title" => "Number of ex-regular service personnel now part of FR20",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
        ],
        "featured_attachments" => %w[01],
      },
    }
    setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments", overrides)
    within "#documents" do
      assert page.has_no_text?("Request an accessible format")
    end
  end

  test "doesn't render accessible format option when accessible is false and email is not supplied" do
    overrides = {
      "details" => {
        "attachments" => [
          {
            "accessible" => false,
            "attachment_type" => "file",
            "id" => "01",
            "title" => "Number of ex-regular service personnel now part of FR20",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
        ],
        "featured_attachments" => %w[01],
      },
    }
    setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments", overrides)
    within "#documents" do
      assert page.has_no_text?("Request an accessible format")
    end
  end

  test "tracks details elements in attachments correctly" do
    overrides = {
      "details" => {
        "attachments" => [
          {
            "accessible" => false,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "id" => "01",
            "title" => "Attachment 1 - should have details element",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
          {
            "accessible" => true,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "id" => "02",
            "title" => "Attachment 2",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
          {
            "accessible" => true,
            "alternative_format_contact_email" => nil,
            "id" => "03",
            "title" => "Attachment 3",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
          {
            "accessible" => false,
            "alternative_format_contact_email" => "ddc-modinternet@mod.gov.uk",
            "id" => "04",
            "title" => "Attachment 4 - should have details element",
            "url" => "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/315163/PUBLIC_1392629965.pdf",
            "content_type" => "application/pdf",
            "filename" => "PUBLIC_1392629965.pdf",
            "locale" => "en",
          },
        ],
        "outcome_attachments" => %w[01 02],
        "featured_attachments" => %w[03 04],
      },
    }
    setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments", overrides)
    attachments = page.find_all(".gem-c-attachment")
    assert_equal attachments.length, overrides["details"]["attachments"].length

    attachments.each do |attachment|
      next unless attachment.has_css?(".govuk-details__summary")

      details = attachment.find(".govuk-details__summary")["data-ga4-event"]
      actual_tracking = JSON.parse(details)
      assert_equal actual_tracking["index_section_count"], 2
    end
  end

  test "link to external calls for evidence" do
    setup_and_visit_content_item("open_call_for_evidence")

    assert page.has_css?("a[href=\"#{@content_item['details']['held_on_another_website_url']}\"]", text: "another website")
  end

  test "open call for evidence" do
    setup_and_visit_content_item("open_call_for_evidence", {
      "details" => {
        "opening_date" => "2022-12-02T13:00:00.000+00:00",
        "closing_date" => "2023-02-02T13:00:00.000+00:00",
      },
    })
    assert page.has_text?("Open call for evidence")
    assert page.has_text?(:all, "closes at 1pm on 2 February 2023")
  end

  test "unopened call for evidence" do
    setup_and_visit_content_item("unopened_call_for_evidence", {
      "details" => {
        "closing_date" => "2023-02-01T13:00:00.000+00:00",
        "opening_date" => "2023-01-02T13:00:00.000+00:00",
      },
    })

    assert page.has_text?("Call for evidence")

    assert page.has_css?(".gem-c-notice", text: "This call for evidence opens at 1pm on 2 January 2023")
    assert page.has_text?(:all, "It closes at 1pm on 1 February 2023")
  end

  test "closed call for evidence pending outcome" do
    setup_and_visit_content_item("closed_call_for_evidence")

    assert page.has_text?("Closed call for evidence")

    assert page.has_text?("ran from")
    assert page.has_text?("2pm on 29 September 2022 to 5pm on 27 October 2022")
  end

  test "call for evidence outcome" do
    setup_and_visit_content_item("call_for_evidence_outcome", {
      "details" => {
        "closing_date" => "2022-02-01T13:00:00.000+00:00",
        "opening_date" => "2022-01-01T13:00:00.000+00:00",
      },
    })
    assert page.has_text?("Call for evidence outcome")
    assert page.has_css?(".gem-c-notice", text: "This call for evidence has closed")
    assert page.has_css?("h2", text: "Original call for evidence")
    assert page.has_text?("ran from")
    assert page.has_text?("1pm on 1 January 2022 to 1pm on 1 February 2022")

    within ".call-for-evidence-outcome-detail" do
      assert page.has_text?(@content_item["details"]["outcome_detail"])
    end
  end

  test "renders call for evidence outcome attachments" do
    setup_and_visit_content_item("call_for_evidence_outcome", general_overrides)

    assert page.has_text?("This call for evidence has closed")
    assert page.has_text?("Read the full outcome")
    within "#read-the-full-outcome" do
      assert page.has_text?("Setting the grade standards of new GCSEs in England – part 2")
    end
  end

  test "renders featured call for evidence outcome attachments" do
    setup_and_visit_content_item("call_for_evidence_outcome_with_featured_attachments")

    assert page.has_text?("Read the full outcome")
    within "#read-the-full-outcome" do
      assert page.has_text?("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
    end
  end

  test "ways to respond renders" do
    setup_and_visit_content_item("open_call_for_evidence_with_participation")

    within ".call-for-evidence-ways-to-respond" do
      assert page.has_css?(".call-to-action a[href='https://beisgovuk.citizenspace.com/ukgi/post-office-network-call-for-evidence']", text: "Respond online")
      assert page.has_css?("a[href='mailto:po.call-for-evidence@ukgi.gov.uk']", text: "po.call-for-evidence@ukgi.gov.uk")
      assert page.has_css?(".contact", text: "2016 Post Office Network Consultation")
      assert page.has_css?("a[href='https://www.gov.uk/government/uploads/system/uploads/call_for_evidence_response_form_data/file/533/beis-16-36rf-post-office-network-call-for-evidence-response-form.docx']", text: "response form")
    end
  end

  test "ways to respond postal address is formatted with line breaks" do
    setup_and_visit_content_item("open_call_for_evidence_with_participation")

    within ".call-for-evidence-ways-to-respond" do
      assert page.has_css?(".contact .content p", text: "2016 Post Office Network Consultation")
    end
  end

  test "share urls" do
    setup_and_visit_content_item("open_call_for_evidence")
    assert page.has_css?("a", text: "Facebook")
    assert page.has_css?("a", text: "Twitter")
  end

  test "renders with the single page notification button" do
    setup_and_visit_content_item("open_call_for_evidence")
    assert page.has_css?(".gem-c-single-page-notification-button")
  end

  test "does not render the single page notification button on exempt pages" do
    setup_and_visit_notification_exempt_page("open_call_for_evidence")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
