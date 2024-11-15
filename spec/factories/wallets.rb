FactoryBot.define do
    factory :wallet do
      balance_cents { 0 }
      currency { 'USD' }
      association :owner, factory: :user
    end
  end