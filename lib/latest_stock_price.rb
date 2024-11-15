require 'httparty'

module LatestStockPrice
  class Client
    include HTTParty
    base_uri 'https://latest-stock-price.p.rapidapi.com'
    
    def initialize(api_key)
      @options = {
        headers: {
          'X-RapidAPI-Key' => api_key,
          'X-RapidAPI-Host' => 'latest-stock-price.p.rapidapi.com'
        }
      }
    end

    def price(symbol)
      response = self.class.get("/price", @options.merge(query: { Indices: symbol }))
      handle_response(response)
    end

    def prices(symbols)
      response = self.class.get("/price", @options.merge(query: { Indices: symbols.join(',') }))
      handle_response(response)
    end

    def price_all
      response = self.class.get("/any", @options)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.code
      when 200
        response.parsed_response
      else
        raise "API Error: #{response.code} - #{response.message}"
      end
    end
  end
end