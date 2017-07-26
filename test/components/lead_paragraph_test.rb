require 'component_test_helper'

class LeadParagraphTest < ComponentTestCase
  def component_name
    "lead-paragraph"
  end

  test "renders nothing without a description" do
    assert_empty render_component({})
  end

  test "renders a lead paragraph" do
    nbsp = HTMLEntities.new.decode('&nbsp;')

    render_component(text: 'UK Visas and Immigration is making changes to the Immigration Rules affecting various categories.')
    assert_select ".app-c-lead-paragraph", text: "UK Visas and Immigration is making changes to the Immigration Rules affecting various#{nbsp}categories."
  end
end
