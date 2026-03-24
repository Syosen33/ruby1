require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'line/bot'
require 'ruby/openai'

set :bind, '0.0.0.0'
set :port, 4567
set :protection, except: :host_authorization


get '/' do
  "Hello, World!"
end

get '/ok' do
  'OK!'
end

get '/hi' do
  'hi'
end

get '/planets' do
  uri = URI('https://swapi.dev/api/planets/')
  response = Net::HTTP.get_response(uri)
  data = JSON.parse(response.body)

  names = data['results'].map { |planet| "<li>#{planet['name']}</li>" }.join

  <<~HTML
    <h1>Star Wars Planets</h1>
    <ul>
      #{names}
    </ul>
  HTML
end

post '/callback' do
  body = request.body.read
  json = JSON.parse(body)

  client += Line::Bot::Client.new { |config|
    config.channel_id = ENV['LINE_CHANNEL_ID']
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']  
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  }

  client.validate_signature(body, request.env['HTTP_X_LINE_SIGNATURE']) 
  error 400 do
    'Bad Request'
  end
end
events = client.parse_events_from(body)
events.each  |event|
  case event
  when Line::Bot::Event::Message
  openai_client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  response = openai_client.chat(
    model; "gpt-4o-mini",
    message = { role ; "user", content: event.message['text'] }],
    temperature: 0.7,
  }
  )
  message text= response["choices"].map{|c| c["message"]["content"] }.join
  massage = { type: 'text', text: message }
  
  client.reply_message(event['replyToken'], message)
    end
    "OK!"
  end
end