class TransactionSerializer
    def self.as_json(transaction)
      {
        id: transaction.id,
        amount: {
          amount: transaction.amount_cents.to_f / 100,
          currency: transaction.currency
        },
        status: transaction.status,
        transaction_type: transaction.transaction_type,
        description: transaction.description,
        source_wallet_id: transaction.source_wallet_id,
        target_wallet_id: transaction.target_wallet_id,
        created_at: transaction.created_at.iso8601
      }
    end
  end