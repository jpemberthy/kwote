require './server'

task :send_daily_quote do
  quote = Librarian.new.quote
  call_send_api(ENV['TEST_SENDER_PSDI'], quote)
end
