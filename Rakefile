require './server'

task :send_daily_quote do
  quote = QUOTES.sample
  text = "Hi Juan! here's a quote to boost up your day!\n\n#{quote['text']}"
  call_send_api(ENV['TEST_SENDER_PSDI'], text)
end
