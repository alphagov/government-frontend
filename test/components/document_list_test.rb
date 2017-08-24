require 'component_test_helper'

class DocumentListTest < ComponentTestCase
  def component_name
    "document-list"
  end

  test "renders nothing when no parameters are given" do
    assert_empty render_component({})
  end

  test "renders nothing when an empty array is passed in" do
    assert_empty render_component(items: [])
  end

  test "renders a document list correctly" do
    render_component(
      items: [
        {
          link: {
            text: "School behaviour and attendance: parental responsibility measures",
            path: "/government/publications/parental-responsibility-measures-for-behaviour-and-attendance"
          },
          metadata: {
            public_updated_at: Time.zone.parse("2017-01-05 14:50:33 +0000"),
            document_type: "statutory_guidance"
          }
        },
        {
          link: {
            text: "School exclusion",
            path: "/government/publications/school-exclusion"
          },
          metadata: {
            public_updated_at: Time.zone.parse("2017-07-19 15:01:48 +0000"),
            document_type: "statutory_guidance"
          }
        }
      ]
    )
    li = ".app-c-document-list__item-title"
    attribute = ".app-c-document-list__attribute"

    assert_select "#{li} a[href='/government/publications/parental-responsibility-measures-for-behaviour-and-attendance']", text: "School behaviour and attendance: parental responsibility measures"
    assert_select "#{attribute} time[datetime='2017-01-05T14:50:33+00:00']", text: "5 January 2017"
    assert_select attribute.to_s, text: "Statutory guidance"

    assert_select "#{li} a[href='/government/publications/school-exclusion']", text: "School exclusion"
    assert_select "#{attribute} time[datetime='2017-07-19T16:01:48+01:00']", text: "19 July 2017"
  end

  test "renders a document list with link tracking" do
    render_component(
      items: [
        {
          link: {
            text: "Link 1",
            path: "/link1",
            data_attributes: {
              track_category: "navDocumentCollectionLinkClicked",
              track_action: "1.1",
              track_label: "/link1",
              track_options: {
                dimension28: "2",
                dimension29: "Link 1"
              }
            }
          },
          metadata: {
            public_updated_at: Time.zone.parse("2017-01-05 14:50:33 +0000"),
            document_type: "statutory_guidance"
          }
        },
        {
          link: {
            text: "Link 2",
            path: "/link2",
            data_attributes: {
              track_category: "navDocumentCollectionLinkClicked",
              track_action: "1.2",
              track_label: "/link2",
              track_options: {
                dimension28: "2",
                dimension29: "Link 2"
              }
            }
          },
          metadata: {
            public_updated_at: Time.zone.parse("2017-07-19 15:01:48 +0000"),
            document_type: "statutory_guidance"
          }
        }
      ]
    )
    li = ".app-c-document-list__item-title"

    assert_select "#{li} a[href='/link1']", text: "Link 1"
    assert_select "#{li} a[data-track-category='navDocumentCollectionLinkClicked']", text: "Link 1"
    assert_select "#{li} a[data-track-action='1.1']", text: "Link 1"
    assert_select "#{li} a[data-track-label='/link1']", text: "Link 1"
    assert_select "#{li} a[data-track-options='{\"dimension28\":\"2\",\"dimension29\":\"Link 1\"}']", text: "Link 1"

    assert_select "#{li} a[href='/link2']", text: "Link 2"
    assert_select "#{li} a[data-track-category='navDocumentCollectionLinkClicked']", text: "Link 2"
    assert_select "#{li} a[data-track-action='1.2']", text: "Link 2"
    assert_select "#{li} a[data-track-label='/link2']", text: "Link 2"
    assert_select "#{li} a[data-track-options='{\"dimension28\":\"2\",\"dimension29\":\"Link 2\"}']", text: "Link 2"
  end
end
