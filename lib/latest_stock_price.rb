require 'httparty'
require_relative 'latest_stock_price/version'
require_relative 'latest_stock_price/client'
require_relative 'latest_stock_price/errors'

module LatestStockPrice
  class << self
    attr_accessor :api_key
    
    def configure
      yield self
    end

    def client
      raise ConfigurationError, "API key not configured" unless api_key
      @client ||= Client.new
    end
  end
end