require 'pry'
require 'rest-client'

desc "check format in wraith."
task :wraith_format, [:format] do |t, args|
  format = args[:format]
  wraith = YAML::load(File.open('test/wraith/config.yaml'))
  search = RestClient.get "https://www.gov.uk/api/search.json?filter_content_store_document_type=#{format}&count=10"
  links  = JSON.parse(search.body)["results"].map { |result| result["link"] }
  file_name = "test/wraith/wip-config-#{format}.yaml"
  wraith["paths"] = {}

  links.each_with_index { |link, index| wraith["paths"]["#{format}#{index}"] = link }
  File.open(file_name, 'w') { |f| f.write wraith.to_yaml }
  exec("bundle exec wraith capture #{file_name}")
end

