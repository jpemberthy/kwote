# frozen_string_literal: true

class Quote
  attr_reader :book, :text

  def initialize(book:, text:)
    @book = book
    @text = text
  end
end
