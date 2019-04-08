# frozen_string_literal: true

class Quote
  attr_reader :book, :text

  def initialize(book:, text:)
    @book = book
    @text = text
  end

  def to_s
    "Hi Juan! here's a quote to boost up your day!
    \n#{self.text}
    \n--#{self.book}"
  end
end
