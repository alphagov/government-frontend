require 'component_test_helper'

class RadioTest < ComponentTestCase
  def component_name
    "radio"
  end

  test "does not render anything if no data is passed" do
    assert_empty render_component({})
  end

  test "throws an error if items are passed but no name is passed" do
    assert_raise do
      render_component(items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        }
      ])
    end
  end

  test "renders radio-group with one item" do
    render_component(
      name: "radio-group-one-item",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        }
      ]
    )

    assert_select ".app-c-radio__input[name=radio-group-one-item]"
    assert_select ".app-c-radio:first-child .app-c-radio__label", text: "Use Government Gateway"
  end

  test "renders radio-group with multiple items" do
    render_component(
      name: "radio-group-multiple-items",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify"
        }
      ]
    )

    assert_select ".app-c-radio__input[name=radio-group-multiple-items]"
    assert_select ".app-c-radio:first-child .app-c-radio__label", text: "Use Government Gateway"
    assert_select ".app-c-radio:last-child .app-c-radio__label", text: "Use GOV.UK Verify"
  end

  test "renders radio-group with bold labels" do
    render_component(
      name: "radio-group-bold-labels",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway",
          bold: true
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify",
          bold: true
        }
      ]
    )

    assert_select ".app-c-radio__input[name=radio-group-bold-labels]"
    assert_select ".app-c-radio .app-c-label--bold"
  end

  test "renders radio-group with hint text" do
    render_component(
      name: "radio-group-hint-text",
      items: [
        {
          value: "government-gateway",
          hint_text: "You'll have a user ID if you've signed up to do things like sign up Self Assessment tax return online.",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          hint_text: "You'll have an account if you've already proved your identity with a certified company, such as the Post Office.",
          text: "Use GOV.UK Verify"
        }
      ]
    )

    assert_select ".app-c-radio__input[name=radio-group-hint-text]"
    assert_select ".app-c-radio:first-child .app-c-radio__label", text: "Use Government Gateway"
    assert_select ".app-c-radio:first-child .app-c-label__hint", text: "You'll have a user ID if you've signed up to do things like sign up Self Assessment tax return online."
    assert_select ".app-c-radio:last-child .app-c-radio__label", text: "Use GOV.UK Verify"
    assert_select ".app-c-radio:last-child .app-c-label__hint", text: "You'll have an account if you've already proved your identity with a certified company, such as the Post Office."
  end

  test "renders radio-group with checked option" do
    render_component(
      name: "radio-group-checked-option",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify",
          checked: true
        }
      ]
    )

    assert_select ".app-c-radio__input[name=radio-group-checked-option]"
    assert_select ".app-c-radio__input[checked]", value: "govuk-verify"
  end

  test "renders radio-group with custom id prefix" do
    render_component(
      id_prefix: 'custom',
      name: "radio-group-custom-id-prefix",
      items: [
        {
          value: "government-gateway",
          text: "Use Government Gateway"
        },
        {
          value: "govuk-verify",
          text: "Use GOV.UK Verify"
        }
      ]
    )

    assert_select ".app-c-radio__input[name=radio-group-custom-id-prefix]"
    assert_select ".app-c-radio__input[id=custom-0]", value: "government-gateway"
    assert_select ".app-c-radio__label[for=custom-0]", text: "Use Government Gateway"
    assert_select ".app-c-radio__input[id=custom-1]", value: "govuk-verify"
    assert_select ".app-c-radio__label[for=custom-1]", text: "Use GOV.UK Verify"
  end

  # This component can be interacted with, so use integration tests for these cases.
  class RadioIntegrationTest < ActionDispatch::IntegrationTest
    def input_visible
      false # our inputs are hidden with CSS, and rely on the label.
    end

    test "radio can choose an option" do
      visit '/component-guide/radio/default/preview'

      within '.component-guide-preview' do
        assert page.has_text?('Use GOV.UK Verify')
        assert page.has_text?('Use Government Gateway')

        refute page.has_selector?('.app-c-radio__input:checked', visible: input_visible)

        page.choose(option: 'govuk-verify', allow_label_click: true)

        refute page.has_selector?('.app-c-radio__input[value=government-gateway]:checked', visible: input_visible)
        assert page.has_selector?('.app-c-radio__input[value=govuk-verify]:checked', visible: input_visible)
      end
    end

    test "radio keyboard interaction" do
      visit '/component-guide/radio/default/preview'

      within '.component-guide-preview' do
        radio_input = find('.app-c-radio__input[value=government-gateway]', visible: input_visible)
        radio_input.trigger(:focus)
        radio_input.send_keys(:space)

        assert page.has_selector?('.app-c-radio__input[value=government-gateway]:checked', visible: input_visible)
        refute page.has_selector?('.app-c-radio__input[value=govuk-verify]:checked', visible: input_visible)

        radio_input.send_keys(:down)

        refute page.has_selector?('.app-c-radio__input[value=government-gateway]:checked', visible: input_visible)
        assert page.has_selector?('.app-c-radio__input[value=govuk-verify]:checked', visible: input_visible)

        radio_input.send_keys(:up)

        assert page.has_selector?('.app-c-radio__input[value=government-gateway]:checked', visible: input_visible)
        refute page.has_selector?('.app-c-radio__input[value=govuk-verify]:checked', visible: input_visible)
      end
    end

    test "radio can choose an option when already has one checked" do
      visit '/component-guide/radio/with_checked_option/preview'

      within '.component-guide-preview' do
        assert page.has_text?('Use Government Gateway')
        assert page.has_text?('Use GOV.UK Verify')

        assert page.has_selector?('.app-c-radio__input[value=govuk-verify]:checked', visible: input_visible)
        refute page.has_selector?('.app-c-radio__input[value=government-gateway]:checked', visible: input_visible)

        page.choose(option: 'government-gateway', allow_label_click: true)

        assert page.has_selector?('.app-c-radio__input[value=government-gateway]:checked', visible: input_visible)
        refute page.has_selector?('.app-c-radio__input[value=govuk-verify]:checked', visible: input_visible)
      end
    end
  end
end
