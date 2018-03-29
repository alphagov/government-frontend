require 'component_test_helper'

class BlueBoxCampaignTest < ComponentTestCase
  def component_name
    "blue-box-campaign"
  end

  test "fails to render a blue box campaign link when no parameters given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a blue box campaign link when required params are given" do
    render_component(title: "Campaign about things", description: "Look at this campaign about things", href: "https://www.gov.uk/things")
    assert_select "h2", "Campaign about things"
    assert_select "a", href: /https:\/\/www.gov.uk\/things/
    assert_select "span", "Look at this campaign about things"
  end
end
