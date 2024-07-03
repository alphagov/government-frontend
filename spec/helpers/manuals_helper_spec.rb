RSpec.describe(ManualsHelper, type: :view) do
  include ManualsHelper

  it "returns an empty string when given an empty string" do
    expect(sanitize_manual_update_title("")).to eq("")
  end

  it "returns an empty string when given nil" do
    expect(sanitize_manual_update_title(nil)).to eq("")
  end

  it "removes HTML from the title" do
    expect(sanitize_manual_update_title(" <h1> Hello world </h1> ")).to eq("Hello world")
  end

  it "removes the manuals.updates_amendments string from the title" do
    input = " <h1> Hello world </h1> <span> #{I18n.t('manuals.updates_amendments')} </span> "

    expect(sanitize_manual_update_title(input)).to eq("Hello world")
  end

  it "removes only the unrequired elements from the title" do
    input = " <h1> Hello world </h1> <span> ABC #{I18n.t('manuals.updates_amendments')} XYZ </span> "

    expect(sanitize_manual_update_title(input)).to eq("Hello world ABC XYZ")
  end
end
