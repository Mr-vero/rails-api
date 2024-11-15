module LatestStockPrice
  class Client
    include HTTParty
    base_uri 'https://real-time-finance-data.p.rapidapi.com'

    def initialize
      @options = {
        headers: {
          'X-RapidAPI-Key' => LatestStockPrice.api_key,
          'X-RapidAPI-Host' => 'real-time-finance-data.p.rapidapi.com'
        }
      }
    end

    def price(symbol)
      response = self.class.get("/stock-quote", @options.merge(query: { symbol: symbol }))
      handle_response(response)
    rescue HTTParty::Error => e
      raise ApiError, "API request failed: #{e.message}"
    end

    def search(query)
      response = self.class.get("/equities-search", @options.merge(query: { query: query }))
      handle_response(response)
    rescue HTTParty::Error => e
      raise ApiError, "API request failed: #{e.message}"
    end

    def enhanced_data(symbol)
      response = self.class.get("/equities-enhanced", @options.merge(query: { symbol: symbol }))
      handle_response(response)
    rescue HTTParty::Error => e
      raise ApiError, "API request failed: #{e.message}"
    end

    def timeseries(symbol, params = {})
      query = { symbol: symbol }.merge(params)
      response = self.class.get("/timeseries", @options.merge(query: query))
      handle_response(response)
    rescue HTTParty::Error => e
      raise ApiError, "API request failed: #{e.message}"
    end

    private

    def handle_response(response)
      case response.code
      when 200
        response.parsed_response
      when 401
        raise ApiError, "Unauthorized: Invalid API key"
      when 404
        raise ApiError, "Resource not found"
      else
        raise ResponseError, "API request failed with status #{response.code}: #{response.body}"
      end
    end
  end
end