RSpec.describe("Answer", type: :system) do
  it "does not error with a random but valid item" do
    content_item = setup_and_visit_random_content_item

    expect(page).to have_css("meta[name='govuk:content-id'][content='#{content_item['content_id']}']", visible: false)
  end

  it "renders title and body" do
    content_item = setup_and_visit_content_item("answer")

    expect(page).to have_text(content_item["title"])
    expect(page).to have_text("Bydd angen cod cychwyn arnoch i ddechrau defnyddio\u2019r holl wasanaethau hyn, ac eithrio TAW. Anfonir hwn atoch cyn pen saith diwrnod gwaith ar \u00F4l i chi gofrestru. Os ydych chi\u2019n byw dramor, gall gymryd hyd at 21 diwrnod i gyrraedd.")
  end

  it "renders related links" do
    content_item = setup_and_visit_content_item("answer")
    first_related_link = content_item["details"]["external_related_links"].first

    within(".gem-c-related-navigation") do
      expect(page).to have_css(".gem-c-related-navigation__section-link--other[href=\"#{first_related_link['url']}\"]", text: first_related_link["title"])
    end
  end

  it "renders FAQ structured data" do
    content_item = setup_and_visit_content_item("answer")
    faq_schema = find_structured_data(page, "FAQPage")

    expect(content_item["title"]).to eq(faq_schema["name"])
    expect([]).not_to eq(faq_schema["mainEntity"])
  end

  it "does not render with the single page notification button" do
    setup_and_visit_content_item("answer")

    expect(page).not_to have_css(".gem-c-single-page-notification-button")
  end
end
