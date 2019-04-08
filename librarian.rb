# frozen_string_literal: true

require "json"
require_relative "quote"

class Librarian
  QUOTES_FILES_PATTERN = "quotes/*.json"

  attr_reader :quotes

  def initialize
    @quotes = []
    load_quotes!
  end

  def quote
    self.quotes.sample
  end

  private

  def load_quotes!
    Dir.glob(QUOTES_FILES_PATTERN).each do |quote_path|
      book = JSON.parse(File.read(quote_path))
      book["highlights"].each do |highlight|
        @quotes << Quote.new(book: book["tittle"], text: highlight["text"])
      end
    end
  end
end
