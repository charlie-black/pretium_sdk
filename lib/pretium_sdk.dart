// lib/pretium_sdk.dart
// ──────────────────────────────────────────────────────────────────────────────
// Public entry point of the pretium_sdk package
//
// Users should import only this file:
// import 'package:pretium_sdk/pretium_sdk.dart';
//
// All internal src/ paths are hidden from the outside world.
// ──────────────────────────────────────────────────────────────────────────────

library pretium_sdk;

// Models
export 'src/account/account_info_model.dart';
export 'src/account/country_model.dart';
export 'src/account/exchange_rate_model.dart';
export 'src/account/wallet_model.dart';
export 'src/disburse/disburse_model.dart';
export 'src/onramp/onramp_model.dart';
export 'src/phone_number_verification/phone_number_verification_model.dart';

export 'src/transactions/all_transactions/all_transaction_model.dart';
export 'src/transactions/bank_transfer_nigeria/bank_transfer_nigeria_model.dart';
export 'src/transactions/bank_transfers/bank_transfer_model.dart';
export 'src/transactions/supported_banks/supported_banks_model.dart';
export 'src/transactions/transaction_status/transaction_status_model.dart';
export 'src/transactions/validate_account_nigeria/validate_account_nigeria_model.dart';
export 'src/pretium.dart';