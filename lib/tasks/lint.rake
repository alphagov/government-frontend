desc "run ruby and sass linters"
task :lint do
  if ENV["JENKINS"]
    sh "govuk-lint-ruby --format html --out rubocop-${GIT_COMMIT}.html --format clang Gemfile app test config"
  else
    sh "govuk-lint-ruby --format clang Gemfile app test config"
  end
  sh "govuk-lint-sass app"
end

Rake::Task[:default].enhance [:lint]
