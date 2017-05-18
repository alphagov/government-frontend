require 'rest-client'

class DocumentTypesHelper
  ALL_SEARCH_ENDPOINT = "https://www.gov.uk/api/search.json?facet_content_store_document_type=100,example_scope:global,examples:%{sample_size}&filter_rendering_app=government-frontend&count=0".freeze
  SINGLE_SEARCH_ENDPOINT = "https://www.gov.uk/api/search.json?filter_content_store_document_type=%{document_type}&count=%{sample_size}".freeze

  def initialize(sample_size = 10)
    @sample_size = sample_size
  end

  def all_type_paths
    response = RestClient.get(ALL_SEARCH_ENDPOINT % { sample_size: @sample_size })
    results = extract_results(JSON.parse(response.body))
    results.map { |result| extract_type(result) }.reduce({}, :merge)
  end

  def type_paths(type)
    response = RestClient.get(SINGLE_SEARCH_ENDPOINT % { document_type: type, sample_size: @sample_size })
    JSON.parse(response.body)["results"].map { |result| result["link"] }
  end

private

  def extract_results(response_body)
    response_body["facets"]["content_store_document_type"]["options"]
  end

  def extract_type(result)
    type_examples = result["value"]["example_info"]["examples"].map { |example| example["link"] }
    { result["value"]["slug"] => type_examples }
  end
end
