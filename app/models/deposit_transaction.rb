class DepositTransaction < Transaction
    before_create :set_type_deposit
    validates :target_wallet, presence: true
    validates :source_wallet, absence: true

    private

    def set_type_deposit
      self.transaction_type = :deposit
    end
end
