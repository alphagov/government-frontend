require "presenter_test_helper"

class ConsultationPresenterTest
  class PresentedConsultation < PresenterTestCase
    def schema_name
      "consultation"
    end

    test_documents = [
      {
        "id" => "01",
      },
      {
        "id" => "02",
      },
      {
        "id" => "03",
      },
    ]

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
      schema = schema_item("closed_consultation")
      schema["details"]["attachments"] = test_documents
      schema["details"]["featured_attachments"] = %w[01 02]
      presented = presented_item("closed_consultation", schema)
      assert_equal presented.documents_attachments_for_components.length, 2
      assert_equal presented.documents_attachments_for_components[0]["id"], "01"
      assert_equal presented.documents_attachments_for_components[1]["id"], "02"
    end

    test "presents final outcome documents" do
      schema = schema_item("consultation_outcome")
      schema["details"]["attachments"] = test_documents
      schema["details"]["final_outcome_attachments"] = %w[02 03]
      presented = presented_item("consultation_outcome", schema)
      assert_equal presented.final_outcome_attachments_for_components.length, 2
      assert_equal presented.final_outcome_attachments_for_components[0]["id"], "02"
      assert_equal presented.final_outcome_attachments_for_components[1]["id"], "03"
    end

    test "presents public feedback documents" do
      schema = schema_item("consultation_outcome_with_feedback")
      schema["details"]["attachments"] = test_documents
      schema["details"]["public_feedback_attachments"] = %w[01 03]
      presented = presented_item("consultation_outcome_with_feedback", schema)
      assert_equal presented.public_feedback_attachments_for_components.length, 2
      assert_equal presented.public_feedback_attachments_for_components[0]["id"], "01"
      assert_equal presented.public_feedback_attachments_for_components[1]["id"], "03"
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
      assert_equal(presented.national_applicability[:england][:applicable], true)
      assert_equal(presented.national_applicability[:northern_ireland][:applicable], false)
      assert_equal(presented.national_applicability[:scotland][:applicable], false)
      assert_equal(presented.national_applicability[:wales][:applicable], false)
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
    end

    test "displays the single page notification button on English pages" do
      I18n.with_locale("en") do
        schema = schema_item("open_consultation")
        presented = presented_item("open_consultation", schema)
        assert presented.display_single_page_notification_button?
      end
    end

    test "does not display the single page notification button on foreign language pages" do
      I18n.with_locale("fr") do
        schema = schema_item("open_consultation")
        presented = presented_item("open_consultation", schema)
        assert_not presented.display_single_page_notification_button?
      end
    end
  end
end
