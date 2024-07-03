require "gds_api/test_helpers/content_store"

module ContentItemSystemHelpers
  include GdsApi::TestHelpers::ContentStore

  # System tests that rely on the methods in this module must be named
  # after the schema type they represent (in such a way that they'll
  # be translated into lower snake case, ie Answer -> answer,
  # TravelAdvice -> travel_advice)
  def schema_type
    self.class.description.to_s.underscore
  end

  def setup_and_visit_content_item(name, overrides = {}, parameter_string = "")
    get_content_example(name).tap do |item|
      content_item = item.deep_merge(overrides)
      setup_and_visit_content_item_by_example(content_item, parameter_string)
    end
  end

  def setup_and_visit_content_item_by_example(content_item, parameter_string = "")
    stub_content_store_has_item(content_item["base_path"], content_item.to_json)
    visit_with_cachebust("#{content_item['base_path']}#{parameter_string}")
  end

  def setup_and_visit_random_content_item(document_type: nil)
    content_item = GovukSchemas::RandomExample.for_schema(frontend_schema: schema_type) do |payload|
      payload.merge!("document_type" => document_type) unless document_type.nil?
      payload
    end

    path = content_item["base_path"]

    if schema_type == "html_publication"
      parent = content_item.dig("links", "parent")&.first
      if parent
        parent_path = parent["base_path"]
        stub_request(:get, %r{#{parent_path}})
          .to_return(status: 200, body: content_item.to_json, headers: {})
      end
    end

    stub_request(:get, %r{#{path}})
      .to_return(status: 200, body: content_item.to_json, headers: {})

    visit path

    content_item
  end

  def visit_with_cachebust(visit_uri)
    uri = Addressable::URI.parse(visit_uri)
    uri.query_values = uri.query_values.yield_self { |values| (values || {}).merge(cachebust: rand) }

    visit(uri)
  end

  def find_structured_data(page, schema_name)
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    schemas.detect { |schema| schema["@type"] == schema_name }
  end

  def get_content_example(name)
    get_content_example_by_schema_and_name(schema_type, name)
  end

  def get_content_example_by_schema_and_name(schema_type, name)
    GovukSchemas::Example.find(schema_type, example_name: name)
  end
end
