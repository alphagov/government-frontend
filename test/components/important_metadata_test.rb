require 'component_test_helper'

class ImportantMetadataTest < ComponentTestCase
  def component_name
    "important-metadata"
  end

  test "does not render metadata when no data is given" do
    assert_empty render_component({})
  end

  test "does not render when an 'other' object is provided without any values" do
    assert_empty render_component(other: { From: [] })
    assert_empty render_component(other: { a: false, b: "", c: [], d: {}, e: nil })
  end

  test "renders a title when a title is provided" do
    render_component(
      title: 'The release date has been changed',
      items: {
      "Release Date": "14 October 2016"
      }
    )

    assert_select ".app-c-important-metadata__title", text: "The release date has been changed"
  end

  test "renders metadata link pairs from data it is given" do
    render_component(items: {
      "Opened": "14 October 2016",
      "Case type": ['<a href="https://www.gov.uk/cma-cases?case_type%5B%5D=mergers">Mergers</a>'],
      "Case state": ['<a href="https://www.gov.uk/cma-cases?case_state%5B%5D=open">Open</a>'],
      "Market sector": ['<a href="https://www.gov.uk/cma-cases?market_sector%5B%5D=motor-industry">Motor industry</a>'],
      "Outcome": ['<a href="https://www.gov.uk/cma-cases?outcome_type%5B%5D=mergers-phase-2-clearance-with-remedies">Mergers - phase 2 clearance with remedies</a>'],
    })

    assert_select ".app-c-important-metadata dt", text: "Opened:"
    assert_select ".app-c-important-metadata dd", text: "14 October 2016"
    assert_select ".app-c-important-metadata dt", text: "Case type:"
    assert_select ".app-c-important-metadata dd", text: "Mergers"
    assert_select ".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?case_type%5B%5D=mergers']",
                  text: "Mergers"
    assert_select ".app-c-important-metadata dt", text: "Case state:"
    assert_select ".app-c-important-metadata dd", text: "Open"
    assert_select ".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?case_state%5B%5D=open']",
                  text: "Open"
    assert_select ".app-c-important-metadata dt", text: "Market sector:"
    assert_select ".app-c-important-metadata dd", text: "Motor industry"
    assert_select ".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?market_sector%5B%5D=motor-industry']",
                  text: "Motor industry"
    assert_select ".app-c-important-metadata dt", text: "Outcome:"
    assert_select ".app-c-important-metadata dd", text: "Mergers - phase 2 clearance with remedies"
    assert_select ".app-c-important-metadata dd a[href='https://www.gov.uk/cma-cases?outcome_type%5B%5D=mergers-phase-2-clearance-with-remedies']",
                  text: "Mergers - phase 2 clearance with remedies"
  end

  test "link tracking is enabled" do
    render_component(items: { "Case type": ["<a href='https://www.gov.uk/cma-cases?case_type%5B%5D=mergers'>Mergers</a>"] })
    assert_select ".app-c-important-metadata dl[data-module='track-click']"
  end
end
