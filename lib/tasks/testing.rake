namespace :test do
  desc "Runs contract tests"
  Rails::TestTask.new(contracts: "test:prepare") do |t|
    t.pattern = "test/contracts/**/*_test.rb"
  end
end

Rake::Task["test:run"].prerequisites << 'test:contracts'
Rake::Task[:test].comment = "Includes test:contracts"
