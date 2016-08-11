require 'rake/testtask'

namespace :test do
  Rake::TestTask.new(presenters: "test:prepare") do |t|
    t.pattern = "test/presenters/**/*_test.rb"
  end
end

Rake::Task["test:run"].enhance ["test:presenters"]
