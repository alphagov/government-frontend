require 'test_helper'

class ConsultationTest < ActionDispatch::IntegrationTest
  test "consultation" do
    setup_and_visit_content_item('open_consultation')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within '.app-c-publisher-metadata' do
      assert page.has_text?("Published 4 November 2016")
      assert page.has_text?("Last updated 7 November 2016")
      assert page.has_css?(".app-c-publisher-metadata__term", text: 'From')
      assert page.has_css?(".app-c-publisher-metadata__definition a[href=\"/government/organisations/department-for-education\"]", text: 'Department for Education')
    end

    within '.app-c-related-navigation' do
      assert page.has_css?('.app-c-related-navigation__section-link[href="/topic/higher-education/administration"]', text: 'Higher education administration')
    end

    within '.consultation-description' do
      assert_has_component_govspeak(@content_item["details"]["body"])
    end
  end

  test "consultation documents render" do
    setup_and_visit_content_item('closed_consultation')

    within '.consultation-documents' do
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
    assert page.has_text?("closes at 3pm on 16 December 2216")
  end

  test "unopened consultation" do
    setup_and_visit_content_item('unopened_consultation')

    assert page.has_text?("Consultation")

    # There’s no daylight savings after 2037
    # http://timezonesjl.readthedocs.io/en/stable/faq/#far-future-zoneddatetime-with-variabletimezone
    assert page.has_css?('.app-c-notice', text: "This consultation opens at 1pm on 5 October 2200")
    assert page.has_text?("It closes at 4pm on 31 October 2210")
  end

  test "closed consultation pending outcome" do
    setup_and_visit_content_item('closed_consultation')

    assert page.has_text?("Closed consultation")
    assert page.has_css?('.app-c-notice', text: "We are analysing your feedback")

    assert page.has_text?("ran from")
    assert page.has_text?("2pm on 5 September 2016 to 4pm on 31 October 2016")
  end

  test "consultation outcome" do
    setup_and_visit_content_item('consultation_outcome')

    assert page.has_text?("Consultation outcome")
    assert page.has_css?('.app-c-notice', text: "This consultation has concluded")
    assert page.has_css?('h2', text: "Original consultation")
    assert page.has_text?("ran from")
    assert page.has_text?("4pm on 20 April 2016 to 10:45pm on 13 July 2016")

    within '.consultation-outcome-detail' do
      assert_has_component_govspeak(@content_item["details"]["final_outcome_detail"])
    end
  end

  test "public feedback" do
    setup_and_visit_content_item('consultation_outcome_with_feedback')

    assert page.has_text?("Detail of feedback received")
    within '.consultation-feedback' do
      assert_has_component_govspeak(@content_item["details"]["public_feedback_detail"])
    end
  end

  test "consultation outcome documents render" do
    setup_and_visit_content_item('consultation_outcome')

    within '.consultation-outcome' do
      assert_has_component_govspeak(@content_item["details"]["final_outcome_documents"].join(''))
    end
  end

  test "public feedback documents render" do
    setup_and_visit_content_item('consultation_outcome_with_feedback')

    assert page.has_text?("Feedback received")
    within '.consultation-feedback-documents' do
      assert_has_component_govspeak(@content_item["details"]["public_feedback_documents"].join(''))
    end
  end

  test "consultation that only applies to a set of nations" do
    setup_and_visit_content_item('consultation_outcome_with_feedback')

    within '.app-c-important-metadata' do
      assert page.has_text?("Applies to: England")
    end
  end

  test "ways to respond renders" do
    setup_and_visit_content_item('open_consultation_with_participation')

    within '.consultation-ways-to-respond' do
      within_component_govspeak do |component_args|
        content = component_args.fetch("content")
        html = Nokogiri::HTML.parse(content)
        assert html.at_css(".call-to-action a[href='https://beisgovuk.citizenspace.com/ukgi/post-office-network-consultation']", text: 'Respond online')
        assert html.at_css("a[href='mailto:po.consultation@ukgi.gov.uk']", text: 'po.consultation@ukgi.gov.uk')
        assert html.at_css(".contact", text: '2016 Post Office Network Consultation')
        assert html.at_css("a[href='https://www.gov.uk/government/uploads/system/uploads/consultation_response_form_data/file/533/beis-16-36rf-post-office-network-consultation-response-form.docx']", text: 'response form')
      end
    end
  end

  test "ways to respond postal address is formatted with line breaks" do
    setup_and_visit_content_item('open_consultation_with_participation')

    within '.consultation-ways-to-respond' do
      within_component_govspeak do |component_args|
        content = component_args.fetch("content")
        html = Nokogiri::HTML.parse(content)
        assert html.at_css(".contact .content p", text: '2016 Post Office Network Consultation')
        assert html.at_css(".contact .content p br")
      end
    end
  end

  test "share urls" do
    setup_and_visit_content_item('open_consultation')
    assert page.has_css?("a", text: "Share on Facebook")
    assert page.has_css?("a", text: "Share on Twitter")
  end
end
