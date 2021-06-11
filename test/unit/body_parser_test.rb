require "test_helper"

class BodyParserTest < ActiveSupport::TestCase
  def html
    '<div class="govspeak">'\
    '<h2 id="travel-to-the-eu">Travel to the EU</h2>\n \n'\
    '<ul>\n'\
    '<li><a rel="external" href="https://www.gov.uk/foreign-travel-advice" '\
    'class="govuk-link">Foreign travel advice</a></li>\n'\
    '<li><a rel="external" href="https://www.gov.uk/visit-eu"'\
    'class="govuk-link">Travelling to the EU'\
    '</a></li>\n</ul>\n'\
    '<h2 id="travel-to-the-uk">Travel to the UK</h2>\n \n'\
    '<ul>\n'\
    '<li><a rel="external" href="https://www.gov.uk/local-travel-advice" '\
    'class="govuk-link">Local travel advice</a></li>\n'\
    '<li><a rel="external" href="https://www.gov.uk/visit-uk"'\
    'class="govuk-link">Travelling to the UK'\
    '</a></li>\n</ul>\n'\
    "</div>"
  end

  def html_missing_section_headings
    '<div class="govspeak">'\
    '<ul>\n'\
    '<li><a rel="external" href="https://www.gov.uk/foreign-travel-advice" '\
    'class="govuk-link">Foreign travel advice</a></li>\n'\
    '<li><a rel="external" href="https://www.gov.uk/visit-eu"'\
    'class="govuk-link">Travelling to the EU'\
    '</a></li>\n</ul>\n'\
    '<ul>\n'\
    '<li><a rel="external" href="https://www.gov.uk/local-travel-advice" '\
    'class="govuk-link">Local travel advice</a></li>\n'\
    '<li><a rel="external" href="https://www.gov.uk/visit-uk"'\
    'class="govuk-link">Travelling to the UK'\
    '</a></li>\n</ul>\n'\
    "</div>"
  end

  def subject
    @subject ||= BodyParser.new(html)
  end

  test "#title_and_link_sections" do
    expected = [
      {
        title: {
          text: "Travel to the EU",
          id: "travel-to-the-eu",
        },
        links: [
          {
            path: "/foreign-travel-advice",
            text: "Foreign travel advice",
          },
          {
            path: "/visit-eu",
            text: "Travelling to the EU",
          },
        ],
      },
      {
        title: {
          text: "Travel to the UK",
          id: "travel-to-the-uk",
        },
        links: [
          {
            path: "/local-travel-advice",
            text: "Local travel advice",
          },
          {
            path: "/visit-uk",
            text: "Travelling to the UK",
          },
        ],
      },
    ]

    assert_equal expected, subject.title_and_link_sections
  end

  test "when parsing html missing the section headings" do
    subject = BodyParser.new(html_missing_section_headings)
    expected = [
      {
        title: {
          text: "",
          id: "",
        },
        links: [
          {
            path: "/foreign-travel-advice",
            text: "Foreign travel advice",
          },
          {
            path: "/visit-eu",
            text: "Travelling to the EU",
          },
          {
            path: "/local-travel-advice",
            text: "Local travel advice",
          },
          {
            path: "/visit-uk",
            text: "Travelling to the UK",
          },
        ],
      },
    ]
    assert_equal expected, subject.title_and_link_sections
  end
end
