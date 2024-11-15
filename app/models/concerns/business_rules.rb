module BusinessRules
    extend ActiveSupport::Concern
  
    included do
      class_attribute :skip_business_rules, default: false
    end
  
    def validate_business_hours
      return if self.class.skip_business_rules
      return if self.class.skip_business_hours_validation
      
      current_time = Time.current
      unless current_time.on_weekday? && current_time.hour.between?(9, 17)
        errors.add(:base, "transactions only allowed during business hours")
      end
    end
  end