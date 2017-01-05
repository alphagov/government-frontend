module ExtractsHeadings
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
