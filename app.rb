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
  
  # Make the request to the API
  response = Net::HTTP.get(uri)
  
  # Log the response for debugging purposes
  puts "API Response: #{response}"

  # Parse the JSON response
  begin
    parsed_response = JSON.parse(response)
    
    # Check if the 'symbols' key exists
    if parsed_response && parsed_response['symbols']
      @currencies = parsed_response['symbols'].keys
    else
      @currencies = []
      puts "Error: 'symbols' key not found in API response"
    end
  rescue JSON::ParserError => e
    @currencies = []
    puts "Error parsing JSON: #{e.message}"
  end
  
  erb :homepage
end

# Route to display the conversion options for a specific currency
get '/:currency' do
  @currency = params[:currency].upcase
  api_url = "https://api.exchangerate.host/list"
  uri = URI(api_url)
  response = Net::HTTP.get(uri)
  
  begin
    parsed_response = JSON.parse(response)
    if parsed_response && parsed_response['symbols']
      @currencies = parsed_response['symbols'].keys
    else
      @currencies = []
      puts "Error: 'symbols' key not found in API response"
    end
  rescue JSON::ParserError => e
    @currencies = []
    puts "Error parsing JSON: #{e.message}"
  end

  erb :currency
end

# Route for currency conversion between two specific currencies
get '/:from_currency/:to_currency' do
  @from_currency = params[:from_currency].upcase
  @to_currency = params[:to_currency].upcase
  api_url = "https://api.exchangerate.host/convert?from=#{@from_currency}&to=#{@to_currency}&amount=1"
  uri = URI(api_url)
  response = Net::HTTP.get(uri)
  
  begin
    data = JSON.parse(response)
    if data['success']
      @conversion_rate = data['info']['rate']
    else
      @conversion_rate = nil
      puts "Error in conversion response: #{data['error']}"
    end
  rescue JSON::ParserError => e
    @conversion_rate = nil
    puts "Error parsing JSON: #{e.message}"
  end
  
  erb :conversion
end
