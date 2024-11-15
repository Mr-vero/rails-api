require 'httparty'
require 'latest_stock_price/version'
require 'latest_stock_price/client'

module LatestStockPrice
  class << self
    attr_accessor :api_key
    
    def configure
      yield self
    end
  end
end