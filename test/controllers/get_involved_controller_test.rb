require "test_helper"
require "gds_api/test_helpers/search"

class GetInvolvedControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::Search

  test "retrieves correct number of open consultations from search_api" do
    body = {
      "results" => {},
      "total" => 83,
      "start" => 0,
    }
    stub_search(body)

    # Overrides for calls to publishing API made during load_get_involved_data
    # These are tested in Smokey as failure prevents a load of some objects
    def @controller.retrieve_given_document_type(_document_type)
      "empty_type"
    end

    def @controller.sort_take_part(take_part_pages) end
    # End override

    @controller.load_get_involved_data
    assert_equal @controller.instance_variable_get(:@open_consultation_count), 83
  end

  test "retrieves correct number of closed consultations from search_api" do
    body = {
      "results" => {},
      "total" => 42,
      "start" => 0,
    }
    stub_search(body)

    assert_equal @controller.retrieve_date_filtered_closed_consultations(0), 42
  end

  test "retrieves next closing consultation from search_api" do
    body = {
      "results" => {
        "first result" => {},
        "second result" => {},
        "third result" => {},
      },
      "total" => 42,
      "start" => 0,
    }
    stub_search(body)

    assert_equal @controller.retrieve_next_closing, ["first result", {}]
  end

  test "sorts take part pages based on order" do
    pages = [
      {
        "title" => "third",
        "details" => {
          "ordering" => "3",
        },
      },
      {
        "title" => "first",
        "details" => {
          "ordering" => "1",
        },
      },
      {
        "title" => "second",
        "details" => {
          "ordering" => "2",
        },
      },
    ]

    sorted = @controller.sort_take_part(pages)

    assert_equal sorted.first["title"], "first"
    assert_equal sorted.last["title"], "third"
  end

private

  def stub_search(body)
    stub_any_search.to_return("body" => body.to_json)
  end
end
