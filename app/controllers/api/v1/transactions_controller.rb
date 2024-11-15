module Api
    module V1
      class TransactionsController < ApplicationController
        def create
          service = WalletTransactionService.new
          amount = Money.from_amount(params[:amount].to_f, params[:currency])
  
          case params[:type]
          when 'transfer'
            target_wallet = Wallet.find(params[:target_wallet_id])
            result = service.transfer(
              source_wallet: current_user.wallet,
              target_wallet: target_wallet,
              amount: amount
            )
          when 'deposit'
            result = service.deposit(
              wallet: current_user.wallet,
              amount: amount
            )
          when 'withdraw'
            result = service.withdraw(
              wallet: current_user.wallet,
              amount: amount
            )
          else
            return render json: { error: 'Invalid transaction type' }, status: :unprocessable_entity
          end
  
          if result
            render json: { message: 'Transaction successful' }
          else
            render json: { error: 'Transaction failed' }, status: :unprocessable_entity
          end
        end
  
        def index
          transactions = current_user.wallet.transactions
          render json: { 
            data: {
              transactions: transactions.map do |t|
                {
                  id: t.id,
                  type: t.transaction_type,
                  amount: format_money_amount(t),
                  currency: t.currency,
                  description: t.description,
                  status: t.status,
                  created_at: t.created_at
                }
              end
            }
          }
        end

        private

        def format_money_amount(transaction)
          Money.new(transaction.amount_cents, transaction.currency).to_f
        end
      end
    end
  end