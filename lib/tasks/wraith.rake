require 'rest-client'

desc "check top 10 content items for document_type using wraith"
task :wraith_document_type, [:document_type] do |_t, args|
  document_type = args[:document_type]
  wraith = YAML::load(File.open('test/wraith/config.yaml'))
  search = RestClient.get "https://www.gov.uk/api/search.json?filter_content_store_document_type=#{document_type}&count=10"
  links  = JSON.parse(search.body)["results"].map { |result| result["link"] }
  file_name = "test/wraith/wip-config-#{document_type}.yaml"
  wraith["paths"] = {}

  links.each_with_index { |link, index| wraith["paths"]["#{document_type}#{index}"] = link }
  File.open(file_name, 'w') { |f| f.write wraith.to_yaml }
  exec("bundle exec wraith capture #{file_name}")
end
