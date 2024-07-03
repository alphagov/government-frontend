RSpec.describe(RequestHelper, type: :model) do
  describe ".get_header" do
    it "returns nil when header does not exist" do
      header_val = RequestHelper.get_header("Govuk-Example-Header", {})

      expect(header_val).to(be_nil)
    end

    it "returns header when header exists" do
      header_val = RequestHelper.get_header("Govuk-Example-Header", "HTTP_GOVUK_EXAMPLE_HEADER" => "this_is_a_test")
      expect(header_val).to(eq("this_is_a_test"))
    end
  end

  describe ".headerise" do
    it "returns header with HTTP prefix, no dashes and all uppercase" do
      header_name = "Govuk-Example-Header"
      transformed_header_name = RequestHelper.headerise(header_name)

      expect(transformed_header_name).to(eq("HTTP_GOVUK_EXAMPLE_HEADER"))
    end
  end
end
