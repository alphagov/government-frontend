require "test_helper"

class ServiceManualServiceStandardTest < ActionDispatch::IntegrationTest
  test "service standard page has a title, summary and intro" do
    setup_and_visit_content_item("service_manual_service_standard",
                                 "title" => "Service Standard",
                                 "description" => "The Service Standard is a set of 14 criteria.",
                                 "details" => {
                                   "body" => "All public facing transactional services must meet the standard.",
                                 })

    assert page.has_css?(".gem-c-title__text", text: "Service Standard"), "No title found"
    assert page.has_css?(".app-page-header__summary", text: "The Service Standard is a set of 14 criteria"), "No description found"
    assert page.has_css?(".app-page-header__intro", text: "All public facing transactional services must meet the standard."), "No body found"
  end

  test "service standard page has points" do
    setup_and_visit_content_item("service_manual_service_standard")

    assert_equal 3, points.length

    within(points[0]) do
      assert_text("1.\nUnderstand user needs")
      assert page.has_content?(/Research to develop a deep knowledge/), "Description not found"
      assert page.has_link?("Read more about point 1", href: "/service-manual/service-standard/understand-user-needs"), "Link not found"
    end

    within(points[1]) do
      assert_text("2.\nDo ongoing user research")
      assert page.has_content?(/Put a plan in place/), "Description not found"
      assert page.has_link?("Read more about point 2", href: "/service-manual/service-standard/do-ongoing-user-research"), "Link not found"
    end

    within(points[2]) do
      assert_text("3.\nHave a multidisciplinary team")
      assert page.has_content?(/Put in place a sustainable multidisciplinary/), "Description not found"
      assert page.has_link?("Read more about point 3", href: "/service-manual/service-standard/have-a-multidisciplinary-team"), "Link not found"
    end
  end

  test "each point has an anchor tag so that they can be linked to externally" do
    assert_nothing_raised { setup_and_visit_content_item("service_manual_service_standard") }

    within("#criterion-1") do
      assert_text("1.\nUnderstand user needs")
    end

    within("#criterion-2") do
      assert_text("2.\nDo ongoing user research")
    end

    within("#criterion-3") do
      assert_text("3.\nHave a multidisciplinary team")
    end
  end

  test "it includes a link to subscribe for email alerts" do
    setup_and_visit_content_item("service_manual_service_standard")

    assert page.has_link?(
      "email",
      href: "/email-signup?link=/service-manual/service-standard",
    )
  end

  def points
    find_all(".app-service-standard-point")
  end
end
