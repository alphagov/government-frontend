require 'component_test_helper'

class RelatedNavigationTest < ComponentTestCase
  def component_name
    "related-navigation"
  end

  test "renders nothing when no parameters given" do
    assert_empty render_component({})
  end

  test "renders related content section when passed related items" do
    render_component(
      related_items: [
        {
          text: "Apprenticeships",
          path: '/apprenticeships'
        }
      ]
    )

    assert_select ".app-c-related-navigation__main-heading", text: 'Related content'
    assert_select ".app-c-related-navigation__section-link--other[href=\"/apprenticeships\"]", text: 'Apprenticeships'
  end

  test "renders topics section when passed topic items" do
    render_component(
      topics: [
        {
          text: "Finding a job",
          path: '/finding-a-job'
        }
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading", text: 'Explore the topic'
    assert_select ".app-c-related-navigation__section-link[href=\"/finding-a-job\"]", text: 'Finding a job'
  end

  test "renders statistical data set section when passed statistical data set items" do
    render_component(
      statistical_data_sets: [
        {
          text: "Air quality statistics",
          path: '/air-quality-statistics'
        }
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading", text: 'Statistical data set'
    assert_select ".app-c-related-navigation__section-link[href=\"/air-quality-statistics\"]", text: 'Air quality statistics'
  end


  test "renders world locations section when passed world location items" do
    render_component(
      world_locations: [
        {
          text: "USA",
          path: '/world/usa/news'
        }
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading", text: 'Location'
    assert_select ".app-c-related-navigation__section-link[href=\"/world/usa/news\"]", text: 'USA'
  end

  test "renders publisher section when passed publisher items" do
    render_component(
      publishers: [
        {
          text: "Department for Education",
          path: '/government/organisation/department-for-education'
        }
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading", text: 'Published by'
    assert_select ".app-c-related-navigation__section-link[href=\"/government/organisation/department-for-education\"]", text: 'Department for Education'
  end

  test "renders collection section when passed collection items" do
    render_component(
      collections: [
        {
          text: "The future of jobs and skills",
          path: '/government/collections/the-future-of-jobs-and-skills'
        }
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading", text: 'Collection'
    assert_select ".app-c-related-navigation__section-link[href=\"/government/collections/the-future-of-jobs-and-skills\"]", text: 'The future of jobs and skills'
  end

  test "renders policy section when passed policy items" do
    render_component(
      policies: [
        {
          text: "Further education and training",
          path: '/government/policies/further-education-and-training'
        }
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading", text: 'Policy'
    assert_select ".app-c-related-navigation__section-link[href=\"/government/policies/further-education-and-training\"]", text: 'Further education and training'
  end

  test "renders topical events section when passed topical event items" do
    render_component(
      topical_events: [
        {
          text: "UK-China High-Level People to People Dialogue 2017",
          path: '/government/topical-events/uk-china-high-level-people-to-people-dialogue-2017'
        }
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading", text: 'Topical event'
    assert_select ".app-c-related-navigation__section-link[href=\"/government/topical-events/uk-china-high-level-people-to-people-dialogue-2017\"]", text: 'UK-China High-Level People to People Dialogue 2017'
  end

  test "renders other links section when passed external related links" do
    render_component(
      other: [
        [
          {
            title: "Elsewhere on the web",
            links: [{
              text: "The Student Room repaying your student loan",
              path: 'https://www.thestudentroom.co.uk/content.php?r=5967-Repaying-your-student-loan'
            }]
          }
        ]
      ]
    )

    assert_select ".app-c-related-navigation__sub-heading--other", text: 'Elsewhere on the web'
    assert_select ".app-c-related-navigation__section-link--other[href=\"https://www.thestudentroom.co.uk/content.php?r=5967-Repaying-your-student-loan\"]", text: 'The Student Room repaying your student loan'
  end

  test "renders external links with rel=external" do
    render_component(
      policies: [
        {
          text: "Further education and training",
          path: '/government/policies/further-education-and-training',
          rel: "external"
        }
      ]
    )

    assert_select ".app-c-related-navigation__section-link[rel=\"external\"]"
  end

  test "adds aria labelledby to navigation sections" do
    render_component(
      topics: [
        {
          text: "Apprenticeships",
          path: '/apprenticeships'
        }
      ]
    )

    assert_select ".app-c-related-navigation__nav-section[aria-labelledby]"
  end

  test "adds a show more toggle link to long sections" do
    render_component(
      world_locations: [
        {
          text: 'USA',
          path: '/usa'
        },
        {
          text: 'Wales',
          path: '/wales'
        },
        {
          text: 'Fiji',
          path: '/fiji'
        },
        {
          text: 'Iceland',
          path: '/iceland'
        },
        {
          text: 'Sweden',
          path: '/sweden'
        },
        {
          text: 'Mauritius',
          path: '/mauritius'
        }
      ]
    )

    assert_select ".app-c-related-navigation__section-link[href=\"/wales\"]", text: 'Wales'
    assert_select ".app-c-related-navigation__link.toggle-wrap", text: '+ 1 more'
    assert_select "#toggle_world_locations .app-c-related-navigation__section-link[href=\"/mauritius\"]", text: 'Mauritius'
  end

  test "renders multiple items when passed data for multiple sections" do
    render_component(
      related_items: [
        {
          text: "Apprenticeships",
          path: '/apprenticeships'
        }
      ],
      policies: [
        {
          text: "Further education and training",
          path: '/government/policies/further-education-and-training'
        }
      ]
    )

    assert_select ".app-c-related-navigation__main-heading", text: 'Related content'
    assert_select ".app-c-related-navigation__section-link--other[href=\"/apprenticeships\"]", text: 'Apprenticeships'

    assert_select ".app-c-related-navigation__sub-heading", text: 'Policy'
    assert_select ".app-c-related-navigation__section-link[href=\"/government/policies/further-education-and-training\"]", text: 'Further education and training'
  end

  test "link tracking is enabled" do
    render_component(
      topics: [
        {
          text: "Apprenticeships",
          path: '/apprenticeships'
        }
      ]
    )

    assert_select ".app-c-related-navigation__nav-section ul[data-module='track-click']"
  end
end
