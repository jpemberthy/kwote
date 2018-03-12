require 'kindle_highlights'

class Importer
  attr_reader :quotes

  def initialize
    @kindle = KindleHighlights::Client.new(
      email_address: ENV['KINDLE_EMAIL'],
      password: ENV['KINDLE_PASSWORD'],
    )
    @quotes = []
  end

  # TODO: maybe create rake task with
  # File.open('quotes.json', 'w') { |f| f.write(JSON.pretty_generate(importer.quotes)) }
  def import!
    @kindle.books.each do |book|
      @kindle.highlights_for(book.asin).each do |highlight|
        quotes << {text: highlight.text, book: book.title}
      end
    end
  end
end
