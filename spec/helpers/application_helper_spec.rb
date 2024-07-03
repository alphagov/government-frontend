RSpec.describe(ApplicationHelper, type: :view) do
  include ApplicationHelper

  describe "#current_path_without_query_string" do
    it "returns the path of the current request" do
      allow(self).to receive(:request).and_return(ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar"))

      expect(current_path_without_query_string).to eq("/foo/bar")
    end

    it "returns the path of the current request stripping off any query string parameters" do
      allow(self).to receive(:request).and_return(ActionDispatch::TestRequest.create("PATH_INFO" => "/foo/bar", "QUERY_STRING" => "ham=jam&spam=gram"))

      expect(current_path_without_query_string).to eq("/foo/bar")
    end
  end

  describe "#t_locale_fallback" do
    it "returns nil for a string with a locale translation" do
      fallback = t_locale_fallback("content_item.schema_name.imported", :count => 1, :locale => :de)

      expect(fallback).to be_nil
    end

    it "returns default locale for a string with no locale translation" do
      allow(I18n).to receive(:t).and_return("translation missing: en.some_missing.key")
      I18n.with_locale(:de) do
        fallback = t_locale_fallback("some_missing.key", :count => 1, :locale => :fake)

        expect(fallback).to eq(:en)
      end
    end

    it "returns fallback for irrelevant key" do
      I18n.with_locale(:de) do
        fallback = t_locale_fallback("blah", :count => 1)

        expect(fallback).to eq(:en)
      end
    end
  end
end
