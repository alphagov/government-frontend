require 'component_test_helper'

class PrintLinkTest < ComponentTestCase
  def component_name
    "lead-paragraph"
  end

  test "renders nothing without a description" do
    assert_empty render_component({})
  end

  test "renders a lead paragraph" do
    render_component(description: 'UK Visas and Immigration is making changes to the Immigration Rules affecting various categories.')
    assert_select ".app-c-lead-paragraph", text: "UK Visas and Immigration is making changes to the Immigration Rules affecting various categories."
  end
end
