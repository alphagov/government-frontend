require 'rest-client'
require "#{Rails.root}/lib/helpers/wraith_config_helper.rb"

namespace :wraith do
  desc "check top 10 content items for document_type using wraith"
  task :document_type, [:document_type] do |_t, args|
    document_type = args[:document_type]
    paths = get_paths(document_type)
    wraith_config_file = WraithConfigHelper.new(document_type, paths).create_config

    exec("bundle exec wraith capture #{wraith_config_file}")
  end

  desc "check top 10 content items for all known document types"
  task :all_document_types do
    paths = {}
    document_types = %w(case_study about)

    document_types.each do |type|
      paths[type] = get_paths(type)
    end

    wraith_config_file = WraithConfigHelper.new("all-document-types", paths).create_config

    exec("bundle exec wraith capture #{wraith_config_file}")
  end
end

def get_paths(document_type)
  search = RestClient.get "https://www.gov.uk/api/search.json?filter_content_store_document_type=#{document_type}&count=10"
  JSON.parse(search.body)["results"].map { |result| result["link"] }
end
