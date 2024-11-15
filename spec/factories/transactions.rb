FactoryBot.define do
    factory :transaction do
      amount_cents { 1000 }
      currency { 'USD' }
      description { 'Test transaction' }
      status { 'completed' }
      
      trait :transfer do
        transaction_type { 'transfer' }
        association :source_wallet, factory: :wallet
        association :target_wallet, factory: :wallet
      end
      
      trait :deposit do
        transaction_type { 'deposit' }
        association :target_wallet, factory: :wallet
      end
      
      factory :transfer_transaction, traits: [:transfer]
      factory :deposit_transaction, traits: [:deposit]
    end
  end