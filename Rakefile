require './server'

require_relative "librarian"

task :send_daily_quote do
  quote = Librarian.new.quote
  text = "Hi Juan! here's a quote to boost up your day!\n\n#{quote.text}"
  call_send_api(ENV['TEST_SENDER_PSDI'], text)
end
