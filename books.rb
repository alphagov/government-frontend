class BookCategory
  def initialize
    @b ||= Hash.new([])
  end

  def add_category(category, books)
    @b[category] = books
  end

  def add_book_to_category(category, book)
    @b[category] << book
  end

  def has_books?(category)
    @b[category]
  end
end

BookCategory.new({"fiction": ["a", "b"]})
BookCategory.new({"poetry": ["c"]})


