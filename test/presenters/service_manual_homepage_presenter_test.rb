require "presenter_test_helper"

class ServiceManualHomepagePresenterTest < PresenterTestCase
  def schema_name
    "service_manual_homepage"
  end
  test "#topics returns the children in the links, ordered alphabetically" do
    homepage = presented_item(schema_name,
                              "links" => {
                                "children" => [
                                  { "title" => "Agile Delivery" },
                                  { "title" => "Helping people to use your service" },
                                  { "title" => "Funding and procurement" },
                                ],
                              })

    assert_equal(
      [
        { "title" => "Agile Delivery" },
        { "title" => "Funding and procurement" },
        { "title" => "Helping people to use your service" },
      ],
      homepage.topics,
    )
  end
end
