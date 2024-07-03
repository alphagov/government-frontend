RSpec.describe(StatisticsAnnouncementHelper, type: :view) do
  include StatisticsAnnouncementHelper

  describe "#on_in_between_for_release_date" do
    it "returns 'on' if the date is an exact format" do
      expect(on_in_between_for_release_date("10 January 2017 9:30am")).to eq("on 10 January 2017 9:30am")
      expect(on_in_between_for_release_date("1 December 2010 11:30pm")).to eq("on 1 December 2010 11:30pm")
      expect(on_in_between_for_release_date("18 March 2020 1:30PM")).to eq("on 18 March 2020 1:30PM")
    end

    it "returns 'in' if the date is a one month format" do
      expect(on_in_between_for_release_date("January 2018")).to eq("in January 2018")
    end

    it "returns 'between' and replaces 'to' with 'and' if the date is a two month format" do
      expect(on_in_between_for_release_date("March to April 2018")).to eq("between March and April 2018")
    end

    it "returns the passed in string if it doesn't match any format" do
      expect(on_in_between_for_release_date("some or other unexpected date format")).to eq("some or other unexpected date format")
    end
  end
end
