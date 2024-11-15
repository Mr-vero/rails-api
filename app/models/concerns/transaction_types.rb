module TransactionTypes
    extend ActiveSupport::Concern

    TYPES = {
      transfer: "transfer",
      deposit: "deposit",
      withdrawal: "withdrawal"
    }.freeze

    class_methods do
      def transaction_types
        TYPES
      end
    end

    def transfer?
      transaction_type == TYPES[:transfer]
    end

    def deposit?
      transaction_type == TYPES[:deposit]
    end

    def withdrawal?
      transaction_type == TYPES[:withdrawal]
    end
end
