FactoryBot.define do
    factory :stock do
      sequence(:symbol) { |n| "STOCK#{n}" }
    end
  end