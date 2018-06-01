require 'test_helper'

class FatalityNoticeTest < ActionDispatch::IntegrationTest
  test "typical fatality notice" do
    setup_and_visit_content_item('fatality_notice')

    assert_has_component_government_navigation_active("announcements")

    assert page.has_title?(
      "Sir George Pomeroy Colley killed in Boer War - Fatality notice - GOV.UK"
    )

    assert page.has_css?(
      "meta[name='description'][content='It is with great sadness that the Ministry of Defence must confirm that Sir George Pomeroy Colley, died in battle in Zululand on 27 February 1881.']",
      visible: false
    )
    assert page.has_content?("Operations in Zululand")
    assert_has_component_title("Sir George Pomeroy Colley killed in Boer War")

    refute page.has_css?(".app-c-notice")

    assert_has_publisher_metadata(
      published: "Published 27 February 1881",
      last_updated: "Last updated 14 September 2016",
      history_link: true,
      metadata: {
        "From": { "Ministry of Defence": "/government/organisations/ministry-of-defence" }
      }
    )

    assert_has_important_metadata(
      "Field of operation": { "Zululand": "/government/fields-of-operation/zululand" }
    )

    assert page.has_content?("It is with great sadness that the Ministry of Defence must confirm that Sir George Pomeroy Colley, died in battle")

    assert(
      page.has_css?("img[src*=ministry-of-defence-crest][alt='Ministry of Defence crest']"),
      'should have image with ministry-of-defence source with alt text'
    )

    assert_has_component_govspeak "<div class=\"govspeak\"><h2 id=\"sir-george-pomeroy-colley\">Sir George Pomeroy Colley</h2><figure class=\"image embedded\"> <div class=\"img\"><img alt=\"Photograph of Sir George Pomeroy Colley posed standing\" src=\"https://assets-origin.integration.publishing.service.gov.uk/government/uploads/system/uploads/image_data/file/56271/colley.jpg\"></div> <figcaption>Sir George Pomeroy Colley (All rights reserved.)</figcaption></figure><p>Colley served nearly all of his military and administrative career in British South Africa, but he played a significant part in the Second Anglo-Afghan War as military secretary and then private secretary to the governor-general of India, Lord Lytton. The war began in November 1878 and ended in May 1879 with the Treaty of Gandamak.</p><p>After the war Colley returned to South Africa, became high commissioner for South Eastern Africa in 1880… and died a year later at the Battle of Majuba Hill during the First Boer War.</p><p>A british officer had the following to say</p><blockquote> <p class=\"last-child\">Major General Colley was an exceptional talent, and it is with great sadness that we have learned about this loss. His contribution to Britain through his efforts in the Boer War will not be forgotten.</p></blockquote></div>"

    within(".content-bottom-margin .app-c-published-dates") do
      assert page.has_content?("Published 27 February 1881")
      assert page.has_content?("Last updated 14 September 2016")
      assert page.has_link?("show all updates", href: "#full-history")

      within(".app-c-published-dates__change-history") do
        within(".app-c-published-dates__change-item:first-child") do
          assert page.has_content?("14 September 2016 Updated information.")
        end

        within(".app-c-published-dates__change-item:last-child") do
          assert page.has_content?("27 February 1881 First published.")
        end
      end
    end
  end

  test "fatality notice with minister" do
    setup_and_visit_content_item('fatality_notice_with_minister')
    assert_has_publisher_metadata_other(
      "From": {
        "Ministry of Defence": "/government/organisations/ministry-of-defence",
        "The Rt Hon Sir Eric Pickles MP": "/government/people/eric-pickles",
      }
    )
  end

  test "fatality notice with withdrawn notice" do
    setup_and_visit_content_item('withdrawn_fatality_notice')

    assert page.has_title?(
      "[Withdrawn] Sir George Pomeroy Colley killed in Boer War - Fatality notice - GOV.UK"
    )

    within ".app-c-notice" do
      assert_text("This fatality notice was withdrawn on 14 September 2016")

      assert_has_component_govspeak(
        "<div class=\"govspeak\"><p>This content is not factually correct. For current information please go to <a rel=\"external\" href=\"https://en.wikipedia.org/wiki/George_Pomeroy_Colley\">https://en.wikipedia.org/wiki/George_Pomeroy_Colley</a></p></div>"
      )
    end
  end
end
