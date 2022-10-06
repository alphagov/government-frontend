require "test_helper"
require "gds_api/test_helpers/search"

class GetInvolvedControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Search
  include GdsApi::TestHelpers::ContentStore

  def setup
    content_item_body = {
      "document_type" => "get_involved",
      "schema_name" => "get_involved",
      "details" => {},
      "links" => {
        "take_part_pages" => [
          {
            "title" => "Take part page 1",
            "base_path" => "/take-part-1",
            "details" => {
              "image" => {},
            },
          },
          {
            "title" => "Take part page 2",
            "base_path" => "/take-part-2",
            "details" => {
              "image" => {},
            },
          },
        ],
      },
    }

    stub_content_store_has_item("/government/get-involved", content_item_body)

    no_results = { "results" => {}, "total" => 0, "start" => 0 }
    stub_any_search.to_return("body" => no_results.to_json)
  end

  test "returns a 200 response" do
    get :show
    assert_response :ok
  end

  test "showing total number of open consultations" do
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation"),
                      response: { "results" => [], "total" => 83 })

    get :show
    assert_select ".gem-c-big-number", /83.+Open consultations/m
  end

  test "showing total number of closed consultations" do
    stub_search_query(query: hash_including(filter_content_store_document_type: "closed_consultation"),
                      response: { "results" => [], "total" => 110 })

    get :show
    assert_select ".gem-c-big-number", /110.+Closed consultations/m
  end

  test "showing the next closing consultation" do
    Timecop.freeze do
      title = "Next closing consultation on time zones"
      stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation",
                                              filter_end_date: "from: #{Time.zone.now.to_date}"),
                        response: { "results" => [consultation_result(title: title)] })

      get :show
      assert_select ".gem-c-inset-text", /#{title}/
    end
  end

  test "showing recently opened consultations" do
    title = "Open consultation on time zones"
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation"),
                      response: { "results" => [consultation_result(title: title)] })

    get :show
    assert response.body.include?(title)
  end

  test "showing recent consultation outcomes" do
    title = "Consultation outcome on time zones"
    stub_search_query(query: hash_including(filter_content_store_document_type: "consultation_outcome"),
                      response: { "results" => [consultation_result(title: title)] })

    get :show
    assert response.body.include?(title)
  end

  test "shows the take part pages" do
    get :show
    assert response.body.include?("Take part page 1")
    assert response.body.include?("Take part page 2")
  end

private

  def stub_search_query(query:, response:)
    stub_request(:get, /\A#{Plek.new.find('search')}\/search.json/)
      .with(query: query)
      .to_return(body: response.to_json)
  end

  def consultation_result(title: "Consulting on time zones")
    {
      "title" => title,
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
