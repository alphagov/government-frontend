require 'component_test_helper'

class LabelTest < ComponentTestCase
  def component_name
    "label"
  end

  test "does not render label when no data is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders label with text" do
    render_component(text: "National Insurance number")

    assert_select ".app-c-label__text", text: "National Insurance number"
  end

  test "renders label with text and hint text" do
    render_component(
      text: "National Insurance number",
      hint_id: "should-match-aria-describedby-input",
      hint_text: "It’s on your National Insurance card, benefit letter, payslip or P60. For example, ‘QQ 12 34 56 C’."
    )

    assert_select ".app-c-label__text", text: "National Insurance number"
    assert_select ".app-c-label__hint", text: "It’s on your National Insurance card, benefit letter, payslip or P60. For example, ‘QQ 12 34 56 C’."
    assert_select ".app-c-label__hint[id=should-match-aria-describedby-input]"
  end

  test "renders label with bold text" do
    render_component(text: "National Insurance number", bold: true)

    assert_select ".app-c-label__text", text: "National Insurance number"
    assert_select ".app-c-label--bold"
  end
end
