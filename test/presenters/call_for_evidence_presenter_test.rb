require "presenter_test_helper"

class CallForEvidencePresenterTest
  class PresentedCallForEvidence < PresenterTestCase
    def schema_name
      "call_for_evidence"
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
      assert_equal schema_item("open_call_for_evidence")["document_type"], presented_item("open_call_for_evidence").document_type
      assert_equal schema_item("open_call_for_evidence")["details"]["body"], presented_item("open_call_for_evidence").body
    end

    test "presents friendly dates for opening and closing dates, including time" do
      schema = schema_item("open_call_for_evidence")
      schema["details"]["opening_date"] = "2016-11-04T10:00:00+00:00"
      schema["details"]["closing_date"] = "2216-12-16T16:00:00+00:00"
      presented = presented_item("open_call_for_evidence", schema)

      assert_equal "10am on 4 November 2016", presented.opening_date
      assert_equal "4pm on 16 December 2216", presented.closing_date
    end

    test "presents closing dates at 12am as 11:59pm on the day before" do
      schema = schema_item("open_call_for_evidence")
      schema["details"]["opening_date"] = "2016-11-03T00:01:00+00:00"
      schema["details"]["closing_date"] = "2016-11-04T00:00:00+00:00"
      presented = presented_item("open_call_for_evidence", schema)

      assert_equal "12:01am on 3 November 2016", presented.opening_date
      assert_equal "11:59pm on 3 November 2016", presented.closing_date
    end

    test "presents opening dates at 12am as the date without a time" do
      schema = schema_item("open_call_for_evidence")
      schema["details"]["opening_date"] = "2016-11-03T00:00:00+00:00"
      schema["details"]["closing_date"] = "2016-11-04T00:00:00+00:00"
      presented = presented_item("open_call_for_evidence", schema)

      assert_equal "3 November 2016", presented.opening_date
    end

    test "presents 12pm as midday" do
      schema = schema_item("open_call_for_evidence")
      schema["details"]["opening_date"] = "2016-11-04T12:00:00+00:00"
      presented = presented_item("open_call_for_evidence", schema)

      assert_equal "midday on 4 November 2016", presented.opening_date
    end

    test "presents open and closed states" do
      assert presented_item("open_call_for_evidence").open?
      assert_not presented_item("open_call_for_evidence").closed?

      assert presented_item("closed_call_for_evidence").closed?
      assert_not presented_item("closed_call_for_evidence").open?

      assert presented_item("call_for_evidence_outcome").closed?
      assert_not presented_item("call_for_evidence_outcome").open?

      assert_not presented_item("unopened_call_for_evidence").closed?
      assert_not presented_item("unopened_call_for_evidence").open?
    end

    test "presents call for evidence documents" do
      schema = schema_item("closed_call_for_evidence")
      schema["details"]["attachments"] = test_documents
      schema["details"]["featured_attachments"] = %w[01 02]
      presented = presented_item("closed_call_for_evidence", schema)

      assert_equal presented.general_documents.length, 2
      assert_equal presented.general_documents[0]["id"], "01"
      assert_equal presented.general_documents[1]["id"], "02"
    end

    test "presents outcome documents" do
      schema = schema_item("call_for_evidence_outcome")
      schema["details"]["attachments"] = test_documents
      schema["details"]["outcome_attachments"] = %w[02 03]
      presented = presented_item("call_for_evidence_outcome", schema)

      assert_equal presented.outcome_documents.length, 2
      assert_equal presented.outcome_documents[0]["id"], "02"
      assert_equal presented.outcome_documents[1]["id"], "03"
    end

    test "presents URL for calls for evidence held on another website" do
      assert presented_item("open_call_for_evidence").held_on_another_website?
      assert_not presented_item("closed_call_for_evidence").held_on_another_website?

      assert_equal "https://consult.education.gov.uk/part-time-maintenance-loans/post-graduate-doctoral-loans/", presented_item("open_call_for_evidence").held_on_another_website_url
      assert_not presented_item("closed_call_for_evidence").held_on_another_website_url
    end

    test "presents ways to respond" do
      example_ways_to_respond = schema_item("open_call_for_evidence_with_participation")["details"]["ways_to_respond"]
      presented = presented_item("open_call_for_evidence_with_participation")

      assert presented.ways_to_respond?
      assert_equal example_ways_to_respond["email"], presented.email
      assert_equal example_ways_to_respond["link_url"], presented.respond_online_url
      assert_equal example_ways_to_respond["postal_address"], presented.postal_address
    end

    test "presents a response form when included with email or postal address" do
      example_ways_to_respond = schema_item("open_call_for_evidence_with_participation")["details"]["ways_to_respond"]
      presented = presented_item("open_call_for_evidence_with_participation")

      assert presented.response_form?
      assert_equal example_ways_to_respond["attachment_url"], presented.attachment_url

      example_without_email = schema_item("open_call_for_evidence_with_participation")
      example_without_email["details"]["ways_to_respond"].delete("email")
      example_without_email["details"]["ways_to_respond"].delete("postal_address")
      presented_without_email = presented_item("open_call_for_evidence_with_participation", example_without_email)

      assert_not presented_without_email.response_form?
    end

    test "does not show ways to respond when call for evidence is closed" do
      example = schema_item("closed_call_for_evidence")
      example["details"]["ways_to_respond"] = { "email" => "email@email.com" }
      presented = presented_item("closed_call_for_evidence", example)

      assert_not presented.ways_to_respond?
    end

    test "does not show ways to respond when only an attachment url is provided" do
      example = schema_item("open_call_for_evidence_with_participation")
      example["details"]["ways_to_respond"].delete("email")
      example["details"]["ways_to_respond"].delete("postal_address")
      example["details"]["ways_to_respond"].delete("link_url")
      presented = presented_item("open_call_for_evidence_with_participation", example)

      assert_not presented.ways_to_respond?
    end

    test "presents share urls with encoded url and title" do
      assert_equal "https://www.facebook.com/sharer/sharer.php?u=https%3A%2F%2Fwww.test.gov.uk%2Fgovernment%2Fcall_for_evidence%2Fyouth-vaping-call-for-evidence", presented_item("open_call_for_evidence").share_links[0][:href]
      assert_equal "https://twitter.com/share?url=https%3A%2F%2Fwww.test.gov.uk%2Fgovernment%2Fcall_for_evidence%2Fyouth-vaping-call-for-evidence&text=Youth%20Vaping", presented_item("open_call_for_evidence").share_links[1][:href]
    end

    test "presents the single page notification button" do
      schema = schema_item("open_call_for_evidence")
      presented = presented_item("open_call_for_evidence", schema)

      assert presented.has_single_page_notifications?
    end
  end
end
