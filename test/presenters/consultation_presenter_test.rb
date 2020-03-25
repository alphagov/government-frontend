require "presenter_test_helper"

class ConsultationPresenterTest
  class PresentedConsultation < PresenterTestCase
    def schema_name
      "consultation"
    end

    test "presents the schema name" do
      assert_equal schema_item("open_consultation")["document_type"], presented_item("open_consultation").document_type
      assert_equal schema_item("open_consultation")["details"]["body"], presented_item("open_consultation").body
    end

    test "presents friendly dates for opening and closing dates, including time" do
      schema = schema_item("open_consultation")
      schema["details"]["opening_date"] = "2016-11-04T10:00:00+00:00"
      schema["details"]["closing_date"] = "2216-12-16T16:00:00+00:00"
      presented = presented_item("open_consultation", schema)

      assert_equal "10am on 4 November 2016", presented.opening_date
      assert_equal "4pm on 16 December 2216", presented.closing_date
    end

    test "presents closing dates at 12am as 11:59pm on the day before" do
      schema = schema_item("open_consultation")
      schema["details"]["opening_date"] = "2016-11-03T00:01:00+00:00"
      schema["details"]["closing_date"] = "2016-11-04T00:00:00+00:00"
      presented = presented_item("open_consultation", schema)

      assert_equal "12:01am on 3 November 2016", presented.opening_date
      assert_equal "11:59pm on 3 November 2016", presented.closing_date
    end

    test "presents opening dates at 12am as the date without a time" do
      schema = schema_item("open_consultation")
      schema["details"]["opening_date"] = "2016-11-03T00:00:00+00:00"
      schema["details"]["closing_date"] = "2016-11-04T00:00:00+00:00"
      presented = presented_item("open_consultation", schema)

      assert_equal "3 November 2016", presented.opening_date
    end

    test "presents 12pm as midday" do
      schema = schema_item("open_consultation")
      schema["details"]["opening_date"] = "2016-11-04T12:00:00+00:00"
      presented = presented_item("open_consultation", schema)

      assert_equal "midday on 4 November 2016", presented.opening_date
    end

    test "presents open and closed states" do
      assert presented_item("open_consultation").open?
      assert_not presented_item("open_consultation").closed?

      assert presented_item("closed_consultation").closed?
      assert_not presented_item("closed_consultation").open?

      assert presented_item("consultation_outcome").closed?
      assert_not presented_item("consultation_outcome").open?

      assert_not presented_item("unopened_consultation").closed?
      assert_not presented_item("unopened_consultation").open?
    end

    test "presents consultation documents" do
      presented = presented_item("closed_consultation")
      schema = schema_item("closed_consultation")

      assert_equal schema["details"]["documents"].join(""), presented.documents
    end

    test "presents final outcome documents" do
      presented = presented_item("consultation_outcome")
      schema = schema_item("consultation_outcome")

      assert_equal schema["details"]["final_outcome_documents"].join(""), presented.final_outcome_documents
    end

    test "presents public feedback documents" do
      presented = presented_item("consultation_outcome_with_feedback")
      schema = schema_item("consultation_outcome_with_feedback")

      assert_equal schema["details"]["public_feedback_documents"].join(""), presented.public_feedback_documents
    end

    test "presents URL for consultations held on another website" do
      assert presented_item("open_consultation").held_on_another_website?
      assert_not presented_item("closed_consultation").held_on_another_website?

      assert_equal "https://consult.education.gov.uk/part-time-maintenance-loans/post-graduate-doctoral-loans/", presented_item("open_consultation").held_on_another_website_url
      assert_not presented_item("closed_consultation").held_on_another_website_url
    end

    test "content can apply only to a set of nations" do
      example = schema_item("consultation_outcome_with_feedback")
      presented = presented_item("consultation_outcome_with_feedback")

      assert example["details"].include?("national_applicability")
      assert_equal presented.applies_to, "England"
    end

    test "presents ways to respond" do
      example_ways_to_respond = schema_item("open_consultation_with_participation")["details"]["ways_to_respond"]
      presented = presented_item("open_consultation_with_participation")

      assert presented.ways_to_respond?
      assert_equal example_ways_to_respond["email"], presented.email
      assert_equal example_ways_to_respond["link_url"], presented.respond_online_url
      assert_equal example_ways_to_respond["postal_address"], presented.postal_address
    end

    test "presents a response form when included with email or postal address" do
      example_ways_to_respond = schema_item("open_consultation_with_participation")["details"]["ways_to_respond"]
      presented = presented_item("open_consultation_with_participation")

      assert presented.response_form?
      assert_equal example_ways_to_respond["attachment_url"], presented.attachment_url

      example_without_email = schema_item("open_consultation_with_participation")
      example_without_email["details"]["ways_to_respond"].delete("email")
      example_without_email["details"]["ways_to_respond"].delete("postal_address")
      presented_without_email = presented_item("open_consultation_with_participation", example_without_email)

      assert_not presented_without_email.response_form?
    end

    test "does not show ways to respond when consultation is closed" do
      example = schema_item("closed_consultation")
      example["details"]["ways_to_respond"] = { "email" => "email@email.com" }
      presented = presented_item("closed_consultation", example)

      assert_not presented.ways_to_respond?
    end

    test "does not show ways to respond when only an attachment url is provided" do
      example = schema_item("open_consultation_with_participation")
      example["details"]["ways_to_respond"].delete("email")
      example["details"]["ways_to_respond"].delete("postal_address")
      example["details"]["ways_to_respond"].delete("link_url")
      presented = presented_item("open_consultation_with_participation", example)

      assert_not presented.ways_to_respond?
    end

    test "presents share urls with encoded url and title" do
      assert_equal "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fwww.test.gov.uk%2Fgovernment%2Fconsultations%2Fpostgraduate-doctoral-loans", presented_item("open_consultation").share_links[0][:href]
      assert_equal "https://twitter.com/share?url=https%3A%2F%2Fwww.test.gov.uk%2Fgovernment%2Fconsultations%2Fpostgraduate-doctoral-loans&text=Postgraduate%20doctoral%20loans", presented_item("open_consultation").share_links[1][:href]
    end
  end
end
