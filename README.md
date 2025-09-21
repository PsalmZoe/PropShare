# PropShare - Fractional Real Estate Investment Platform

PropShare is a blockchain-based platform that enables fractional ownership of real estate properties on the Stacks blockchain. Users can list properties, purchase shares, participate in real estate investment with lower capital requirements, receive rental income distributions based on their ownership percentage, and trade shares in a secondary market.

## 🏠 Features

### Core Investment Features
- **Property Listing**: Create fractional property listings with detailed metadata
- **Share Purchase**: Buy fractional shares of real estate properties
- **Rental Income Distribution**: Property owners can distribute rental income to shareholders automatically
- **Income Claiming**: Shareholders can claim their proportional rental income distributions
- **Transparent Pricing**: Automatic price-per-share calculation based on total value

### 🆕 Secondary Market Trading
- **Sell Orders**: Create sell orders for your property shares at custom prices
- **Buy Orders**: Purchase shares from other users at market rates
- **Order Management**: Cancel active sell orders anytime
- **Liquidity**: Trade shares without waiting for new property listings
- **Fair Pricing**: Market-driven share pricing through peer-to-peer trading

### 🔒 Security & Emergency Controls
- **Emergency Pause**: Contract owner can pause all operations during emergencies
- **Secure Trading**: All transactions validated with proper authorization checks
- **Fund Protection**: Built-in safeguards against unauthorized access
- **Ownership Verification**: Strict validation of share ownership before trades

### Platform Management
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

#### Core Investment Functions

- `create-property`: List a new property for fractional investment
- `buy-shares`: Purchase shares of an existing property
- `distribute-rental-income`: Distribute rental income to shareholders (property owner only)
- `claim-rental-income`: Claim available rental income distributions
- `toggle-property-status`: Activate/deactivate property listings (owner only)
- `set-platform-fee-percentage`: Update platform fee percentage (contract owner only)

#### 🆕 Secondary Market Functions

- `create-sell-order`: Create a sell order for your property shares
- `buy-from-order`: Purchase shares from an existing sell order
- `cancel-sell-order`: Cancel your active sell order

#### 🔒 Emergency Control Functions

- `pause-contract`: Pause all contract operations (contract owner only)
- `unpause-contract`: Resume contract operations (contract owner only)

#### Read-Only Functions

- `get-property`: Retrieve property information
- `get-property-metadata`: Get detailed property metadata
- `get-user-shares`: Check user's shares for a specific property
- `get-sell-order`: Get sell order information
- `get-contract-paused`: Check if contract is paused
- `get-next-property-id`: Get the next available property ID
- `get-next-order-id`: Get the next available order ID
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

### 🆕 Secondary Market Trading

#### Creating a Sell Order
```clarity
(contract-call? .propshare create-sell-order u1 u5 u1200)
```

#### Buying from Sell Order
```clarity
(contract-call? .propshare buy-from-order u1)
```

#### Canceling Sell Order
```clarity
(contract-call? .propshare cancel-sell-order u1)
```

### Distributing Rental Income

```clarity
(contract-call? .propshare distribute-rental-income u1 u50000)
```

### Claiming Rental Income

```clarity
(contract-call? .propshare claim-rental-income u1 u1)
```

### 🔒 Emergency Controls (Contract Owner Only)

#### Pausing Contract
```clarity
(contract-call? .propshare pause-contract)
```

#### Resuming Contract
```clarity
(contract-call? .propshare unpause-contract)
```

## 🔧 Technical Details

- **Platform Fee**: Default 2.5% fee on all transactions (including secondary market)
- **Share Calculation**: Automatic price-per-share based on total property value
- **Rental Distribution**: Proportional income distribution based on share ownership
- **Claim System**: Users must actively claim their rental income distributions
- **Secondary Market**: Peer-to-peer share trading with order book system
- **Emergency Controls**: Contract-wide pause functionality for security
- **Security**: Built-in checks for ownership validation and fund sufficiency
- **Data Storage**: Efficient mapping system for properties, user shares, distributions, and orders

## 🛡️ Security Features

- **Emergency Pause**: All functions respect pause state except administrative functions
- **Ownership Validation**: Strict checks prevent unauthorized share transfers
- **Fund Protection**: Multiple validation layers for all financial transactions
- **Order Validation**: Comprehensive checks for sell order creation and execution
- **Self-Trading Prevention**: Users cannot buy their own sell orders

## 🧪 Testing

Run the contract tests using:
```bash
clarinet test
```

Check contract validity:
```bash
clarinet check
```

## 🔄 Changelog

### v2.0.0 - Secondary Market & Emergency Controls
- ✅ Added secondary market trading functionality
- ✅ Implemented emergency pause/unpause controls
- ✅ Enhanced security with comprehensive validation
- ✅ Added sell order management system
- ✅ Improved error handling and user experience

### v1.0.0 - Initial Release
- Basic fractional real estate investment platform
- Property creation and share purchasing
- Rental income distribution and claiming
- Platform fee management