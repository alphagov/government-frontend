require 'rest-client'

desc "check top 10 content items for document_type using wraith"
task :wraith_document_type, [:document_type] do |_t, args|
  document_type = args[:document_type]

  paths = get_paths(document_type)

  file_name = create_config_file(document_type, paths)

  exec("bundle exec wraith capture #{file_name}")
end

def create_config_file(run_name, paths)
  file_name = "test/wraith/wip-config-#{run_name}.yaml"
  wraith = YAML::load(File.open('test/wraith/config.yaml'))
  wraith["paths"] = {}

  paths.each_with_index { |path, index| wraith["paths"]["#{run_name}#{index}"] = path }

  File.open(file_name, 'w') { |f| f.write wraith.to_yaml }
  file_name
end

def get_paths(document_type)
  search = RestClient.get "https://www.gov.uk/api/search.json?filter_content_store_document_type=#{document_type}&count=10"
  JSON.parse(search.body)["results"].map { |result| result["link"] }
end
