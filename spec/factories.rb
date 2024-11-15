FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      password { 'password123' }
    end

    factory :team do
      sequence(:name) { |n| "Team #{n}" }
    end

    factory :stock do
      sequence(:symbol) { |n| "STOCK#{n}" }
    end

    factory :wallet do
      balance_cents { 0 }
      currency { 'USD' }
      association :owner, factory: :user
    end

    factory :exchange_rate do
      source_currency { 'USD' }
      target_currency { 'EUR' }
      rate { 0.85 }
    end

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

      trait :withdrawal do
        transaction_type { 'withdrawal' }
        association :source_wallet, factory: :wallet
      end

      factory :transfer_transaction, traits: [ :transfer ]
      factory :deposit_transaction, traits: [ :deposit ]
      factory :withdrawal_transaction, traits: [ :withdrawal ]
    end
  end
