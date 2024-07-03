RSpec.describe("Locales Validation", type: :model) do
  around(:example) do |ex|
    original_stdout = $stdout
    $stdout = File.open(File::NULL, "w")
    ex.run
    $stdout = original_stdout
  end

  it "validates all locale files" do
    checker = RailsTranslationManager::LocaleChecker.new("config/locales/*.yml")

    expect(checker.validate_locales).to be true
  end
end
