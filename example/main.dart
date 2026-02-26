import 'package:pretium_sdk/exceptions/pretium_exception.dart';
import 'package:pretium_sdk/pretium_sdk.dart';

import 'constant.dart';

void main() async {
  final pretium = Pretium(
    apiKey: apiKey,
  );

  try {
    final account = await pretium.getAccount();
    final countries = await pretium.getCountries();
    final exchangeRate =
        await pretium.getExchangeRates(to: 'KES', buyingRate: true);
    final networks = await pretium.getNetworks();
    final wallets = await pretium.getWallets(countryId: 1);
    final banks = await pretium.getSupportedBanks(countryCode: "MWK");
    final bankTransfer = await pretium.initiateBankTransfer(
        type: "BANK_TRANSFER",
        accountNumber: "011001100",
        bankCode: "247247",
        amount: "20",
        chain: "CELO",
        transactionHash:
            "0x55a572efe1720250e442f38741477a4ff7f152e5cd208cc52f8222a1c2a13b",
        callbackUrl: "https://pretium.africa/callback",
        currencyCode: 'KES');
    final disburse = await pretium.initiateDisburse(
        type: "MOBILE",
        shortCode: "0704333650",
        mobileNetwork: "Safaricom",
        accountNumber: "247247", // Required if type is "PAYBILL"
        amount: "20",
        fee: "0",
        chain: "CELO",
        transactionHash:
            "0x55a572efe1720250e442f38741477a4ff7f152e5cd208cc52f8222a1c2a13b",
        callbackUrl: "https://pretium.africa/callback",
        currencyCode: 'KES');
    final onRamp = await pretium.initiateOnRamp(
        shortCode: "0707023542",
        mobileNetwork: "Safaricom",
        amount: "20",
        fee: "0",
        chain: "CELO",
        asset: 'USDT',
        walletAddress: '0x3Eaab84B42F9fCf2A9B3f2FDB83572B4153eE958',
        callbackUrl: "https://pretium.africa/callback",
        currencyCode: 'KES');
    final validateAccount = await pretium.validateAccountNigeria(
      accountNumber: "8536409",
      bankCode: "100033"

    );

    print(validateAccount);

  } on PretiumException catch (e) {
    print('API Error [${e.code}]: ${e.message}');
  } catch (e) {
    print('Unexpected error: $e');
  }
}
