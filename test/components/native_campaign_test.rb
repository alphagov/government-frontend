require 'component_test_helper'

class NativeCampaignTest < ComponentTestCase
  def component_name
    "native-campaign"
  end

  test "fails to render a native campaign link when no parameters given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a native campaign link when required params are given" do
    render_component(title: "Campaign about things", description: "Look at this campaign about things", href: "https://www.gov.uk/things")
    assert_select "a", "Campaign about things"
    assert_select "a", href: /https:\/\/www.gov.uk\/things/
    assert_select "p", "Look at this campaign about things"
  end
end
