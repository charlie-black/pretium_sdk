# Pretium SDK

A Flutter/Dart SDK for the [Pretium Africa API](https://docs.pretium.africa) — crypto on/off-ramps, disbursements, bank transfers and account utilities across Africa.

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  pretium_sdk:
    path: ../pretium_sdk
```

Run:

```bash
flutter pub get
```

---

## Setup

```dart
import 'package:pretium_sdk/pretium_sdk.dart';

final pretium = Pretium(
  apiKey: 'YOUR_API_KEY',
);
```

---

## Error Handling

Every method throws a `PretiumException` on failure. Always wrap calls in a try-catch:

```dart
import 'package:pretium_sdk/exceptions/pretium_exception.dart';

try {
final account = await pretium.getAccount();
} on PretiumException catch (e) {
print('API Error [${e.code}]: ${e.message}');
} catch (e) {
print('Unexpected error: $e');
}
```

| Error Type | Code | Cause |
|---|---|---|
| Bad Request | 400 | Invalid parameters |
| Unauthorized | 401 | Invalid API key |
| Not Found | 404 | Resource not found |
| Server Error | 500 | Internal server error |
| Network Error | 0 | No internet / timeout |

---

## Account

### Get Account Info

Returns your account profile, wallets, and supported networks.

```dart
final account = await pretium.getAccount();

print(account.name);         // "Pretium"
print(account.email);        // "hello@pretium.africa"
print(account.status);       // "ACTIVE"
print(account.checkoutKey);  // "cduhpnka"

// Wallets
for (final wallet in account.wallets) {
  print('${wallet.currency}: ${wallet.balance}'); // KES: 11580855.48
}

// Networks
for (final network in account.networks) {
  print(network.name); // Base, Celo, Tron ...
  for (final asset in network.assets) {
    print('  └── ${asset.name}'); // USDC, USDT ...
  }
}
```

**Response fields:**

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Account ID |
| `name` | `String` | Account name |
| `email` | `String` | Account email |
| `status` | `String` | Account status e.g. `ACTIVE` |
| `checkoutKey` | `String` | Checkout key |
| `wallets` | `List<Wallet>` | Balances per country |
| `networks` | `List<Network>` | Supported blockchain networks |
| `createdAt` | `DateTime` | Account creation date |

---

### Get Countries

Returns all supported countries.

```dart
final countries = await pretium.getCountries();

for (final country in countries) {
  print('${country.name} (${country.currencyCode}) +${country.phoneCode}');
  // Kenya (KES) +254
}
```

**Response fields:**

| Field | Type | Description |
|---|---|---|
| `id` | `int` | Country ID |
| `name` | `String` | Country name |
| `currencyCode` | `String` | e.g. `KES`, `NGN`, `GHS` |
| `phoneCode` | `String` | e.g. `254`, `234` |

---

### Get Exchange Rate

Fetch a live USD ↔ fiat exchange rate.

```dart
final rate = await pretium.getExchangeRates(
to: 'KES',
buyingRate: true,
);

print(rate.from);  // USD
print(rate.to);    // KES
print(rate.rate);  // 127.74
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `to` | `String` | ✅ | Target currency code e.g. `KES` |
| `buyingRate` | `bool` | ✅ | `true` for buying rate, `false` for selling |

---

### Get Networks

Returns all supported blockchain networks and their assets.

```dart
final networks = await pretium.getNetworks();

for (final network in networks) {
print('${network.name} active: ${network.checkoutStatus}');
for (final asset in network.assets) {
print('  └── ${asset.name}: ${asset.contractAddress}');
}
}
```

**Network fields:**

| Field | Type | Description |
|---|---|---|
| `name` | `String` | Network name e.g. `Celo`, `Tron` |
| `icon` | `String` | Icon URL |
| `settlementWalletAddress` | `String` | Settlement wallet address |
| `checkoutStatus` | `bool` | Whether network is active |
| `assets` | `List<NetworkAsset>` | Supported assets on this network |

---

### Get Wallet Balance

Returns the balance for a specific country wallet.

```dart
final wallet = await pretium.getWallets(countryId: 1); // 1 = Kenya

print(wallet.currency);    // KES
print(wallet.balance);     // 11535556.88
print(wallet.countryName); // Kenya
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `countryId` | `int` | ✅ | Country ID from `getCountries()` |

---

## Transactions

### Get All Transactions

Returns a list of transactions filtered by date range and currency.

```dart
final allTransactions = await pretium.getTransactions(
  startDate: "2025-02-19",
  endDate: "2025-07-20",
  currencyCode: "cdf",
);

print(allTransactions);
// AllTransactionsModel(total: 20, completed: 10, failed: 7, pending: 3)

// Filter by status
for (final tx in allTransactions.completed) {
  print('✅ ${tx.transactionCode} — ${tx.amount} ${tx.currencyCode}');
}

for (final tx in allTransactions.failed) {
  print('❌ ${tx.transactionCode} — ${tx.message}');
}

for (final tx in allTransactions.pending) {
  print('⏳ ${tx.transactionCode} — ${tx.amount}');
}

// Filter by category
for (final tx in allTransactions.disbursements) {
  print('💸 ${tx.shortcode} — ${tx.amount}');
}

for (final tx in allTransactions.collections) {
  print('💰 ${tx.shortcode} — ${tx.amount}');
}
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `startDate` | `String` | ✅ | Start date in `YYYY-MM-DD` format |
| `endDate` | `String` | ✅ | End date in `YYYY-MM-DD` format |
| `currencyCode` | `String` | ✅ | Currency code e.g. `kes`, `cdf`, `ngn` |

**TransactionItem fields:**

| Field | Type | Nullable | Description |
|---|---|---|---|
| `id` | `int` | ❌ | Transaction ID |
| `transactionCode` | `String` | ❌ | Unique transaction code |
| `status` | `String` | ❌ | `COMPLETE`, `FAILED`, `PENDING` |
| `amount` | `String` | ❌ | Transaction amount |
| `amountInUsd` | `String` | ❌ | Equivalent USD amount |
| `type` | `String` | ❌ | e.g. `B2C`, `MOBILE` |
| `shortcode` | `String` | ❌ | Phone / shortcode used |
| `category` | `String` | ❌ | `DISBURSEMENT` or `COLLECTION` |
| `chain` | `String` | ❌ | Blockchain e.g. `CELO` |
| `mobileNetwork` | `String` | ❌ | e.g. `MPESA`, `Airtel Money` |
| `isReleased` | `bool` | ❌ | Whether funds are released |
| `createdAt` | `DateTime` | ❌ | Transaction timestamp |
| `receiptNumber` | `String?` | ✅ | Receipt number if available |
| `publicName` | `String?` | ✅ | Public name if available |
| `asset` | `String?` | ✅ | Crypto asset if applicable |
| `transactionHash` | `String?` | ✅ | On-chain hash if applicable |

---

### Get Transaction Status

Returns the status and details of a single transaction.

```dart
final status = await pretium.getTransactionStatus(
  transactionCode: "ebb8ee20-4e24-4360-bcd3-e4291b8d1cad",
  currencyCode: "kes",
);

print(status.status);        // COMPLETE
print(status.amount);        // 287541
print(status.currencyCode);  // KES
print(status.isComplete);    // true
print(status.isFailed);      // false
print(status.isPending);     // false
print(status.message);       // Transaction processed successfully.

// Nullable fields — always check before using
if (status.receiptNumber != null) {
  print(status.receiptNumber); // TI292XGAY9
}

if (status.accountNumber != null) {
  print(status.accountNumber);
}
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `transactionCode` | `String` | ✅ | Transaction code to look up |
| `currencyCode` | `String` | ✅ | Currency code e.g. `kes`, `ngn` |

**Response fields:**

| Field | Type | Nullable | Description |
|---|---|---|---|
| `id` | `int` | ❌ | Transaction ID |
| `transactionCode` | `String` | ❌ | Unique transaction code |
| `status` | `String` | ❌ | `COMPLETE`, `FAILED`, `PENDING` |
| `amount` | `String` | ❌ | Transaction amount |
| `amountInUsd` | `String` | ❌ | Equivalent USD amount |
| `type` | `String` | ❌ | e.g. `MOBILE`, `BANK_TRANSFER` |
| `shortcode` | `String` | ❌ | Phone / shortcode used |
| `category` | `String` | ❌ | `DISBURSEMENT` or `COLLECTION` |
| `chain` | `String` | ❌ | Blockchain e.g. `CELO` |
| `message` | `String` | ❌ | Status message from API |
| `currencyCode` | `String` | ❌ | Currency e.g. `KES` |
| `isReleased` | `bool` | ❌ | Whether funds are released |
| `createdAt` | `DateTime` | ❌ | Transaction timestamp |
| `accountNumber` | `String?` | ✅ | Bank account if applicable |
| `publicName` | `String?` | ✅ | Public name if available |
| `receiptNumber` | `String?` | ✅ | Receipt number if available |
| `asset` | `String?` | ✅ | Crypto asset if applicable |
| `transactionHash` | `String?` | ✅ | On-chain hash if applicable |

---

### Get Supported Banks

Returns supported banks for a given country.

```dart
final banks = await pretium.getSupportedBanks(countryCode: 'KE');

for (final bank in banks) {
  print('${bank.name}: ${bank.code}');
  // Equity Bank: 247247
}
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `countryCode` | `String` | ✅ | Country code e.g. `KE`, `NG`, `GH` |

---

### Initiate Bank Transfer

Disburse funds directly to a bank account. Nigeria requires extra fields.

```dart
// Kenya
final transfer = await pretium.initiateBankTransfer(BankTransferRequest(
  currencyCode: "KES",
  type: "BANK_TRANSFER",
  accountNumber: "011001100",
  bankCode: "247247",
  amount: "20",
  chain: "CELO",
  transactionHash: "0x55a572efe...",
  callbackUrl: "https://your-server.com/callback",
));

// Nigeria — extra fields required
final transfer = await pretium.initiateBankTransfer(BankTransferRequest(
  currencyCode: "NGN",
  type: "BANK_TRANSFER",
  accountNumber: "001918181",
  bankCode: "123455",
  amount: "500",
  chain: "CELO",
  transactionHash: "0x55a572efe...",
  callbackUrl: "https://your-server.com/callback",
  accountName: "John Doe",    // ✅ NGN only
  bankName: "Sterling Bank",  // ✅ NGN only
  fee: "10",                  // ✅ NGN only
));
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `currencyCode` | `String` | ✅ | Currency e.g. `KES`, `NGN` |
| `type` | `String` | ✅ | Transfer type e.g. `BANK_TRANSFER` |
| `accountNumber` | `String` | ✅ | Bank account number |
| `bankCode` | `String` | ✅ | Bank code from `getSupportedBanks()` |
| `amount` | `String` | ✅ | Amount to disburse |
| `chain` | `String` | ✅ | Blockchain e.g. `CELO`, `TRON` |
| `transactionHash` | `String` | ✅ | On-chain transaction hash |
| `callbackUrl` | `String` | ✅ | Webhook URL for status updates |
| `accountName` | `String?` | ⚠️ | Required for `NGN` only |
| `bankName` | `String?` | ⚠️ | Required for `NGN` only |
| `fee` | `String?` | ⚠️ | Required for `NGN` only |

> ⚠️ Passing `currencyCode: "NGN"` without `accountName`, `bankName`, and `fee` throws a `PretiumException(400)` before the request is made.

---

### Initiate Disburse (Mobile / Paybill / Till)

Disburse funds to a mobile number, paybill, or till number.

```dart
// MOBILE — send to a phone number
final disburse = await pretium.initiateDisburse(
  type: "MOBILE",
  shortCode: "0704333650",
  mobileNetwork: "Safaricom",
  amount: "20",
  fee: "0",
  chain: "CELO",
  transactionHash: "0x55a572efe...",
  callbackUrl: "https://your-server.com/callback",
  currencyCode: "KES",
);

// PAYBILL — accountNumber is required
final disburse = await pretium.initiateDisburse(
  type: "PAYBILL",
  shortCode: "247247",
  accountNumber: "011001100", // ✅ required for PAYBILL
  mobileNetwork: "Safaricom",
  amount: "20",
  fee: "0",
  chain: "CELO",
  transactionHash: "0x55a572efe...",
  callbackUrl: "https://your-server.com/callback",
  currencyCode: "KES",
);

// TILL — no accountNumber needed
final disburse = await pretium.initiateDisburse(
  type: "TILL",
  shortCode: "247247",
  mobileNetwork: "Safaricom",
  amount: "20",
  fee: "0",
  chain: "CELO",
  transactionHash: "0x55a572efe...",
  callbackUrl: "https://your-server.com/callback",
  currencyCode: "KES",
);
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `type` | `String` | ✅ | `MOBILE`, `PAYBILL`, or `TILL` |
| `shortCode` | `String` | ✅ | Phone number, paybill, or till number |
| `mobileNetwork` | `String` | ✅ | e.g. `Safaricom`, `MTN`, `Airtel` |
| `amount` | `String` | ✅ | Amount to disburse |
| `fee` | `String` | ✅ | Transaction fee |
| `chain` | `String` | ✅ | Blockchain e.g. `CELO`, `TRON` |
| `transactionHash` | `String` | ✅ | On-chain transaction hash |
| `callbackUrl` | `String` | ✅ | Webhook URL for status updates |
| `currencyCode` | `String` | ✅ | Currency e.g. `KES`, `NGN` |
| `accountNumber` | `String?` | ⚠️ | Required only when `type` is `PAYBILL` |

> ⚠️ Passing `type: "PAYBILL"` without `accountNumber` throws a `PretiumException(400)` before the request is made.

---

## On-Ramp (Fiat → Crypto)

Collect fiat from a mobile number and receive crypto to a wallet address.

```dart
final onRamp = await pretium.initiateOnRamp(
  shortCode: "0707023542",
  mobileNetwork: "Safaricom",
  amount: "20",
  fee: "0",
  chain: "CELO",
  asset: "USDT",
  walletAddress: "0x3Eaab84B42F9fCf2A9B3f2FDB83572B4153eE958",
  callbackUrl: "https://your-server.com/callback",
  currencyCode: "KES",
);
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `shortCode` | `String` | ✅ | Mobile number to collect from |
| `mobileNetwork` | `String` | ✅ | e.g. `Safaricom`, `MTN`, `Airtel` |
| `amount` | `String` | ✅ | Fiat amount to collect |
| `fee` | `String` | ✅ | Transaction fee |
| `chain` | `String` | ✅ | Blockchain e.g. `CELO`, `TRON` |
| `asset` | `String` | ✅ | Crypto asset e.g. `USDT`, `USDC` |
| `walletAddress` | `String` | ✅ | Destination wallet address |
| `callbackUrl` | `String` | ✅ | Webhook URL for status updates |
| `currencyCode` | `String` | ✅ | Currency e.g. `KES`, `NGN` |

---

## Validation

### Validate Nigeria Bank Account

Verify a Nigerian bank account number before initiating a transfer.

```dart
final result = await pretium.validateAccountNigeria(
  accountNumber: "8536409",
  bankCode: "100033",
);

print(result);
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `accountNumber` | `String` | ✅ | Bank account number to verify |
| `bankCode` | `String` | ✅ | Bank code from `getSupportedBanks()` |

---

### Validate Phone Number

Verify a mobile money number before initiating a disbursement.

```dart
final result = await pretium.validatePhoneNumber(
  type: "MOBILE",
  mobileNetwork: "Safaricom",
  shortCode: "0704333650",
  currencyCode: "KES",
);

print(result);
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `type` | `String` | ✅ | Transfer type e.g. `MOBILE` |
| `mobileNetwork` | `String` | ✅ | e.g. `Safaricom`, `MTN`, `Airtel` |
| `shortCode` | `String` | ✅ | Phone number to validate |
| `currencyCode` | `String` | ✅ | Currency e.g. `KES`, `NGN` |

---






## Getting API Credentials

Visit [docs.pretium.africa](https://docs.pretium.africa) to complete onboarding and receive your API key and sandbox access.