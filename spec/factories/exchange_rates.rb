FactoryBot.define do
    factory :exchange_rate do
      source_currency { 'USD' }
      target_currency { 'EUR' }
      rate { 0.85 }
    end
  end