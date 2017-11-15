require 'component_test_helper'

class ContentMetadataTest < ComponentTestCase
  def component_name
    "content-metadata"
  end

  test "does not render metadata when no data is given" do
    assert_empty render_component({})
  end

  test "does not render when an 'other' object is provided without any values" do
    assert_empty render_component(other: { From: [] })
    assert_empty render_component(other: { a: false, b: "", c: [], d: {}, e: nil })
  end

  test "renders a from link when from data is given" do
    render_component(other: { From: ["<a href='/government/organisations/ministry-of-defence'>Ministry of Defence</a>"] })
    assert_select ".app-c-content-metadata__other a[href='/government/organisations/ministry-of-defence']", text: 'Ministry of Defence'
    assert_select ".app-c-content-metadata__other", text: 'From: Ministry of Defence'
  end


  test "renders two from links when two publishers are given" do
    render_component(other: { From: ["<a href='/government/organisations/ministry-of-defence'>Ministry of Defence</a>", "<a href='/government/organisations/education-funding-agency'>Education Funding Agency</a>"] })
    assert_select ".app-c-content-metadata__other a[href='/government/organisations/ministry-of-defence']", text: 'Ministry of Defence'
    assert_select ".app-c-content-metadata__other a[href='/government/organisations/education-funding-agency']", text: 'Education Funding Agency'
  end

  test "renders a sentence when multiple publishers are given" do
    render_component(other: { From: ["<a href='/government/organisations/department-for-education'>Department for Education</a>", "<a href='/government/organisations/education-funding-agency'>Education Funding Agency</a>"] })
    assert_select ".app-c-content-metadata__other", text: 'From: Department for Education and Education Funding Agency'
  end

  test "renders published dates component when only published date is given" do
    render_component(published: "31 July 2017")
    assert_select ".app-c-published-dates"
  end

  test "renders published dates component when only last updated date is given" do
    render_component(last_updated: "20 September 2017")
    assert_select ".app-c-published-dates"
  end

  test "renders full metadata component when all parameters are given" do
    render_component(other: { From: ["<a href='/government/organisations/ministry-of-defence'>Ministry of Defence</a>"] }, published: "31 July 2017", last_updated: "20 September 2017", link_to_history: true)
    assert_select ".app-c-published-dates"
    assert_select ".app-c-content-metadata__other a[href='/government/organisations/ministry-of-defence']", text: 'Ministry of Defence'
    assert_select ".app-c-content-metadata__other", text: 'From: Ministry of Defence'
  end
end
