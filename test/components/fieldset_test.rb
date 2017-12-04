require 'component_test_helper'

class FieldsetTest < ComponentTestCase
  def component_name
    "fieldset"
  end

  test "fails to render when no data is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders a fieldset correctly" do
    render_component(
      legend_text: 'Do you have a passport?',
      text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Vel ad neque, maxime est ea laudantium totam fuga!'
    )

    assert_select ".app-c-fieldset__legend", text: 'Do you have a passport?'
    assert_select ".app-c-fieldset", text: /Lorem ipsum dolor sit amet, consectetur adipisicing elit. Vel ad neque, maxime est ea laudantium totam fuga!/
  end
end
