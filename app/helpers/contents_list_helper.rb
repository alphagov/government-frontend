module ContentsListHelper
  def wrap_numbers_with_spans(content_item_link)
    content_item_text = strip_tags(content_item_link) #just the text of the link
    number = /^[0-9]*[.]/.match(content_item_text)

    if number
      words = content_item_text.sub(number.to_s, '').strip #remove the number from the text
      content_item_link.sub(content_item_text, "<span class=\"contents-number\">#{number}</span><span class=\"contents-text\">#{words}</span>").squish.html_safe
    else
      content_item_link
    end
  end
end
