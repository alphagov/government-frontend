require 'component_test_helper'

class ErrorSummaryTest < ComponentTestCase
  def component_name
    "error-summary"
  end

  test "fails to render when no data is given" do
    assert_raise do
      render_component({})
    end
  end

  test "renders an error summary with title and aria-labelledby set correctly" do
    render_component(
      title: 'Message to alert the user to a problem goes here'
    )

    aria_labelledby_id = ''
    assert_select(".app-c-error-summary") do |element|
      aria_labelledby_id = element.css('.app-c-error-summary').first.attributes["aria-labelledby"].value
    end

    assert_select ".app-c-error-summary__title[id='#{aria_labelledby_id}']", text: 'Message to alert the user to a problem goes here'
    assert_select ".app-c-error-summary__text", count: 0
    assert_select ".app-c-error-summary__list", count: 0
  end

  test "renders an error summary with items" do
    render_component(
      title: 'Message to alert the user to a problem goes here',
      description: 'Optional description of the errors and how to correct them',
      items: [
        {
          text: 'Descriptive link to the question with an error',
          href: '#example-error-1'
        }
      ]
    )
    assert_select ".app-c-error-summary__title", text: 'Message to alert the user to a problem goes here'
    assert_select ".app-c-error-summary__text", text: 'Optional description of the errors and how to correct them'
    assert_select(
      "ul li a.app-c-error-summary__link:first-of-type[href='#example-error-1']",
      text: 'Descriptive link to the question with an error'
    )
  end

  test "renders an error summary with multiple links" do
    render_component(
      title: 'Message to alert the user to a problem goes here',
      description: 'Optional description of the errors and how to correct them',
      items: [
        {
          text: 'Descriptive link to the question with an error 1',
          href: '#example-error-1'
        },
        {
          text: 'Descriptive link to the question with an error 2',
          href: '#example-error-2'
        },
        {
          text: 'Descriptive link to the question with an error 3',
          href: '#example-error-3'
        }
      ]
    )

    assert_select ".app-c-error-summary__title", text: 'Message to alert the user to a problem goes here'
    assert_select ".app-c-error-summary__text", text: 'Optional description of the errors and how to correct them'

    assert_select(
      "ul li a.app-c-error-summary__link:first-of-type[href='#example-error-1']",
      text: 'Descriptive link to the question with an error 1'
    )
    assert_select(
      "ul li a.app-c-error-summary__link:nth-of-type(1)[href='#example-error-2']",
      text: 'Descriptive link to the question with an error 2'
    )
    assert_select(
      "ul li a.app-c-error-summary__link:last-of-type[href='#example-error-3']",
      text: 'Descriptive link to the question with an error 3'
    )
  end
end
