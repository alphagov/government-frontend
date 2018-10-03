require 'component_test_helper'

class PublisherMetadataTest < ComponentTestCase
  def component_name
    "publisher-metadata"
  end

  test "does not render metadata when no data is given" do
    assert_empty render_component({})
  end

  test "does not render when an 'other' object is provided without any values" do
    assert_empty render_component(other: { from: [] })
    assert_empty render_component(other: { a: false, b: "", c: [], d: {}, e: nil })
  end

  test "renders a from link when from data is given" do
    render_component(other: { From: ["<a href='/government/organisations/ministry-of-defence'>Ministry of Defence</a>"] })
    assert_select ".app-c-publisher-metadata__other a[href='/government/organisations/ministry-of-defence']", text: 'Ministry of Defence'
    assert_select ".app-c-publisher-metadata__other dt", text: 'From:'
    assert_select ".app-c-publisher-metadata__other dd", text: 'Ministry of Defence'
  end


  test "renders two from links when two publishers are given" do
    render_component(other: { from: ["<a href='/government/organisations/ministry-of-defence'>Ministry of Defence</a>", "<a href='/government/organisations/education-funding-agency'>Education Funding Agency</a>"] })
    assert_select ".app-c-publisher-metadata__other a[href='/government/organisations/ministry-of-defence']", text: 'Ministry of Defence'
    assert_select ".app-c-publisher-metadata__other a[href='/government/organisations/education-funding-agency']", text: 'Education Funding Agency'
  end

  test "renders a sentence when multiple publishers are given" do
    render_component(other: { from: ["<a href='/government/organisations/department-for-education'>Department for Education</a>", "<a href='/government/organisations/education-funding-agency'>Education Funding Agency</a>"] })
    assert_select ".app-c-publisher-metadata__other dt", text: 'From:'
    assert_select ".app-c-publisher-metadata__other dd", text: 'Department for Education and Education Funding Agency'
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
    render_component(other: { from: ["<a href='/government/organisations/ministry-of-defence'>Ministry of Defence</a>"] }, published: "31 July 2017", last_updated: "20 September 2017", link_to_history: true)
    assert_select ".app-c-published-dates"
    assert_select ".app-c-publisher-metadata__other a[href='/government/organisations/ministry-of-defence']", text: 'Ministry of Defence'
    assert_select ".app-c-publisher-metadata__other dt", text: 'From:'
    assert_select ".app-c-publisher-metadata__other dd", text: 'Ministry of Defence'
  end

  test "link tracking is enabled" do
    render_component(other: { from: ["<a href='/government/organisations/ministry-of-defence'>Ministry of Defence</a>"] })
    assert_select ".app-c-publisher-metadata__other dl[data-module='track-click']"
  end

  test "renders two collection links when two collections are given" do
    render_component(other: { collections: ["<a href='/government/collections/tribunals-statistics'>Tribunals statistics</a>", "<a href='/government/collections/civil-justice-statistics-quarterly'>Civil justice statistics quarterly</a>"] })
    assert_select ".app-c-publisher-metadata__other dt", text: 'Collections:'
    assert_select ".app-c-publisher-metadata__other dd a[href='/government/collections/tribunals-statistics']", text: 'Tribunals statistics'
    assert_select ".app-c-publisher-metadata__other dd a[href='/government/collections/civil-justice-statistics-quarterly']", text: 'Civil justice statistics quarterly'
  end

  test "renders the first collection and a toggle link when more than two collections are given" do
    render_component(other: { collections: ["<a href='/government/collections/tribunals-statistics'>Tribunals statistics</a>", "<a href='/government/collections/civil-justice-statistics-quarterly'>Civil justice statistics quarterly</a>", "<a href='/government/collections/offender-management-statistics-quarterly'>Offender management statistics quarterly</a>"] })
    assert_select ".app-c-publisher-metadata__other dt", text: 'Collections:'
    assert_select ".app-c-publisher-metadata__other .app-c-publisher-metadata__definition-sentence", text: 'Tribunals statistics, and 2 others'
    assert_select ".app-c-publisher-metadata__other a", text: '+ show all'
    assert_select ".app-c-publisher-metadata__other a[href='/government/collections/tribunals-statistics']", text: 'Tribunals statistics'
    assert_select ".app-c-publisher-metadata__other a[href='/government/collections/civil-justice-statistics-quarterly']", text: 'Civil justice statistics quarterly'
    assert_select ".app-c-publisher-metadata__other a[href='/government/collections/offender-management-statistics-quarterly']", text: 'Offender management statistics quarterly'
  end
end
