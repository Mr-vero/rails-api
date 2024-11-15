module ApiDocs
    extend ActiveSupport::Concern
  
    included do
      include Swagger::Blocks
    end
  
    swagger_path '/api/v1/transactions' do
      operation :post do
        key :summary, 'Create a new transaction'
        key :description, 'Creates a new transaction between wallets'
        key :tags, ['Transactions']
        
        parameter do
          key :name, :type
          key :in, :body
          key :description, 'Transaction type (transfer/deposit/withdrawal)'
          key :required, true
          key :type, :string
        end
        
        response 200 do
          key :description, 'Transaction created successfully'
          schema do
            key :'$ref', :Transaction
          end
        end
      end
    end
  end