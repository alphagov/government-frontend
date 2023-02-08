require "test_helper"

class ServiceManualServiceToolkitTest < ActionDispatch::IntegrationTest
  test "the service toolkit can be visited" do
    setup_and_visit_content_item("service_manual_service_toolkit")

    assert page.has_title? "Service Toolkit"
  end

  test "the service toolkit does not include the new style feedback form" do
    setup_and_visit_content_item("service_manual_service_toolkit")

    assert_not page.has_css?(".improve-this-page"),
               "Improve this page component should not be present on the page"
  end

  test "the service toolkit displays the introductory hero" do
    setup_and_visit_content_item("service_manual_service_toolkit")

    assert page.has_content? <<~TEXT.chomp
      Design and build government services
      All you need to design, build and run services that meet government standards.
    TEXT
  end

  test "the homepage includes both collections" do
    setup_and_visit_content_item("service_manual_service_toolkit")

    assert_equal 2, collections.length, "Expected to find 2 collections"
  end

  test "the homepage includes the titles for both collections" do
    setup_and_visit_content_item("service_manual_service_toolkit")

    within(the_first_collection) do
      assert page.has_content? "Standards"
    end

    within(the_second_collection) do
      assert page.has_content? "Buying"
    end
  end

  test "the homepage includes the descriptions for both collections" do
    setup_and_visit_content_item("service_manual_service_toolkit")

    within(the_first_collection) do
      assert page.has_content? "Meet the standards for government services"
    end

    within(the_second_collection) do
      assert page.has_content? "Extra skills, people and technology to help build your service"
    end
  end

  test "the homepage includes the links from all collections" do
    setup_and_visit_content_item(
      "service_manual_service_toolkit",
      "details" => {
        "collections" => [
          {
            "title" => "Standards",
            "description" => "Meet the standards for government services",
            "links" => [
              {
                "title" => "Service Standard",
                "url" => "https://www.gov.uk/service-manual/service-standard",
                "description" => "",
              },
            ],
          },
          {
            "title" => "Buying",
            "description" => "Skills and technology for building digital services",
            "links" => [
              {
                "title" => "Digital Marketplace",
                "url" => "https://www.gov.uk/digital-marketplace",
                "description" => "",
              },
            ],
          },
        ],
      },
    )

    within(the_first_collection) do
      assert page.has_link? "Service Standard",
                            href: "https://www.gov.uk/service-manual/service-standard"
    end

    within(the_second_collection) do
      assert page.has_link? "Digital Marketplace",
                            href: "https://www.gov.uk/digital-marketplace"
    end
  end

private

  def collections
    find_all(".app-collection")
  end

  def the_first_collection
    collections[0]
  end

  def the_second_collection
    collections[1]
  end
end
