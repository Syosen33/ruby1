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

  client = Line::Bot::Client.new do |config|
    config.channel_id = ENV['LINE_CHANNEL_ID']
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']  
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  end

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    halt 400, 'Bad Request'
  end

  events = client.parse_events_from(body)
  events.each do |event|
    case event
    when Line::Bot::Event::Message
      openai_client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
      response = openai_client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [{ role: "user", content: event.message['text'] }],
          temperature: 0.7
        }
      )
      message_text = response.dig("choices", 0, "message", "content")
      message = { type: 'text', text: message_text }
      
      client.reply_message(event['replyToken'], message)
    end
  end
  "OK"
end