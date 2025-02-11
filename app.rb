require "sinatra"
require "sinatra/reloader"
require 'json'
require 'net/http'
require 'uri'
require 'dotenv/load'

API_KEY = ENV['EXCHANGE_RATE_API_KEY']
API_HOST_URL = "https://api.exchangerate.host"
API_URL = "https://api.exchangerate-api.com/v4/latest/"

get "/" do
  base_currency = params['base'] || 'USD'
  uri = URI("#{API_URL}#{base_currency}?apikey=#{API_KEY}")
  response = Net::HTTP.get_response(uri)

  if response.is_a?(Net::HTTPSuccess)
    rates = JSON.parse(response.body)['rates']
  else
    rates = {}
  end

  erb :index, locals: { rates: rates, base_currency: base_currency }
end
