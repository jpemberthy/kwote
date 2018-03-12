require 'httparty'
require 'json'
require 'sinatra'
# require 'sinatra/reloader'  # if development?

PAGE_ACCESS_TOKEN = ENV['PAGE_ACCESS_TOKEN']
QUOTES = JSON.parse(File.read('quotes.json'))

post '/webhook' do
  request.body.rewind  # in case someone already read it
  body = JSON.parse request.body.read

  # Checks this is an event from a page subscription
  if body['object'] == 'page'
    # Iterates over each entry - there may be multiple if batched
    body['entry'].each do |entry|
      # Gets the message. entry.messaging is an array, but
      # will only ever contain one message, so we get index 0
      webhook_event = entry['messaging'][0]
      puts webhook_event

      sender_psid = webhook_event['sender']['id']
      puts "Sender PSID: #{sender_psid}"

      # Check if the event is a message or postback and
      # pass the event to the appropriate handler function.
      if webhook_event['message']
      handle_message(sender_psid, webhook_event['message']);
      elsif webhook_event['postback']
        handle_postback(sender_psid, webhook_event['postback'])
      end
    end
    # Returns a '200 OK' response to all requests
    [200, 'EVENT_RECEIVED']
  else
    # Returns a '404 Not Found' if event is not from a page subscription
    res.sendStatus(404)
  end
end

get '/webhook' do
  verify_token = ENV['VERIFY_TOKEN']

  # query params
  mode = request.params['hub.mode']
  token = request.params['hub.verify_token']
  challenge = request.params['hub.challenge']

  # Checks if a token and mode is in the query string of the reques
  if mode && token
    # Checks the mode and token sent is correct
    if (mode == 'subscribe' && token == verify_token)
      # Responds with the challenge token from the request
         puts 'WEBHOOK_VERIFIED'
         return [200, challenge]
    else
      # Responds with '403 Forbidden' if verify tokens do not match
      403
    end
  end
end

get '/test' do
  sender_psid = ENV['TEST_SENDER_PSDI']
  call_send_api(sender_psid, 'This is a reminder', messaging_type='UPDATE')
end

get '/hello' do
  [200, 'hello!']
end

private

def handle_message(sender_psid, received_message)
  response = {}

  quote = QUOTES.sample
  text = "Hi Juan! here's a quote to boost up your day!\n\n#{quote['text']}"
  call_send_api(sender_psid, text);
  # call_send_api(sender_psid, quote['text'])
end

def handle_postback(sender_psid, postback)
  'ok'
end


def call_send_api(sender_psid, text, messaging_type='RESPONSE')
  # Send the HTTP request to the Messenger Platform
  payload = {
    query: {access_token: PAGE_ACCESS_TOKEN},
    body: {
      messaging_type: messaging_type,
      recipient: {id: sender_psid},
      message: {text: text}
    },
  }
  response = HTTParty.post('https://graph.facebook.com/v2.6/me/messages', payload)
  if response.code == 200
    puts 'message sent!'
  else
    puts "unable to send message, status: #{response.code}, body: #{response.body}"
  end
end
