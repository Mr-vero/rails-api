module Api
    module V1
      class TransactionsController < ApplicationController
        def index
          transactions = current_user.wallet.transactions
          render json: {
            data: {
              transactions: transactions.map { |t| TransactionSerializer.as_json(t) }
            }
          }
        end
  
        def create
          # Temporarily disable business hours validation
          Transaction.skip_business_hours_validation = true
          
          service = WalletTransactionService.new
          result = case params[:type]&.downcase
          when 'withdrawal', 'withdraw'
            service.withdraw(
              wallet: current_user.wallet,
              amount: Money.from_amount(params[:amount].to_f, params[:currency]),
              description: params[:description]
            )
          when 'deposit'
            service.deposit(
              wallet: current_user.wallet,
              amount: Money.from_amount(params[:amount].to_f, params[:currency]),
              description: params[:description]
            )
          when 'transfer'
            service.transfer(
              source_wallet: current_user.wallet,
              target_wallet: Wallet.find(params[:target_wallet_id]),
              amount: Money.from_amount(params[:amount].to_f, params[:currency]),
              description: params[:description]
            )
          else
            Result.error("Invalid transaction type. Must be 'withdrawal', 'deposit', or 'transfer'")
          end
  
          if result.success?
            render json: { data: TransactionSerializer.as_json(result.data) }
          else
            render json: { error: result.error }, status: :unprocessable_entity
          end
        ensure
          # Re-enable business hours validation
          Transaction.skip_business_hours_validation = false
        end
      end
    end
  end