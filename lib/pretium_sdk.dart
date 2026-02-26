import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:pretium_sdk/src/account/account_info_model.dart';
import 'package:pretium_sdk/src/account/country_model.dart';
import 'package:pretium_sdk/src/account/exchange_rate_model.dart';
import 'package:pretium_sdk/src/account/networks_model.dart';
import 'package:pretium_sdk/src/account/wallet_model.dart';
import 'package:pretium_sdk/src/disburse/disburse_model.dart';
import 'package:pretium_sdk/src/onramp/onramp_model.dart';
import 'package:pretium_sdk/src/phone_number_verification/phone_number_verification_model.dart';
import 'package:pretium_sdk/src/transactions/all_transactions/all_transaction_model.dart';
import 'package:pretium_sdk/src/transactions/bank_transfer_nigeria/bank_transfer_nigeria_model.dart';
import 'package:pretium_sdk/src/transactions/bank_transfers/bank_transfer_model.dart';
import 'package:pretium_sdk/src/transactions/supported_banks/supported_banks_model.dart';
import 'package:pretium_sdk/src/transactions/transaction_status/transaction_status_model.dart';
import 'package:pretium_sdk/src/transactions/validate_account_nigeria/validate_account_nigeria_model.dart';

import 'exceptions/pretium_exception.dart';

class Pretium {
  final String apiKey;
  late final Dio _dio;

  Pretium({
    required this.apiKey,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.xwift.africa',
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    ));
  }

  dynamic _parse(dynamic data) {
    return data is String ? jsonDecode(data) : data;
  }

  Never _handleError(DioException e) {
    if (e.response != null) {
      final json = _parse(e.response!.data);

      if (json is Map && json.containsKey('message')) {
        throw PretiumException(
          code: json['code'] ?? e.response!.statusCode ?? 0,
          message: json['message'],
        );
      }

      throw PretiumException(
        code: e.response!.statusCode ?? 500,
        message: 'Internal server error. Please try again later.',
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw PretiumException(code: 0, message: 'Connection timed out.');
      case DioExceptionType.receiveTimeout:
        throw PretiumException(
            code: 0, message: 'Server took too long to respond.');
      case DioExceptionType.connectionError:
        throw PretiumException(code: 0, message: 'No internet connection.');
      default:
        throw PretiumException(code: 0, message: 'Something went wrong.');
    }
  }

  Future<AccountInfoModel> getAccount() async {
    try {
      final response = await _dio.post('/account/detail');
      return AccountInfoModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await _dio.post('/account/countries');
      final json = _parse(response.data);
      return (json['data'] as List)
          .map((c) => CountryModel.fromJson(c))
          .toList();
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<ExchangeRateModel> getExchangeRates({
    required String to,
    required bool buyingRate,
  }) async {
    try {
      final response = await _dio.post(
        '/account/exchange-rate',
        data: {
          'buying_rate': buyingRate,
          'to': to,
        },
      );
      return ExchangeRateModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<List<NetworkModel>> getNetworks() async {
    try {
      final response = await _dio.post('/account/networks');
      final json = _parse(response.data);
      return (json['data'] as List)
          .map((c) => NetworkModel.fromJson(c))
          .toList();
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<WalletModel> getWallets({required int countryId}) async {
    try {
      final response = await _dio.post('/account/wallet/$countryId');
      return WalletModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<List<SupportedBanksModel>> getSupportedBanks(
      {required String countryCode}) async {
    try {
      final response = await _dio.post(
          countryCode == "NGN" || countryCode == "ngn"
              ? '/v1/banks'
              : '/v1/banks/$countryCode');
      final json = _parse(response.data);
      return (json['data'] as List)
          .map((c) => SupportedBanksModel.fromJson(c))
          .toList();
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<BankTransferModel> initiateBankTransfer({
    required String type,
    required String accountNumber,
    required String bankCode,
    required String amount,
    required String chain,
    required String transactionHash,
    required String callbackUrl,
    required String currencyCode,
    // 👇 Nigeria-only fields
    String? accountName,
    String? bankName,
    String? fee,
  }) async {
    if (currencyCode == "NGN") {
      if (accountName == null || accountName.isEmpty) {
        throw PretiumException(
          code: 400,
          message: 'accountName is required for NGN transfers.',
        );
      }
      if (bankName == null || bankName.isEmpty) {
        throw PretiumException(
          code: 400,
          message: 'bankName is required for NGN transfers.',
        );
      }
      if (fee == null || fee.isEmpty) {
        throw PretiumException(
          code: 400,
          message: 'fee is required for NGN transfers.',
        );
      }
    }

    try {
      final response = await _dio.post(
        '/v1/pay/$currencyCode',
        data: {
          "type": type,
          "account_number": accountNumber,
          "bank_code": bankCode,
          "amount": amount,
          "chain": chain,
          "transaction_hash": transactionHash,
          "callback_url": callbackUrl,
          // 👇 only added when provided (Nigeria)
          if (accountName != null) "account_name": accountName,
          if (bankName != null) "bank_name": bankName,
          if (fee != null) "fee": fee,
        },
      );
      return BankTransferModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<DisburseModel> initiateDisburse({
    required String type,
    required String shortCode,
    required String amount,
    required String chain,
    required String mobileNetwork,
    required String transactionHash,
    required String callbackUrl,
    required String currencyCode,
    String? accountNumber,
    required String fee,
  }) async {
    if (type == "PAYBILL" && (accountNumber == null || accountNumber.isEmpty)) {
      throw PretiumException(
        code: 400,
        message: 'accountNumber is required when type is PAYBILL.',
      );
    }

    try {
      final response = await _dio.post(
        '/v1/pay/$currencyCode',
        data: {
          "type": type,
          "shortcode": shortCode,
          "amount": amount,
          "mobile_network": mobileNetwork,
          "chain": chain,
          "fee": fee,
          "transaction_hash": transactionHash,
          "callback_url": callbackUrl,
          if (accountNumber != null) "account_number": accountNumber,
        },
      );
      return DisburseModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<OnRampInitiateResponse> initiateOnRamp({
    required String shortCode,
    required String amount,
    required String chain,
    required String asset,
    required String walletAddress,
    required String fee,
    required String callbackUrl,
    required String currencyCode,
    required String mobileNetwork,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/onramp/$currencyCode',
        data: {
          "shortcode": shortCode,
          "amount": amount,
          "mobile_network": mobileNetwork,
          "chain": chain,
          "fee": fee,
          "asset": asset,
          "address": walletAddress,
          "callback_url": callbackUrl,
        },
      );

      final json = _parse(response.data);
      return OnRampInitiateResponse.fromJson(json);
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<ValidateAccountNigeriaModel> validateAccountNigeria(
      {required String bankCode, required String accountNumber}) async {
    try {
      final response = await _dio.post('/v1/validation/NGN',
          data: {"account_number": accountNumber, "bank_code": bankCode});
      return ValidateAccountNigeriaModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<BankTransferNigeriaModel> initiateBankTransferNigeria(
      {required String type,
      required String accountNumber,
      required String bankCode,
      required String amount,
      required String chain,
      required String transactionHash,
      required String callbackUrl,
      required String currencyCode}) async {
    try {
      final response = await _dio.post(
        '/v1/pay/$currencyCode',
        data: {
          "type": type,
          "account_number": accountNumber,
          "bank_code": bankCode,
          "amount": amount,
          "chain": chain,
          "transaction_hash": transactionHash,
          "callback_url": callbackUrl,
        },
      );
      return BankTransferNigeriaModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  Future<PhoneNumberVerificationModel> validatePhoneNumber({
    required String currencyCode,
    required String type,
    required String shortCode,
    required String mobileNetwork,
  }) async {
    try {
      final response = await _dio.post('/v1/validation/$currencyCode',
      data: {
        "type": type,
        "shortcode": shortCode,
        "mobile_network": mobileNetwork
      });
      return PhoneNumberVerificationModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }
  Future<AllTransactionsModel> getTransactions({
    required String startDate,
    required String endDate,
    required String currencyCode
  }) async {
    try {
      final response = await _dio.post(
        '/account/$currencyCode/transactions',
        data: {
          "start_date": startDate,
          "end_date": endDate,
        },
      );
      return AllTransactionsModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }
  Future<TransactionStatusModel> getTransactionStatus({
    required String transactionCode,
    required String currencyCode,
  }) async {
    try {
      final response = await _dio.post(
        '/$currencyCode/status',
        data: {
          "transaction_code": transactionCode,
        },
      );
      return TransactionStatusModel.fromJson(_parse(response.data));
    } on DioException catch (e) {
      _handleError(e);
    }
  }
}
