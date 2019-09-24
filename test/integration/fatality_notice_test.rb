require "test_helper"

class FatalityNoticeTest < ActionDispatch::IntegrationTest
  test "typical fatality notice" do
    setup_and_visit_content_item("fatality_notice")

    assert_has_component_government_navigation_active("News and communications")

    assert page.has_title?(
      "Sir George Pomeroy Colley killed in Boer War - Fatality notice - GOV.UK",
    )

    assert page.has_css?(
      "meta[name='description'][content='It is with great sadness that the Ministry of Defence must confirm that Sir George Pomeroy Colley, died in battle in Zululand on 27 February 1881.']",
      visible: false,
    )

    assert page.has_content?("Operations in Zululand")
    assert_has_component_title("Sir George Pomeroy Colley killed in Boer War")

    refute page.has_css?(".gem-c-notice")

    assert_has_publisher_metadata(
      published: "Published 27 February 1881",
      last_updated: "Last updated 14 September 2016",
      history_link: true,
      metadata: {
        "From": { "Ministry of Defence": "/government/organisations/ministry-of-defence" },
      },
    )

    assert_has_important_metadata(
      "Field of operation": { "Zululand": "/government/fields-of-operation/zululand" },
    )

    assert page.has_content?("It is with great sadness that the Ministry of Defence must confirm that Sir George Pomeroy Colley, died in battle")

    assert(
      page.has_css?("img[src*=ministry-of-defence-crest][alt='Ministry of Defence crest']"),
      "should have image with ministry-of-defence source with alt text",
    )

    assert page.has_text?("Colley served nearly all of his military and administrative career in British South Africa, but he played a significant part in the Second Anglo-Afghan War as military secretary and then private secretary to the governor-general of India, Lord Lytton. The war began in November 1878 and ended in May 1879 with the Treaty of Gandamak.")

    within(".content-bottom-margin .app-c-published-dates") do
      assert page.has_content?("Published 27 February 1881")
      assert page.has_content?("Last updated 14 September 2016")

      within(".app-c-published-dates__change-history") do
        within(".app-c-published-dates__change-item:first-child") do
          assert page.has_content?(:all, "14 September 2016 Updated information.")
        end

        within(".app-c-published-dates__change-item:last-child") do
          assert page.has_content?(:all, "27 February 1881 First published.")
        end
      end
    end
  end

  test "fatality notice with minister" do
    setup_and_visit_content_item("fatality_notice_with_minister")
    assert_has_publisher_metadata_other(
      "From": {
        "Ministry of Defence": "/government/organisations/ministry-of-defence",
        "The Rt Hon Sir Eric Pickles MP": "/government/people/eric-pickles",
      },
    )
  end

  test "fatality notice with withdrawn notice" do
    setup_and_visit_content_item("withdrawn_fatality_notice")

    assert page.has_title?(
      "[Withdrawn] Sir George Pomeroy Colley killed in Boer War - Fatality notice - GOV.UK",
    )

    within ".gem-c-notice" do
      assert_text("This fatality notice was withdrawn on 14 September 2016")

      assert page.has_text?("This content is not factually correct. For current information please go to")
    end
  end
end
