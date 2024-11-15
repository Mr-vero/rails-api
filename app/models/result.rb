class Result
    attr_reader :success, :data, :error
  
    def self.success(data = nil)
      new(success: true, data: data)
    end
  
    def self.error(message)
      new(success: false, error: message)
    end
  
    def initialize(success:, data: nil, error: nil)
      @success = success
      @data = data
      @error = error
    end
  
    def success?
      @success
    end
  end