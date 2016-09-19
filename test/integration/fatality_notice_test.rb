require 'test_helper'

class FatalityNoticeTest < ActionDispatch::IntegrationTest
  test "typical fatality notice" do
    setup_and_visit_content_item('fatality_notice')

    assert_component_parameter("title", "context", "Operations in Zululand")
    assert_has_component_title("Sir George Pomeroy Colley killed in Boer War")

    assert_has_component_metadata_pair(
      "from",
      ["<a href=\"/government/organisations/ministry-of-defence\">Ministry of Defence</a>"]
    )

    assert_has_component_metadata_pair(
      "Field of operation",
      "<a href=\"/government/fields-of-operation/zululand\">Zululand</a>"
    )

    assert_has_component_metadata_pair(
      "first_published",
      "27 February 1881"
    )

    assert_has_component_metadata_pair(
      "last_updated",
      "14 September 2016"
    )

    within(".description") do
      assert_text <<-DESCRIPTION
       It is with great sadness that the Ministry of Defense
       must confirm that Sir George Pomeroy Colley, died in battle
       in Zululand on 27 February 1881.
       DESCRIPTION
    end

    assert(
      page.has_css?("img[src*=mod-crest][alt='']"),
      'should have img with mod-crest src and empty alt text'
    )

    assert_has_component_govspeak "<div class=\"govspeak\"><h2 id=\"sir-george-pomeroy-colley\">Sir George Pomeroy Colley</h2><figure class=\"image embedded\"> <div class=\"img\"><img alt=\"Photograph of Sir George Pomeroy Colley posed standing\" src=\"https://assets-origin.integration.publishing.service.gov.uk/government/uploads/system/uploads/image_data/file/56271/colley.jpg\"></div> <figcaption>Sir George Pomeroy Colley (All rights reserved.)</figcaption></figure><p>Colley served nearly all of his military and administrative career in British South Africa, but he played a significant part in the Second Anglo-Afghan War as military secretary and then private secretary to the governor-general of India, Lord Lytton. The war began in November 1878 and ended in May 1879 with the Treaty of Gandamak.</p><p>After the war Colley returned to South Africa, became high commissioner for South Eastern Africa in 1880… and died a year later at the Battle of Majuba Hill during the First Boer War.</p><p>A british officer had the following to say</p><blockquote> <p class=\"last-child\">Major General Colley was an exceptional talent, and it is with great sadness that we have learned about this loss. His contribution to Britain through his efforts in the Boer War will not be forgotten.</p></blockquote></div>"

    assert_has_component_document_footer_pair "published", "27 February 1881"
    assert_has_component_document_footer_pair "updated", "14 September 2016"
    assert_has_component_document_footer_pair(
      "from",
      ["<a href=\"/government/organisations/ministry-of-defence\">Ministry of Defence</a>"]
    )
    assert_has_component_document_footer_pair(
      "history",
      [
        {
          "display_time" => "14 September 2016",
          "note" => "Updated information.",
          "timestamp" => "2016-09-14T18:19:27+01:00"
        },
        {
          "display_time" => "27 February 1881",
          "note" => "First published.",
          "timestamp" => "1881-02-27T15:45:44.000+00:00"
        }
      ]
    )
  end
end
