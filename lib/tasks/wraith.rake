require 'rest-client'
require "#{Rails.root}/lib/helpers/wraith_config_helper.rb"
require "#{Rails.root}/lib/helpers/document_types_helper.rb"

namespace :wraith do
  desc "check top 10 content items for document_type using wraith"
  task :document_type, [:document_type] do |_t, args|
    document_type = args[:document_type]
    document_type_paths = DocumentTypesHelper.new.type_paths(document_type)
    wraith_config_file = WraithConfigHelper.new(document_type, document_type_paths).create_config

    exec("bundle exec wraith capture #{wraith_config_file}")
  end

  desc "check top 10 content items for all known document types"
  task :all_document_types, [:sample_size] do |_t, args|
    args.with_defaults(sample_size: 10)
    config_file_name = generate_wip_config("all-document-types", document_type_paths(args[:sample_size]))
    run_wraith_with_config(config_file_name)
  end

  desc "creates a wraith config of document type examples from the search api"
  task :update_document_types, [:sample_size] do |_t, args|
    args.with_defaults(sample_size: 10)
    generate_wip_config("all-document-types", document_type_paths(args[:sample_size]))
  end

  desc "compare a pull request review deployment with production"
  task :pr, [:pr_number] do |_t, args|
    options = {}
    options["domains"] = {
      "local" => "https://government-frontend-pr-#{args[:pr_number]}.herokuapp.com"
    }

    config_file_name = generate_wip_config("pr-review", document_type_paths(2), options)
    run_wraith_with_config(config_file_name)
  end

  desc "compare master with production"
  task :master do
    options = {}
    options["domains"] = {
      "local" => "https://government-frontend.herokuapp.com"
    }

    config_file_name = generate_wip_config("pr-master", document_type_paths(2), options)
    run_wraith_with_config(config_file_name)
  end

  def generate_wip_config(name, paths, options = {})
    WraithConfigHelper.new(name, paths).create_config(options)
  end

  def document_type_paths(sample_size)
    DocumentTypesHelper.new(sample_size).all_type_paths
  end

  def run_wraith_with_config(file_name)
    puts "Running wraith with config file: #{file_name}"
    exec("bundle exec wraith capture #{file_name}")
  end
end
