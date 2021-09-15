require "test_helper"

class ConsultationTest < ActionDispatch::IntegrationTest
  test "consultation" do
    setup_and_visit_content_item("open_consultation")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_metadata(
      published: "4 November 2016",
      last_updated: "7 November 2016",
      from: { "Department for Education": "/government/organisations/department-for-education" },
    )

    assert_footer_has_published_dates("Published 4 November 2016", "Last updated 7 November 2016")

    within ".consultation-description" do
      assert page.has_text?("We are seeking external views on a postgraduate doctoral loan.")
    end
  end

  test "renders document attachments (as-is and directly)" do
    setup_and_visit_content_item("closed_consultation")

    assert page.has_text?("Documents")
    within "#documents" do
      assert page.has_text?("Museums Review Terms of Reference")
    end

    setup_and_visit_content_item("consultation_outcome_with_featured_attachments")

    assert page.has_text?("Documents")
    within "#documents" do
      assert page.has_text?("Setting the grade standards of new GCSEs in England – part 2")
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
    setup_and_visit_content_item("consultation_outcome")

    assert page.has_text?("Download the full outcome")
    within "#download-the-full-outcome" do
      assert page.has_text?("Employee Share Schemes: NIC elections - consulation response")
    end

    setup_and_visit_content_item("consultation_outcome_with_featured_attachments")

    assert page.has_text?("Download the full outcome")
    within "#download-the-full-outcome" do
      assert page.has_text?("Equalities impact assessment: setting the grade standards of new GCSEs in England – part 2")
    end
  end

  test "renders public feedback attachments (as-is and directly)" do
    setup_and_visit_content_item("consultation_outcome_with_feedback")

    assert page.has_text?("Feedback received")
    within "#feedback-received" do
      assert page.has_text?("Analysis of responses to our consultation on setting the grade standards of new GCSEs in England – part 2")
    end

    setup_and_visit_content_item("consultation_outcome_with_featured_attachments")

    assert page.has_text?("Feedback received")
    within "#feedback-received" do
      assert page.has_text?("Analysis of responses to our consultation on setting the grade standards of new GCSEs in England – part 2")
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
end
