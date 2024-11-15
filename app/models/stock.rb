class Stock < ApplicationRecord
    include HasWallet

    validates :symbol, presence: true, uniqueness: true
end
