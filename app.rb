require 'sinatra'
require 'json'
require 'line/bot'
require 'openai'

post '/callback' do
  body = request.body.read

  client = Line::Bot::Client.new do |config|
    config.channel_id = ENV['LINE_CHANNEL_ID']
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_CHANNEL_TOKEN']
  end

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  halt 400, 'Bad Request' unless client.validate_signature(body, signature)

  events = client.parse_events_from(body)

  events.each do |event|
    next unless event.is_a?(Line::Bot::Event::Message)
    next unless event.type == 'message'
    next unless event.message.type == 'text'

    openai_client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY']
    )

    response = openai_client.chat(
      parameters: {
        model: 'gpt-4o-mini',
        messages: [
          { role: 'user', content: event.message['text'] }
        ],
        temperature: 0.7
      }
    )

    message_text = response.dig('choices', 0, 'message', 'content')

    message = {
      type: 'text',
      text: message_text || 'うまく返答を生成できませんでした。'
    }

    client.reply_message(event['replyToken'], message)
  end

  'OK'
end