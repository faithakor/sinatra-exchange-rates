# /env_test.rb
require "dotenv/load"

pp ENV.fetch("EXCHANGE_RATE_KEY")

