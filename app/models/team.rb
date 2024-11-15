class Team < ApplicationRecord
    include HasWallet

    validates :name, presence: true
end
