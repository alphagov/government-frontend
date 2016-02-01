module TypographyHelper
  def nbsp_between_last_two_words(text)
    text.sub(/\s([\w\.\?\!]+)$/, '&nbsp;\1').html_safe
  end
end
