require 'test_helper'

class ConsultationTest < ActionDispatch::IntegrationTest
  test "consultation" do
    setup_and_visit_content_item('open_consultation')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert_has_component_metadata_pair("first_published", "4 November 2016")
    assert_has_component_metadata_pair("last_updated", "7 November 2016")

    link1 = "<a href=\"/topic/higher-education/administration\">Higher education administration</a>"
    link2 = "<a href=\"/government/organisations/department-for-education\">Department for Education</a>"

    assert_has_component_metadata_pair("part_of", [link1])
    assert_has_component_document_footer_pair("part_of", [link1])
    assert_has_component_metadata_pair("from", [link2])
    assert_has_component_document_footer_pair("from", [link2])

    within '[aria-labelledby="description-title"]' do
      assert_has_component_govspeak(@content_item["details"]["body"])
    end
  end

  test "consultation documents render" do
    setup_and_visit_content_item('closed_consultation')

    within '[aria-labelledby="documents-title"]' do
      assert_has_component_govspeak(@content_item["details"]["documents"].join(''))
    end
  end

  test "link to external consultations" do
    setup_and_visit_content_item('open_consultation')

    assert page.has_css?("a[href=\"#{@content_item['details']['held_on_another_website_url']}\"]", text: "another website")
  end

  test "open consultation" do
    setup_and_visit_content_item('open_consultation')

    assert page.has_text?("Open consultation")
    assert page.has_text?("closes at 16 December 2216 4:00pm")
  end

  test "closed consultation pending outcome" do
    setup_and_visit_content_item('closed_consultation')

    assert page.has_text?("Closed consultation")
    assert page.has_css?('.consultation-notice', text: "We are analysing your feedback")

    assert page.has_text?("ran from")
    assert page.has_text?("5 September 2016 2:00pm to 31 October 2016 5:00pm")
  end

  test "consultation outcome" do
    setup_and_visit_content_item('consultation_outcome')

    assert page.has_text?("Consultation outcome")
    assert page.has_css?('.consultation-notice', text: "This consultation has concluded")
    assert page.has_css?('h2', text: "Original consultation")
    assert page.has_text?("ran from")
    assert page.has_text?("20 April 2016 4:00pm to 13 July 2016 10:45pm")

    within '[aria-labelledby="final-outcome-detail-title"]' do
      assert_has_component_govspeak(@content_item["details"]["final_outcome_detail"])
    end
  end

  test "consultation outcome documents render" do
    setup_and_visit_content_item('consultation_outcome')

    within '[aria-labelledby="final-outcome-documents-title"]' do
      assert_has_component_govspeak(@content_item["details"]["final_outcome_documents"].join(''))
    end
  end
end
