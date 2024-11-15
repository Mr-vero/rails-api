FactoryBot.define do
    factory :transaction do
      amount_cents { 1000 }
      currency { 'USD' }
      description { 'Test transaction' }
      status { :completed }
      
      trait :transfer do
        transaction_type { :transfer }
        association :source_wallet, factory: :wallet
        association :target_wallet, factory: :wallet
      end
      
      trait :deposit do
        transaction_type { :deposit }
        association :target_wallet, factory: :wallet
      end
      
      trait :withdrawal do
        transaction_type { :withdrawal }
        association :source_wallet, factory: :wallet
      end
    end
  end