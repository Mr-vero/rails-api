module LatestStockPrice
    class Error < StandardError; end
    class ConfigurationError < Error; end
    class ApiError < Error; end
    
    class Client
      BASE_URL = 'https://latest-stock-price.p.rapidapi.com'
      
      def initialize(api_key = nil)
        @api_key = api_key || ENV['RAPIDAPI_KEY']
        raise ConfigurationError, 'API key is required' unless @api_key
      end
      
      def price(symbol)
        get_request("/price?Indices=#{symbol}")
      end
      
      def prices(symbols)
        get_request("/price?Indices=#{symbols.join(',')}")
      end
      
      def price_all
        get_request("/any")
      end
      
      private
      
      def get_request(path)
        response = HTTParty.get(
          "#{BASE_URL}#{path}",
          headers: {
            'X-RapidAPI-Key' => @api_key,
            'X-RapidAPI-Host' => 'latest-stock-price.p.rapidapi.com'
          }
        )
        
        handle_response(response)
      end
      
      def handle_response(response)
        case response.code
        when 200
          response.parsed_response
        when 401
          raise ApiError, 'Unauthorized - Invalid API key'
        when 429
          raise ApiError, 'Rate limit exceeded'
        else
          raise ApiError, "API error: #{response.code} - #{response.message}"
        end
      end
    end
  end