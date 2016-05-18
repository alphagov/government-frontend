require 'presenter_test_helper'

class DocumentCollectionPresenterTest < PresenterTest
  def format_name
    "document_collection"
  end

  test 'presents the basic details of a content item' do
    assert_equal schema_item['description'], presented_item.description
    assert_equal schema_item['format'], presented_item.format
    assert_equal schema_item['title'], presented_item.title
  end

  test 'presents a contents list based on collection groups' do
    contents = [
      "<a href=\"#car-and-light-van\">Car and light van</a>",
      "<a href=\"#moped-and-motorcycle\">Moped and motorcycle</a>",
      "<a href=\"#lorry\">Lorry</a>",
      "<a href=\"#bus-and-coach\">Bus and coach</a>",
      "<a href=\"#driver-and-rider-trainer\">Driver and rider trainer</a>",
      "<a href=\"#developed-driving-competence\">Developed driving competence</a>"
    ]

    assert_equal contents, presented_item.contents
  end

  test 'presents a group heading with generated ID' do
    heading = '<h3 class="group-title" id="heading-with-spaces">Heading with Spaces</h3>'
    assert_equal heading, presented_item.group_heading("title" => "Heading with Spaces")
  end

  test 'presents an ordered list of group documents' do
    documents = [
      "<a href=\"/government/publications/national-standard-for-driving-cars-and-light-vans\">National standard for driving cars and light vans</a>",
      "<a href=\"/government/publications/car-and-small-van-driving-syllabus\">Car and light van driving syllabus</a>",
      "<a href=\"/government/publications/car-and-light-van-driver-competence-framework\">Car and light van driver competence framework</a>",
    ]
    document_ids = schema_item["details"]["collection_groups"].first["documents"]
    assert_equal documents, presented_item.group_document_links("documents" => document_ids)
  end
end
