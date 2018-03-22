require 'presenter_test_helper'

class DetailedGuidePresenterTest < PresenterTestCase
  def schema_name
    "detailed_guide"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['schema_name'], presented_item.schema_name
    assert_equal schema_item['title'], presented_item.title
    assert_equal schema_item['details']['body'], presented_item.body
  end

  test 'presents a list of contents extracted from headings in the body' do
    expected_contents_list_item = { text: "The basics", id: "the-basics", href: "#the-basics" }
    assert_equal expected_contents_list_item, presented_item.contents[0]
  end

  test '#published returns a formatted date of the day the content item became public' do
    assert_equal '12 June 2014', presented_item.published
  end

  test 'breadcrumbs show the full parent hierarchy' do
    assert_equal "Home", presented_item.breadcrumbs[0][:title]
    assert_equal "/", presented_item.breadcrumbs[0][:url]
    assert_equal "Business tax", presented_item.breadcrumbs[1][:title]
    assert_equal "/topic/business-tax", presented_item.breadcrumbs[1][:url]
    assert_equal "PAYE", presented_item.breadcrumbs[2][:title]
    assert_equal "/topic/business-tax/paye", presented_item.breadcrumbs[2][:url]
  end

  test 'the "home" link shows if there is no parent' do
    assert_equal [{ title: "Home", url: "/" }], presented_item("withdrawn_detailed_guide").breadcrumbs
  end

  test 'presents withdrawn notices' do
    example = schema_item("withdrawn_detailed_guide")
    presented = presented_item("withdrawn_detailed_guide")

    assert example.include?("withdrawn_notice")
    assert presented.withdrawn?
    assert_equal example["withdrawn_notice"]["explanation"], presented.withdrawal_notice_component[:description_govspeak]
    assert_equal '<time datetime="2015-01-28T13:05:30Z">28 January 2015</time>', presented.withdrawal_notice_component[:time]
  end

  test 'presents the title of the publishing government' do
    assert_equal schema_item["details"]["government"]["title"], presented_item.publishing_government
  end

  test 'presents related detailed guides' do
    related_guides = [{
      text: 'Offshore wind: part of the UK\'s energy mix',
      path: '/guidance/offshore-wind-part-of-the-uks-energy-mix',
    }]
    assert_equal(related_guides, presented_item("political_detailed_guide").related_navigation[:related_guides])
  end

  test 'presents related mainstream content' do
    related_mainstream_content = [
      { text: 'Overseas British passport applications', path: '/overseas-passports' },
      { text: 'Cancel a lost or stolen passport', path: '/report-a-lost-or-stolen-passport' }
    ]
    assert_equal related_mainstream_content,
      presented_item("related_mainstream_detailed_guide").related_navigation[:related_items]
  end

  test 'content can be historically political' do
    example = schema_item("political_detailed_guide")
    presented = presented_item("political_detailed_guide")

    refute example["details"]["government"]["current"]
    assert example["details"]["political"]

    assert presented.historically_political?
  end

  test 'content can apply only to a set of nations' do
    example = schema_item('national_applicability_detailed_guide')
    presented = presented_item('national_applicability_detailed_guide')

    assert example['details'].include?('national_applicability')
    assert_equal presented.applies_to, 'England'
  end

  test 'content can apply only to a set of nations with alternative urls' do
    example = schema_item('national_applicability_alternative_url_detailed_guide')
    presented = presented_item('national_applicability_alternative_url_detailed_guide')

    assert example['details'].include?('national_applicability')
    assert_equal presented.applies_to, 'England, Scotland, and Wales (see guidance for <a rel="external" href="http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for">Northern Ireland</a>)'
  end

  test 'context in title is overridden to display as guidance' do
    I18n.with_locale("fr") do
      assert_equal I18n.t("content_item.schema_name.guidance", count: 1), presented_item.title_and_context[:context]
    end
  end

  test 'eu structural fund logo is presented where applicable' do
    presented = presented_item('england-2014-to-2020-european-structural-and-investment-funds')

    expected = {
      alt_text: 'European structural investment funds',
      path: 'https://assets.publishing.service.gov.uk/media/5540ab8aed915d15d8000030/european-structural-investment-funds.png'
    }
    assert_equal presented.logo, expected
  end
end
