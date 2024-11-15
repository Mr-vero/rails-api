# Internal Wallet Transaction System API

A robust internal wallet system that enables financial transactions between different entities (Users, Teams, Stocks) with proper validations and ACID compliance.

## 🚀 Features

- Multi-entity wallet system (Users, Teams, Stocks)
- Secure session-based authentication
- ACID-compliant transactions
- Real-time stock price integration
- Balance tracking and transaction history
- Currency support via Money gem
- RESTful API design

## 📋 Requirements

- Ruby 3.2.0+
- Rails 7.0.0+
- PostgreSQL 12+
- RapidAPI Key (for stock price integration)

## 🛠 Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/wallet-system.git
```


2. Install dependencies
```bash

bundle install
```

3. Setup database
```bash

rails db:create db:migrate
```


4. Set environment variables
```bash

RAPIDAPI_KEY=your_rapid_api_key
```


5. Start the server
```bash

rails server
```


## 🔑 API Endpoints

### Authentication

POST /api/v1/session
  - Login user
  Parameters: { email: string, password: string }

DELETE /api/v1/session
  - Logout user

### Wallets

GET /api/v1/wallets/:id
  - Get wallet details

GET /api/v1/wallets/:id/balance
  - Get current balance

### Transactions

POST /api/v1/transactions
  - Create new transaction
  Parameters: {
    type: ['transfer', 'deposit', 'withdraw'],
    amount: decimal,
    currency: string,
    target_wallet_id: integer (required for transfer)
  }

GET /api/v1/transactions
  - Get transaction history

### Stocks

GET /api/v1/stocks/price
  Parameters: { symbol: string }

GET /api/v1/stocks/prices
  Parameters: { symbols: array }

GET /api/v1/stocks/price_all
  - Get all available stock prices

## 💰 Transaction Types

1. **Transfer**
   - Move money between two wallets
   - Requires source and target wallets
   - Same currency validation

2. **Deposit**
   - Add money to a wallet
   - Only requires target wallet
   - Creates credit transaction

3. **Withdraw**
   - Remove money from a wallet
   - Only requires source wallet
   - Creates debit transaction

## 🏗 Architecture

### Models
- `Wallet`: Holds balance and belongs to any entity
- `Transaction`: Records money movement between wallets
- `User`: Authentication and wallet ownership
- `Team`: Group wallet functionality
- `Stock`: Market-linked wallet functionality

### Key Components
- `HasWallet` concern: Adds wallet functionality to models
- `WalletTransactionService`: Handles all transaction logic
- `LatestStockPrice`: Library for stock price integration

## 🧪 Testing

Run the test suite:
```bash
bundle exec rspec
```

Test coverage includes:
- Model validations
- Transaction logic
- API endpoints
- Integration tests

## 🔒 Security

- Session-based authentication
- CSRF protection
- Database transaction locks
- Input validation
- Error handling

## 📦 Dependencies

- `money-rails`: Money and currency handling
- `bcrypt`: Password encryption
- `httparty`: API integration
- `rspec-rails`: Testing framework

## 🚧 Error Handling

The API returns appropriate HTTP status codes:
- 200: Success
- 401: Unauthorized
- 422: Unprocessable Entity
- 500: Server Error

Error responses include descriptive messages:
```json
{
  "error": "Detailed error message"
}
```

## 🔄 Database Schema

```ruby
create_table "wallets", force: :cascade do |t|
  t.references :owner, polymorphic: true, null: false
  t.integer :balance_cents, default: 0, null: false
  t.string :currency, null: false
  t.timestamps
end

create_table "transactions", force: :cascade do |t|
  t.references :source_wallet
  t.references :target_wallet
  t.integer :amount_cents, null: false
  t.string :currency, null: false
  t.timestamps
end
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 👥 Authors

- Irvan - Initial work - [Irvan](https://github.com/mr-vero)

## 🙏 Acknowledgments

- RapidAPI for stock price data
- Money gem contributors
- Rails community
```

This README provides:
- Clear installation instructions
- Comprehensive API documentation
- Architecture overview
- Testing instructions
- Security considerations
- Contribution guidelines

