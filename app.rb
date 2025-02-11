require "sinatra"
require "sinatra/reloader"
require 'dotenv/load'
require 'json'
require 'net/http'
require 'uri'

# Define route for homepage
get("/") do
  # Construct the API URL to get currency symbols with access key
  api_url = URI.parse("https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}")

  # Make the request and parse the response
  response = Net::HTTP.get_response(api_url)
  @currency_data = JSON.parse(response.body)
  
  # Extract currency symbols from the response (keys of the 'symbols' hash)
  @currency_symbols = @currency_data["symbols"].keys

  # Render the homepage with the list of symbols
  erb :homepage
end

# Define route for each currency symbol
get("/:currency") do
  @currency = params[:currency]

  # Construct the API URL to get currency symbols
  api_url = URI.parse("https://api.exchangerate.host/list?access_key=#{ENV['EXCHANGE_RATE_KEY']}")
  response = Net::HTTP.get_response(api_url)
  @currency_data = JSON.parse(response.body)
  
  # Extract all symbols
  @currency_symbols = @currency_data["symbols"].keys

  # Render the page for the selected currency symbol
  erb :currency
end

# Define route for currency conversion pair
get("/:from_currency/:to_currency") do
  @from_currency = params[:from_currency]
  @to_currency = params[:to_currency]

  # Construct the API URL for conversion with access key
  api_url = URI.parse("https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}&amount=1&access_key=#{ENV['EXCHANGE_RATE_KEY']}")
  response = Net::HTTP.get_response(api_url)
  @conversion_data = JSON.parse(response.body)

  # Extract conversion rate
  @rate = @conversion_data["result"]

  # Render the conversion result
  erb :conversion
end
