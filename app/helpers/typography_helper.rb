module TypographyHelper
  def nbsp_between_last_two_words(text)
    escaped_text = html_escape_once(text.strip)
    escaped_text.sub(/\s([\w\.\?\!]+)$/, '&nbsp;\1').html_safe
  end
end
