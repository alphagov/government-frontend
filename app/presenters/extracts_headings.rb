module ExtractsHeadings
  def extract_headings_with_ids(html)
    headings = Nokogiri::HTML(html).css('h2').map do |heading|
      id = heading.attribute('id')
      { text: heading.text, id: id.value } if id
    end
    headings.compact
  end
end
