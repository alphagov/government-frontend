require "test_helper"

class ConsultationTest < ActionDispatch::IntegrationTest
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
      "final_outcome_attachments" => %w[01],
      "public_feedback_attachments" => %w[02],
      "featured_attachments" => %w[03],
    },
  }

  test "consultation" do
    setup_and_visit_content_item("open_consultation")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_metadata({
      published: "4 November 2016",
      last_updated: "7 November 2016",
      from: {
        "Department for Education": "/government/organisations/department-for-education",
      },
    })

    assert_footer_has_published_dates("Published 4 November 2016", "Last updated 7 November 2016")

    within ".consultation-description" do
      assert page.has_text?("We are seeking external views on a postgraduate doctoral loan.")
    end
  end

  test "renders document attachments (as-is and directly)" do
    setup_and_visit_content_item("closed_consultation", general_overrides)

    assert page.has_text?("Documents")
    within "#documents" do
      assert page.has_text?("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
    end

    setup_and_visit_content_item("consultation_outcome_with_featured_attachments", general_overrides)

    assert page.has_text?("Documents")
    within "#documents" do
      assert page.has_text?("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
    end
  end

  test "link to external consultations" do
    setup_and_visit_content_item("open_consultation")

    assert page.has_css?("a[href=\"#{@content_item['details']['held_on_another_website_url']}\"]", text: "another website")
  end

  test "open consultation" do
    setup_and_visit_content_item("open_consultation")

    assert page.has_text?("Open consultation")
    assert page.has_text?(:all, "closes at 3pm on 16 December 2216")
  end

  test "unopened consultation" do
    setup_and_visit_content_item("unopened_consultation")

    assert page.has_text?("Consultation")

    # There's no daylight savings after 2037
    # http://timezonesjl.readthedocs.io/en/stable/faq/#far-future-zoneddatetime-with-variabletimezone
    assert page.has_css?(".gem-c-notice", text: "This consultation opens at 1pm on 5 October 2200")
    assert page.has_text?(:all, "It closes at 4pm on 31 October 2210")
  end

  test "closed consultation pending outcome" do
    setup_and_visit_content_item("closed_consultation")

    assert page.has_text?("Closed consultation")
    assert page.has_css?(".gem-c-notice", text: "We are analysing your feedback")

    assert page.has_text?("ran from")
    assert page.has_text?("2pm on 5 September 2016 to 4pm on 31 October 2016")
  end

  test "consultation outcome" do
    setup_and_visit_content_item("consultation_outcome")

    assert page.has_text?("Consultation outcome")
    assert page.has_css?(".gem-c-notice", text: "This consultation has concluded")
    assert page.has_css?("h2", text: "Original consultation")
    assert page.has_text?("ran from")
    assert page.has_text?("4pm on 20 April 2016 to 10:45pm on 13 July 2016")

    within ".consultation-outcome-detail" do
      assert page.has_text?(@content_item["details"]["final_outcome_detail"])
    end
  end

  test "public feedback" do
    setup_and_visit_content_item("consultation_outcome_with_feedback")

    assert page.has_text?("Detail of feedback received")
    within ".consultation-feedback" do
      assert page.has_text?("The majority of respondents agreed or strongly agreed with our proposals, which were:")
    end
  end

  test "renders consultation outcome attachments (as-is and directly)" do
    setup_and_visit_content_item("consultation_outcome", general_overrides)

    assert page.has_text?("Read the full outcome")
    within "#read-the-full-outcome" do
      assert page.has_text?("Setting the grade standards of new GCSEs in England – part 2")
    end

    setup_and_visit_content_item("consultation_outcome_with_featured_attachments")

    assert page.has_text?("Read the full outcome")
    within "#read-the-full-outcome" do
      assert page.has_text?("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
    end
  end

  test "shows pre-rendered public feedback documents" do
    setup_and_visit_content_item("consultation_outcome_with_feedback", general_overrides)

    assert page.has_text?("Feedback received")
    within "#feedback-received" do
      assert page.has_text?("Decisions on setting the grade standards of new GCSEs in England - part 2")
    end
  end

  test "renders public feedback document attachments" do
    setup_and_visit_content_item("consultation_outcome_with_featured_attachments")

    assert page.has_text?("Feedback received")
    within "#feedback-received" do
      assert page.has_text?("Analysis of responses to our consultation on setting the grade standards of new GCSEs in England – part 2")
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
    setup_and_visit_content_item("consultation_outcome_with_featured_attachments", overrides)
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
    setup_and_visit_content_item("consultation_outcome_with_featured_attachments", overrides)
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
    setup_and_visit_content_item("consultation_outcome_with_featured_attachments", overrides)
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
        "final_outcome_attachments" => %w[01],
        "public_feedback_attachments" => %w[02 03],
        "featured_attachments" => %w[04],
      },
    }
    setup_and_visit_content_item("consultation_outcome_with_featured_attachments", overrides)
    attachments = page.find_all(".gem-c-attachment")
    assert_equal attachments.length, overrides["details"]["attachments"].length

    attachments.each do |attachment|
      next unless attachment.has_css?(".govuk-details__summary")

      details = attachment.find("details")["data-ga4-event"]
      actual_tracking = JSON.parse(details)
      assert_equal actual_tracking["index_section_count"], 2
    end
  end

  test "consultation that only applies to a set of nations" do
    setup_and_visit_content_item("consultation_outcome_with_feedback")
    assert_has_devolved_nations_component("Applies to England")
  end

  test "ways to respond renders" do
    setup_and_visit_content_item("open_consultation_with_participation")

    within ".consultation-ways-to-respond" do
      assert page.has_css?(".call-to-action a[href='https://beisgovuk.citizenspace.com/ukgi/post-office-network-consultation']", text: "Respond online")
      assert page.has_css?("a[href='mailto:po.consultation@ukgi.gov.uk']", text: "po.consultation@ukgi.gov.uk")
      assert page.has_css?(".contact", text: "2016 Post Office Network Consultation")
      assert page.has_css?("a[href='https://www.gov.uk/government/uploads/system/uploads/consultation_response_form_data/file/533/beis-16-36rf-post-office-network-consultation-response-form.docx']", text: "response form")
    end
  end

  test "ways to respond postal address is formatted with line breaks" do
    setup_and_visit_content_item("open_consultation_with_participation")

    within ".consultation-ways-to-respond" do
      assert page.has_css?(".contact .content p", text: "2016 Post Office Network Consultation")
    end
  end

  test "share urls" do
    setup_and_visit_content_item("open_consultation")
    assert page.has_css?("a", text: "Facebook")
    assert page.has_css?("a", text: "Twitter")
  end

  test "renders with the single page notification button on English language pages" do
    setup_and_visit_content_item("open_consultation")
    assert page.has_css?(".gem-c-single-page-notification-button")

    buttons = page.find_all("button[data-ga4-link]")

    expected_tracking_top = single_page_notification_button_ga4_tracking(1, "Top")
    actual_tracking_top = JSON.parse(buttons.first["data-ga4-link"])
    assert_equal expected_tracking_top, actual_tracking_top

    expected_tracking_bottom = single_page_notification_button_ga4_tracking(2, "Footer")
    actual_tracking_bottom = JSON.parse(buttons.last["data-ga4-link"])
    assert_equal expected_tracking_bottom, actual_tracking_bottom
  end

  test "does not render the single page notification button on foreign language pages" do
    setup_and_visit_content_item("open_consultation", "locale" => "cy")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
