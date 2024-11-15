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
          transactions = current_user.wallet.source_transactions + 
                        current_user.wallet.target_transactions
          
          render json: transactions.sort_by(&:created_at).reverse
        end
      end
    end
  end