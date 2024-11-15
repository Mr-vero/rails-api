module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError do |e|
        render_error(500, "Internal Server Error", e)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        render_error(404, "Resource not found", e)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        render_error(422, "Validation failed", e)
      end
    end

    private

    def render_error(status, message, exception)
      error_response = {
        status: status,
        error: message,
        details: Rails.env.development? ? exception.message : nil
      }.compact

      render json: error_response, status: status
    end
end
