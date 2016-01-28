module ExtractsHeadings
  def extract_headings_with_ids(html)
    Nokogiri::HTML(html).css('h2').map do |heading|
      id = heading.attribute('id')
      { text: heading.text, id: id.value } if id
    end.compact
  end
end
