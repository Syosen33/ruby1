require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'line/bot'

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