require 'presenter_test_helper'

class SpecialistDocumentsTest < PresenterTestCase
  include Navigation::SpecialistDocuments

  def stub_content_item(params = {})
    self.stubs(:content_item).returns(
      {
        "links" => {
          "finder" => [{ "base_path" => "/cma-cases" }],
          "details" => {
            "metadata" => {
              "case_type" => "markets",
              "case_state" => "closed",
              "market_sectors" => ["financial-services"],
            }
          }
        }
      }.merge(params)
    )
  end

  def expected(path, params = {})
    "#{path}?#{params.to_query}"
  end

  test "finder_path_and_params" do
    stub_content_item(
      "links" => { "finder" => [{ "base_path" => "/cma-cases" }] },
      "details" => {
        "metadata" => {
          "case_type" => "markets",
          "case_state" => "closed",
          "opened_date" => "2013-06-19",
          "closed_date" => "2017-02-02",
          "market_sector" => ["financial-services"],
          "bulk_published" => true,
        }
      }
    )

    assert_equal expected("/cma-cases",
      case_type: "markets",
      case_state: "closed",
      market_sector: ["financial-services"]), finder_path_and_params
  end

  test "finder_path_and_params for a different document type" do
    stub_content_item(
      "links" => { "finder" => [{ "base_path" => "/aaib-reports" }] },
      "details" => {
        "metadata" => {
          "date_of_occurrence" => "2017-06-18",
          "aircraft_category" => ["sport-aviation-and-balloons"],
          "report_type" => "correspondence-investigation",
          "location" => "Ince Airfield, Merseyside",
          "aircraft_type" => "Skyranger 2000",
          "registration" => "G-YADP",
        }
      }
    )

    assert_equal expected("/aaib-reports",
      aircraft_category: ["sport-aviation-and-balloons"],
      report_type: "correspondence-investigation",
      location: "Ince Airfield, Merseyside",
      aircraft_type: "Skyranger 2000",
      registration: "G-YADP"), finder_path_and_params
  end
end
