require 'presenter_test_helper'

class TopicalEventAboutPagePresenterTest < PresenterTestCase
  def schema_name
    "topical_event_about_page"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['schema_name'], presented_item.schema_name
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['details']['body'], presented_item.body
  end

  test 'presents a list of contents extracted from headings in the body' do
    assert_equal [
        { text: "Response in the UK", id: "response-in-the-uk", href: "#response-in-the-uk" },
        { text: "Response in Africa", id: "response-in-africa", href: "#response-in-africa" },
        { text: "Advice for travellers", id: "advice-for-travellers", href: "#advice-for-travellers" },
        { text: "Advice for medics", id: "advice-for-medics", href: "#advice-for-medics" },
        { text: "Advice for aid workers", id: "advice-for-aid-workers", href: "#advice-for-aid-workers" },
        { text: "How you can help", id: "how-you-can-help", href: "#how-you-can-help" },
      ], presented_item.contents
  end

  test 'presents no contents when no headings in the body' do
    assert_equal [], presented_item('slim').contents
  end
end
