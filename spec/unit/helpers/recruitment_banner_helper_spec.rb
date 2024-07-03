RSpec.describe(RecruitmentBannerHelper, type: :view) do
  include RecruitmentBannerHelper

  before do
    @recruitment_banners_data = YAML.load_file(Rails.root.join("spec/fixtures/recruitment_banners.yml"))
  end

  def request
    OpenStruct.new(path: "/")
  end

  def recruitment_banners
    @recruitment_banners_data["banners"]
  end

  it "returns banners that include the current url" do
    actual_banners = recruitment_banner
    expected_banners = { "name" => "Banner 1", "suggestion_text" => "Help improve GOV.UK", "suggestion_link_text" => "Take part in user research", "survey_url" => "https://google.com", "page_paths" => ["/"] }

    expect(actual_banners).to eq(expected_banners)
  end

  it "has valid yaml structure" do
    @recruitment_banners_data = YAML.load_file(Rails.root.join("lib/data/recruitment_banners.yml"))
    if @recruitment_banners_data["banners"].present?
      recruitment_banners.each do |banner|
        expect(banner.key?("suggestion_text")).to eq(true)
        expect(banner["suggestion_text"]).not_to be_blank
        expect(banner.key?("suggestion_link_text")).to eq(true)
        expect(banner["suggestion_link_text"]).not_to be_blank
        expect(banner.key?("survey_url")).to eq(true)
        expect(banner["survey_url"]).not_to be_blank
        expect(banner.key?("page_paths")).to eq(true)
        expect(banner["page_paths"]).not_to be_blank
      end
    end
  end
end
