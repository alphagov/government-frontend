require "rest-client"
require Rails.root.join("lib/helpers/wraith_config_helper.rb")
require Rails.root.join("lib/helpers/document_types_helper.rb")

namespace :wraith do
  desc "check top 10 content items for document_type using wraith"
  task :document_type, [:document_type] => :environment do |_t, args|
    document_type = args[:document_type]
    document_type_paths = DocumentTypesHelper.new.type_paths(document_type)
    wraith_config_file = WraithConfigHelper.new(document_type, document_type_paths).create_config

    exec("bundle exec wraith capture #{wraith_config_file}")
  end

  desc "check top 10 content items for all known document types"
  task :all_document_types, [:sample_size] => :environment do |_t, args|
    args.with_defaults(sample_size: 10)
    # Make sure an up to date document_types file exists
    Rake::Task["wraith:update_document_types"].invoke args[:sample_size]
    wraith_config_file = "test/wraith/wip-config-all-document-types.yaml"

    exec("bundle exec wraith capture #{wraith_config_file}")
  end

  desc "creates a wraith config of document type examples from the search api"
  task :update_document_types, [:sample_size] => :environment do |_t, args|
    args.with_defaults(sample_size: 10)
    document_type_paths = DocumentTypesHelper.new(args[:sample_size]).all_type_paths
    document_types = { "document_types" => document_type_paths.keys }

    WraithConfigHelper.new("all-document-types", document_type_paths).create_config(document_types)
  end
end
