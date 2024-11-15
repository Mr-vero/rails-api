class RequestLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      start_time = Time.current
      request = ActionDispatch::Request.new(env)

      # Log request
      Rails.logger.info(
        request_id: request.request_id,
        method: request.method,
        path: request.path,
        params: request.filtered_parameters
      )

      # Process request
      status, headers, response = @app.call(env)

      # Log response
      Rails.logger.info(
        request_id: request.request_id,
        status: status,
        duration: "#{(Time.current - start_time).round(2)}s"
      )

      [ status, headers, response ]
    end
end
