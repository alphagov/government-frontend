require "test_helper"

class SpeechTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item("speech")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("These subjects are of course crucial. But in the UK, only 1 woman to every 7 men works in science, technology, engineering and maths. We need to get more girls interested and excited about STEM subjects.")
  end

  test "translated speech" do
    setup_and_visit_content_item("speech-translated")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_css?(".gem-c-translation-nav")
  end

  test "renders metadata and document footer, including speaker" do
    setup_and_visit_content_item("speech")

    assert_has_publisher_metadata(
      published: "Published 8 March 2016",
      metadata: {
        "From": {
          "Department of Energy & Climate Change and The Rt Hon Andrea Leadsom MP": nil,
          "Department of Energy": "/government/organisations/department-of-energy-climate-change",
          "The Rt Hon Andrea Leadsom MP": "/government/people/andrea-leadsom",
        },
      }
    )

    assert_has_important_metadata(
      "Delivered on":
        "2 February 2016 (Original script, may differ from delivered version)",
      "Location":
        "Women in Nuclear UK Conference, Church House Conference Centre, Dean's Yard, Westminster, London"
    )

    assert_footer_has_published_dates("Published 8 March 2016")
  end
end
