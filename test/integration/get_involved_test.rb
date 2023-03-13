require "test_helper"
require "gds_api/test_helpers/search"

class GetInvolvedTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Search

  setup do
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation"), response: { "results" => [], "total" => 83 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "closed_consultation"), response: { "results" => [], "total" => 110 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "consultation_outcome"), response: { "results" => [consultation_result] })

    setup_and_visit_content_item("get_involved")
  end

  test "page has correct title" do
    puts page.inspect
    assert page.has_title?("Get involved - GOV.UK")
  end

  test "includes the correct number of open consultations" do
    assert page.has_selector?(".gem-c-big-number", text: /83.+Open consultations/m)
  end

  test "includes the correct number of closed consultations" do
    assert page.has_selector?(".gem-c-big-number", text: /110.+Closed consultations/m)
  end

  test "includes the next closing consultation" do
    assert page.has_text?("Consulting on time zones")
  end

  test "shows the take part pages" do
    assert page.has_text?("Volunteer")
    assert page.has_text?("National Citizen Service")
  end

private

  def stub_search_query(query:, response:)
    stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
      .with(query:)
      .to_return(body: response.to_json)
  end

  def consultation_result
    {
      "title" => "Consulting on time zones",
      "public_timestamp" => "2022-02-14T00:00:00.000+01:00",
      "end_date" => "2022-02-14T00:00:00.000+01:00",
      "link" => "/consultation/link",
      "organisations" => [{
        "slug" => "ministry-of-justice",
        "link" => "/government/organisations/ministry-of-justice",
        "title" => "Ministry of Justice",
        "acronym" => "MoJ",
        "organisation_state" => "live",
      }],
    }
  end
end
