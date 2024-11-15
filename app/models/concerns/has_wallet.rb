module HasWallet
  extend ActiveSupport::Concern

  included do
    has_one :wallet, as: :owner, dependent: :destroy
    after_create :create_wallet
  end

  private

  def create_wallet
    build_wallet(balance_cents: 0, currency: "USD").save!
  end
end
