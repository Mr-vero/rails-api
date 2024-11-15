module LatestStockPrice
    class Error < StandardError; end
    class ApiError < Error; end
    class ConfigurationError < Error; end
    class ResponseError < Error; end
end
