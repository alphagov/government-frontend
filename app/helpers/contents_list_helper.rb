module ContentsListHelper
  def insert_spans(text)
    no_tags = strip_tags(text) #just the text of the link
    number = /^[0-9]*[.]/.match(no_tags)

    if number
      link_text = no_tags.sub number.to_s, '' #remove the number from the text
      text.sub! no_tags, '<span class="contents-number">' + number.to_s + '</span><span class="contents-text">' + link_text.strip + '</span>'
      text = text.squish.html_safe
    end

    text
  end
end
