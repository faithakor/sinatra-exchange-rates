require "sinatra"
require "sinatra/reloader"
require 'dotenv/load'
require 'json'
require 'net/http'
require 'uri'

# Route for the homepage - list all currencies dynamically from the API
get '/' do
  api_url = "https://api.exchangerate.host/list"
  uri = URI(api_url)
  response = Net::HTTP.get(uri)  # Fetch the API data
  
  @currencies = JSON.parse(response)["symbols"].keys
  erb :homepage
end

# Route to display the conversion options for a specific currency
get '/:currency' do
  @currency = params[:currency].upcase
  api_url = "https://api.exchangerate.host/list"
  uri = URI(api_url)
  response = Net::HTTP.get(uri)
  
  @currencies = JSON.parse(response)["symbols"].keys
  erb :currency
end

# Route for currency conversion between two specific currencies
get '/:from_currency/:to_currency' do
  @from_currency = params[:from_currency].upcase
  @to_currency = params[:to_currency].upcase
  api_url = "https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}&amount=1"
  uri = URI(api_url)
  response = Net::HTTP.get(uri)
  
  data = JSON.parse(response)
  @conversion_rate = data['info']['rate'] if data['success']
  
  erb :conversion
end
