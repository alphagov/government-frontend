module ContentsList
  include ActionView::Helpers::UrlHelper

  def contents
    contents_items.map do |item|
      contents_link(item[:text], item[:id])
    end
  end

  def contents_items
    extract_headings_with_ids(body)
  end

  def contents_link(text, id)
    link_to(text, "##{id}")
  end

private

  def extract_headings_with_ids(html)
    headings = Nokogiri::HTML(html).css('h2').map do |heading|
      id = heading.attribute('id')
      { text: strip_trailing_colons(heading.text), id: id.value } if id
    end
    headings.compact
  end

  def strip_trailing_colons(heading)
    heading.gsub(/\:$/, '')
  end
end
