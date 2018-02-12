require 'presenter_test_helper'

class PublicationsTest < PresenterTestCase
  include Navigation::Publications

  def stub_content_item(params = {})
    self.stubs(:content_item).returns(
      {
        "government_document_supertype" => "policy-papers",
        "links" => {
          "organisations" => [
            {
              "title" => "UK Visas and Immigration",
              "base_path" => "/government/organisations/uk-visas-and-immigration"
            }
          ],
          "policy_areas" => [
            {
              "title" => "Borders and Immigation",
              "base_path" => "/government/topics/borders-and-immigration"
            }
          ]
        }
      }.merge(params)
    )
  end

  def expected(params = {})
    expected_params = {
      publication_filter_option: "policy-papers",
      departments: ["uk-visas-and-immigration"],
      people: ["all"],
      topics: ["borders-and-immigration"],
      world_locations: ["all"]
    }.merge(params)

    "/government/publications?#{expected_params.to_query}"
  end

  test "finder_path_and_params" do
    stub_content_item

    assert_equal expected, finder_path_and_params
  end

  test "filtering with no government_document_supertype" do
    stub_content_item("government_document_supertype" => nil)

    assert_equal expected(publication_filter_option: "all"), finder_path_and_params
  end

  test "pluralised_document_type capitalises certain document types" do
    self.stubs(:document_type).returns("foi_release")
    assert_equal("FOI releases", pluralised_document_type)

    self.stubs(:document_type).returns("national_statistics")
    assert_equal("National Statistics", pluralised_document_type)

    self.stubs(:document_type).returns("official_statistics")
    assert_equal("Official Statistics", pluralised_document_type)

    self.stubs(:document_type).returns("press_release")
    assert_equal("press releases", pluralised_document_type)
  end
end
