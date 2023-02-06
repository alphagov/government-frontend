require "presenter_test_helper"

class ServiceManualServiceStandardPresenterTest < PresenterTestCase
  def schema_name
    "service_manual_service_standard"
  end

  test "#points gets points from the details" do
    points = presented_item.points

    assert(points.any? { |point_hash| point_hash.title == "1. Understand user needs" })
    assert(points.any? { |point_hash| point_hash.title == "2. Do ongoing user research" })
  end

  test "#points returns points ordered numerically" do
    content_item_hash = {
      "links" => {
        "children" => [
          { "title" => "3. Title" },
          { "title" => "1. Title" },
          { "title" => "9. Title" },
          { "title" => "10. Title" },
          { "title" => "5. Title" },
          { "title" => "6. Title" },
          { "title" => "2. Title" },
          { "title" => "4. Title" },
          { "title" => "7. Title" },
          { "title" => "11. Title" },
          { "title" => "8. Title" },
        ],
      },
    }

    points_titles =
      presented_item(schema_name, content_item_hash).points.map(&:title)

    assert_equal points_titles,
                 [
                   "1. Title",
                   "2. Title",
                   "3. Title",
                   "4. Title",
                   "5. Title",
                   "6. Title",
                   "7. Title",
                   "8. Title",
                   "9. Title",
                   "10. Title",
                   "11. Title",
                 ]
  end

  test "#points is empty if there aren't any points in the content item" do
    content_item_hash = { "links" => {} }
    assert presented_item(schema_name, content_item_hash).points.empty?
  end

  test "#breadcrumbs contains a link to the service manual root" do
    content_item_hash = {
      "title" => "Service Standard",
    }

    assert presented_item(schema_name, content_item_hash).breadcrumbs,
           [
             { title: "Service manual", url: "/service-manual" },
           ]
  end

  test "#email_alert_signup returns a link to the email alert signup" do
    assert_equal "/email-signup?link=/service-manual/service-standard",
                 presented_item.email_alert_signup_link
  end

  test "#poster_url returns a link to the service standard poster" do
    assert_equal "http://example.com/service-standard-poster.pdf", presented_item.poster_url
  end
end
