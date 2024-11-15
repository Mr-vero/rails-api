# Wallet Transaction System API Documentation

## Base URL
`https://api.example.com/api/v1`

## Authentication

All API endpoints require authentication token in session cookie except for login.

### Login
```http
POST /session
```

**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response (200 OK):**
```json
{
  "message": "Logged in successfully",
  "user": {
    "id": "integer",
    "email": "string"
  }
}
```

### Logout
```http
DELETE /session
```

**Response (200 OK):**
```json
{
  "message": "Logged out successfully"
}
```

## Wallet Operations

### Get Wallet Details
```http
GET /wallets/:id
```

**Response (200 OK):**
```json
{
  "id": "integer",
  "balance_cents": "integer",
  "currency": "string",
  "owner_type": "string",
  "owner_id": "integer"
}
```

### Get Wallet Balance
```http
GET /wallets/:id/balance
```

**Response (200 OK):**
```json
{
  "balance": {
    "amount": "decimal",
    "currency": "string"
  }
}
```

## Transactions

### Create Transaction
```http
POST /transactions
```

**Request Body:**
```json
{
  "type": "string (transfer|deposit|withdraw)",
  "amount": "decimal",
  "currency": "string",
  "target_wallet_id": "integer (required for transfer)",
  "description": "string"
}
```

**Response (200 OK):**
```json
{
  "message": "Transaction successful",
  "transaction": {
    "id": "integer",
    "amount_cents": "integer",
    "currency": "string",
    "status": "string",
    "transaction_type": "string",
    "description": "string",
    "created_at": "datetime"
  }
}
```

### Get Transaction History
```http
GET /transactions
```

**Query Parameters:**
```
status: string (optional, pending|completed|failed)
type: string (optional, transfer|deposit|withdrawal)
from_date: date (optional)
to_date: date (optional)
```

**Response (200 OK):**
```json
{
  "transactions": [
    {
      "id": "integer",
      "amount_cents": "integer",
      "currency": "string",
      "status": "string",
      "transaction_type": "string",
      "description": "string",
      "source_wallet_id": "integer",
      "target_wallet_id": "integer",
      "created_at": "datetime"
    }
  ],
  "meta": {
    "total_count": "integer",
    "page": "integer",
    "per_page": "integer"
  }
}
```

## Stock Price Operations

### Get Single Stock Price
```http
GET /stocks/price
```

**Query Parameters:**
```
symbol: string (required)
```

**Response (200 OK):**
```json
{
  "symbol": "string",
  "price": "decimal",
  "timestamp": "datetime"
}
```

### Get Multiple Stock Prices
```http
GET /stocks/prices
```

**Query Parameters:**
```
symbols: array[string] (required)
```

**Response (200 OK):**
```json
{
  "prices": [
    {
      "symbol": "string",
      "price": "decimal",
      "timestamp": "datetime"
    }
  ]
}
```

### Get All Stock Prices
```http
GET /stocks/price_all
```

**Response (200 OK):**
```json
{
  "prices": [
    {
      "symbol": "string",
      "price": "decimal",
      "timestamp": "datetime"
    }
  ]
}
```

## Error Responses

### 401 Unauthorized
```json
{
  "error": "Unauthorized"
}
```

### 422 Unprocessable Entity
```json
{
  "error": "Error message",
  "details": {
    "field": ["error messages"]
  }
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error"
}
```

## Testing Examples

### cURL Examples

1. Login:
```bash
curl -X POST https://api.example.com/api/v1/session \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123"}'
```

2. Create Transfer Transaction:
```bash
curl -X POST https://api.example.com/api/v1/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "type": "transfer",
    "amount": 100.50,
    "currency": "USD",
    "target_wallet_id": 123,
    "description": "Payment for services"
  }'
```

3. Get Wallet Balance:
```bash
curl https://api.example.com/api/v1/wallets/123/balance
```

### Postman Collection

```json
{
  "info": {
    "name": "Wallet Transaction API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Authentication",
      "item": [
        {
          "name": "Login",
          "request": {
            "method": "POST",
            "header": [],
            "url": "{{base_url}}/session",
            "body": {
              "mode": "raw",
              "raw": "{\n  \"email\": \"user@example.com\",\n  \"password\": \"password123\"\n}",
              "options": {
                "raw": {
                  "language": "json"
                }
              }
            }
          }
        }
      ]
    },
    {
      "name": "Transactions",
      "item": [
        {
          "name": "Create Transaction",
          "request": {
            "method": "POST",
            "header": [],
            "url": "{{base_url}}/transactions",
            "body": {
              "mode": "raw",
              "raw": "{\n  \"type\": \"transfer\",\n  \"amount\": 100.50,\n  \"currency\": \"USD\",\n  \"target_wallet_id\": 123,\n  \"description\": \"Payment for services\"\n}",
              "options": {
                "raw": {
                  "language": "json"
                }
              }
            }
          }
        }
      ]
    }
  ]
}
```

## Rate Limits

- 1000 requests per hour per API key
- Endpoints return `429 Too Many Requests` when limit is exceeded

## Webhooks (Optional)

Configure webhook URL to receive transaction status updates:

```http
POST /webhooks/configure
```

**Request Body:**
```json
{
  "url": "string",
  "events": ["transaction.completed", "transaction.failed"]
}
```
```

Would you like me to:
1. Generate a Postman collection file?
2. Add more testing examples?
3. Create automated API tests using RSpec?
4. Add request/response schemas for validation?
```

</rewritten_file>
```
