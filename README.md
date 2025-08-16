# PropShare - Fractional Real Estate Investment Platform

PropShare is a blockchain-based platform that enables fractional ownership of real estate properties on the Stacks blockchain. Users can list properties, purchase shares, participate in real estate investment with lower capital requirements, and receive rental income distributions based on their ownership percentage.

## 🏠 Features

- **Property Listing**: Create fractional property listings with detailed metadata
- **Share Purchase**: Buy fractional shares of real estate properties
- **Rental Income Distribution**: Property owners can distribute rental income to shareholders automatically
- **Income Claiming**: Shareholders can claim their proportional rental income distributions
- **Transparent Pricing**: Automatic price-per-share calculation based on total value
- **Platform Fee Management**: Configurable platform fees for sustainable operations
- **Property Status Control**: Property owners can activate/deactivate listings
- **Ownership Tracking**: Track user shares across multiple properties
- **Distribution History**: Complete record of all rental income distributions

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
- `distribute-rental-income`: Distribute rental income to shareholders (property owner only)
- `claim-rental-income`: Claim available rental income distributions
- `toggle-property-status`: Activate/deactivate property listings (owner only)
- `update-platform-fee`: Update platform fee percentage (contract owner only)

#### Read-Only Functions

- `get-property`: Retrieve property information
- `get-property-metadata`: Get detailed property metadata
- `get-user-shares`: Check user's shares for a specific property
- `get-next-property-id`: Get the next available property ID
- `get-platform-fee-percentage`: Current platform fee percentage
- `get-next-distribution-id`: Get the next distribution ID
- `get-rental-distribution`: Get rental distribution details
- `has-claimed-distribution`: Check if user has claimed a specific distribution
- `get-claimable-amount`: Calculate claimable rental income for a user

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

### Distributing Rental Income

```clarity
(contract-call? .propshare distribute-rental-income u1 u50000)
```

### Claiming Rental Income

```clarity
(contract-call? .propshare claim-rental-income u1 u1)
```

## 🔧 Technical Details

- **Platform Fee**: Default 2.5% fee on all transactions
- **Share Calculation**: Automatic price-per-share based on total property value
- **Rental Distribution**: Proportional income distribution based on share ownership
- **Claim System**: Users must actively claim their rental income distributions
- **Security**: Built-in checks for ownership validation and fund sufficiency
- **Data Storage**: Efficient mapping system for properties, user shares, and distributions

## 🧪 Testing

Run the contract tests using:
```bash
clarinet test
```
