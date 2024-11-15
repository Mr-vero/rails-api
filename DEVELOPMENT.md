## 🔑 API Documentation

### Authentication

The system uses a custom token-based authentication (not JWT). Include the token in the Authorization header:
```
Authorization: Bearer user_id:expiration:signature
```

#### Endpoints:

**Login**
```
POST /api/v1/session
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "token": "1:1703894400:a1b2c3...",
  "user": {
    "id": 1,
    "email": "user@example.com"
  }
}
```

**Logout**
```
DELETE /api/v1/session
Authorization: Bearer <token>
```

### Wallet Operations

**Get Wallet Details**
```
GET /api/v1/wallets/:id
Authorization: Bearer <token>

Response:
{
  "data": {
    "id": 1,
    "balance": {
      "amount": 1000.00,
      "currency": "USD"
    }
  }
}
```

**Get Wallet Balance**
```
GET /api/v1/wallets/:id/balance
Authorization: Bearer <token>

Response:
{
  "data": {
    "balance": {
      "amount": 1000.00,
      "currency": "USD"
    }
  }
}
```

### Transaction Operations

**Create Transaction**
```
POST /api/v1/transactions
Authorization: Bearer <token>
Content-Type: application/json

{
  "type": "transfer",
  "amount": 100.50,
  "currency": "USD",
  "target_wallet_id": 123,
  "description": "Payment for services"
}

Response:
{
  "data": {
    "id": 1,
    "amount": {
      "amount": 100.50,
      "currency": "USD"
    },
    "status": "completed",
    "transaction_type": "transfer",
    "description": "Payment for services",
    "source_wallet_id": 1,
    "target_wallet_id": 123,
    "created_at": "2024-01-01T12:00:00Z"
  }
}
```

**Get Transaction History**
```
GET /api/v1/transactions
Authorization: Bearer <token>

Response:
{
  "data": {
    "transactions": [
      {
        "id": 1,
        "amount": {
          "amount": 100.50,
          "currency": "USD"
        },
        "status": "completed",
        "transaction_type": "transfer",
        "description": "Payment for services",
        "source_wallet_id": 1,
        "target_wallet_id": 123,
        "created_at": "2024-01-01T12:00:00Z"
      }
    ]
  }
}
```

### Stock Operations

**Get Single Stock Price**
```
GET /api/v1/stocks/price?symbol=AAPL
Authorization: Bearer <token>

Response:
{
  "data": {
    "symbol": "AAPL",
    "price": 150.25,
    "currency": "USD"
  }
}
```

**Get Multiple Stock Prices**
```
GET /api/v1/stocks/prices?symbols[]=AAPL&symbols[]=GOOGL
Authorization: Bearer <token>

Response:
{
  "data": [
    {
      "symbol": "AAPL",
      "price": 150.25,
      "currency": "USD"
    },
    {
      "symbol": "GOOGL",
      "price": 2750.50,
      "currency": "USD"
    }
  ]
}
```

**Get All Stock Prices**
```
GET /api/v1/stocks/price_all
Authorization: Bearer <token>

Response:
{
  "data": [
    {
      "symbol": "AAPL",
      "price": 150.25,
      "currency": "USD"
    },
    // ... more stocks
  ]
}
```

### Error Responses

All endpoints return appropriate HTTP status codes:
```
401 Unauthorized
{
  "error": "Unauthorized"
}

422 Unprocessable Entity
{
  "error": "Detailed error message"
}

500 Internal Server Error
{
  "error": "Internal server error"
}
```