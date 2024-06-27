# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new
rescue LoadError
  # RSpec not available in all environments
end

require File.expand_path("config/application", __dir__)

Rails.application.load_tasks

Rake::Task[:default].clear if Rake::Task.task_defined?(:default)
task default: %i[lint spec jasmine]
