require 'net/http'
require 'json'
require 'uri'

uri = URI('https://swapi.dev/api/planets/')
response = Net::HTTP.get_response(uri)

data = JSON.parse(response.body)

# 星の名前だけ出す
data['results'].each do |planet|
  puts planet['name']
end