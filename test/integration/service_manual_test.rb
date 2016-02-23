require 'test_helper'

class ServiceManualTest < ActionDispatch::IntegrationTest
  test "it displays a custom header" do
    guide_sample = JSON.parse(GovukContentSchemaTestHelpers::Examples.new.get('service_manual_guide', 'basic_with_related_discussions'))
    content_store_has_item("/service-manual/agile", guide_sample.to_json)
    visit "/service-manual/agile"
    within "#proposition-menu" do
      assert page.has_link? "Digital service manual", href: "/service-manual"
    end
  end
end
