# PropShare - Fractional Real Estate Investment Platform

PropShare is a blockchain-based platform that enables fractional ownership of real estate properties on the Stacks blockchain. 
Users can list properties, purchase shares, and participate in real estate investment with lower capital requirements.

## 🏠 Features

- **Property Listing**: Create fractional property listings with detailed metadata
- **Share Purchase**: Buy fractional shares of real estate properties
- **Transparent Pricing**: Automatic price-per-share calculation based on total value
- **Platform Fee Management**: Configurable platform fees for sustainable operations
- **Property Status Control**: Property owners can activate/deactivate listings
- **Ownership Tracking**: Track user shares across multiple properties

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) installed
- Stacks wallet for testing

### Installation

1. Clone the repository
2. Navigate to the project directory
3. Run `clarinet check` to verify contract validity
4. Deploy using `clarinet deploy`

### Contract Functions

#### Public Functions

- `create-property`: List a new property for fractional investment
- `buy-shares`: Purchase shares of an existing property
- `toggle-property-status`: Activate/deactivate property listings (owner only)
- `update-platform-fee`: Update platform fee percentage (contract owner only)

#### Read-Only Functions

- `get-property`: Retrieve property information
- `get-property-metadata`: Get detailed property metadata
- `get-user-shares`: Check user's shares for a specific property
- `get-next-property-id`: Get the next available property ID
- `get-platform-fee-percentage`: Current platform fee percentage

## 📊 Usage Examples

### Creating a Property

```clarity
(contract-call? .propshare create-property 
    "Downtown Apartment Complex" 
    u1000000 
    u1000 
    "123 Main St, Downtown" 
    "Residential" 
    "Modern apartment complex with 20 units")
```

### Buying Shares

```clarity
(contract-call? .propshare buy-shares u1 u10)
```

## 🔧 Technical Details

- **Platform Fee**: Default 2.5% fee on all transactions
- **Share Calculation**: Automatic price-per-share based on total property value
- **Security**: Built-in checks for ownership validation and fund sufficiency
- **Data Storage**: Efficient mapping system for properties and user shares

## 🧪 Testing

Run the contract tests using:
```bash
clarinet test
```
