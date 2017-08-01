module ContentsList
  include ActionView::Helpers::UrlHelper
  include TypographyHelper

  def contents
    @contents ||= contents_items.each do |item|
      item[:href] = "##{item[:id]}"
    end
  end

  def contents_items
    extract_headings_with_ids(body)
  end

private

  def extract_headings_with_ids(html)
    headings = Nokogiri::HTML(html).css('h2').map do |heading|
      id = heading.attribute('id')
      { text: strip_trailing_colons(heading.text), id: id.value } if id
    end
    headings.compact
  end
end
