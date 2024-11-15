module BusinessRules
    extend ActiveSupport::Concern
  
    included do
      class_attribute :skip_business_rules
    end
  
    class_methods do
      def without_business_rules
        previous_value = skip_business_rules
        self.skip_business_rules = true
        yield
      ensure
        self.skip_business_rules = previous_value
      end
    end
  
    def validate_business_hours
      return if self.class.skip_business_rules
      
      current_time = Time.current
      unless business_hours?(current_time)
        errors.add(:base, "Transactions only allowed during business hours (9 AM - 5 PM)")
      end
    end
  
    private
  
    def business_hours?(time)
      time.on_weekday? && 
      time.hour.between?(9, 17) && 
      !holiday?(time)
    end
  
    def holiday?(time)
      # Add holiday logic here
      false
    end
  end