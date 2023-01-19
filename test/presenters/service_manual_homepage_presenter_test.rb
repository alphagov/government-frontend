require "test_helper"

class ServiceManualHomepagePresenterTest < ActiveSupport::TestCase
  test "#topics returns the children in the links, ordered alphabetically" do
    homepage = presented_homepage(
      "links" => {
        "children" => [
          { "title" => "Agile Delivery" },
          { "title" => "Helping people to use your service" },
          { "title" => "Funding and procurement" },
        ],
      },
    )

    assert_equal(
      [
        { "title" => "Agile Delivery" },
        { "title" => "Funding and procurement" },
        { "title" => "Helping people to use your service" },
      ],
      homepage.topics,
    )
  end

private

  def presented_homepage(overriden_attributes = {})
    ServiceManualHomepagePresenter.new(
      GovukSchemas::Example.find("service_manual_homepage", example_name: "service_manual_homepage").merge(overriden_attributes),
    )
  end
end
