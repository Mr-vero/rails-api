module ApiVersioning
    extend ActiveSupport::Concern

    included do
      before_action :check_api_version
    end

    private

    def check_api_version
      version = request.headers["Accept-Version"]
      unless valid_version?(version)
        render json: {
          error: "Invalid API version",
          current_version: "v1",
          supported_versions: [ "v1" ]
        }, status: :unprocessable_entity
      end
    end

    def valid_version?(version)
      version.nil? || version == "v1"
    end
end
