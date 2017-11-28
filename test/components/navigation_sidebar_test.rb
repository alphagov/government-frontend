require 'component_test_helper'

class NavigationSidebarTest < ComponentTestCase
  def component_name
    "navigation-sidebar"
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

    assert_select ".app-c-navigation-sidebar__main-heading", text: 'Related content'
    assert_select ".app-c-navigation-sidebar__related-link[href=\"/apprenticeships\"]", text: 'Apprenticeships'
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

    assert_select ".app-c-navigation-sidebar__sub-heading", text: 'Explore the topic'
    assert_select ".app-c-navigation-sidebar__section-link[href=\"/finding-a-job\"]", text: 'Finding a job'
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

    assert_select ".app-c-navigation-sidebar__sub-heading", text: 'Detailed guidance from'
    assert_select ".app-c-navigation-sidebar__section-link[href=\"/government/organisation/department-for-education\"]", text: 'Department for Education'
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

    assert_select ".app-c-navigation-sidebar__sub-heading", text: 'Collections'
    assert_select ".app-c-navigation-sidebar__section-link[href=\"/government/collections/the-future-of-jobs-and-skills\"]", text: 'The future of jobs and skills'
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

    assert_select ".app-c-navigation-sidebar__sub-heading", text: 'Policy'
    assert_select ".app-c-navigation-sidebar__section-link[href=\"/government/policies/further-education-and-training\"]", text: 'Further education and training'
  end

  test "renders external related links section when passed external related links" do
    render_component(
      external_links: [
        {
          text: "The Student Room repaying your student loan",
          path: 'https://www.thestudentroom.co.uk/content.php?r=5967-Repaying-your-student-loan'
        }
      ]
    )

    assert_select ".app-c-navigation-sidebar__sub-heading", text: 'Elsewhere on the web'
    assert_select ".app-c-navigation-sidebar__external-related-link[href=\"https://www.thestudentroom.co.uk/content.php?r=5967-Repaying-your-student-loan\"]", text: 'The Student Room repaying your student loan'
  end

  test "renders external links with rel=external" do
    render_component(
      external_links: [
        {
          text: "The Student Room repaying your student loan",
          path: 'https://www.thestudentroom.co.uk/content.php?r=5967-Repaying-your-student-loan'
        }
      ]
    )

    assert_select ".app-c-navigation-sidebar__external-related-link[rel=\"external\"]"
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

    assert_select ".app-c-navigation-sidebar__nav-section[aria-labelledby]"
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

    assert_select ".app-c-navigation-sidebar__main-heading", text: 'Related content'
    assert_select ".app-c-navigation-sidebar__related-link[href=\"/apprenticeships\"]", text: 'Apprenticeships'

    assert_select ".app-c-navigation-sidebar__sub-heading", text: 'Policy'
    assert_select ".app-c-navigation-sidebar__section-link[href=\"/government/policies/further-education-and-training\"]", text: 'Further education and training'
  end
end
