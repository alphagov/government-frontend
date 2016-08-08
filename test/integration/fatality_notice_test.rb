require 'test_helper'

class FatalityNoticeTest < ActionDispatch::IntegrationTest
  test 'page renders' do
    setup_and_visit_content_item('fatality_notice')
    assert page.has_css?('.fatality-notice'), 'should render with format class'

    assert_has_component_title(
      'Sir George Pomeroy Colley killed in Boer War',
      'Operations in Zululand'
    )

    assert_has_component_document_footer_pair('updated', '17 May 1881')
  end

  test 'page renders Field of Operation in metadata' do
    setup_and_visit_content_item('fatality_notice')
    assert_has_component_metadata_pair(
      'Field of operation',
      ['<a href="/government/fields-of-operation/zululand">Zululand</a>']
    )
  end

  test 'page renders MOD Crest' do
    setup_and_visit_content_item('fatality_notice')
    within '.sidebar-image' do
      assert(
        page.has_css?('img[src*="mod-crest"]'),
        'image in sidebar should have correct path'
      )
    end
  end
end
