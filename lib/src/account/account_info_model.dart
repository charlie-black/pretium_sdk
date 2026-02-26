class Wallet {
  final int id;
  final double balance;
  final String currency;
  final String countryName;

  Wallet({
    required this.id,
    required this.balance,
    required this.currency,
    required this.countryName,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      balance: double.parse(json['balance'].toString()),
      currency: json['currency'],
      countryName: json['country_name'],
    );
  }

  @override
  String toString() => 'Wallet($currency: $balance - $countryName)';
}

class NetworkAsset {
  final String name;
  final String icon;
  final String contractAddress;
  final bool checkoutStatus;

  NetworkAsset({
    required this.name,
    required this.icon,
    required this.contractAddress,
    required this.checkoutStatus,
  });

  factory NetworkAsset.fromJson(Map<String, dynamic> json) {
    return NetworkAsset(
      name: json['name'],
      icon: json['icon'],
      contractAddress: json['contract_address'],
      checkoutStatus: json['checkout_status'],
    );
  }
}

class Network {
  final String name;
  final String icon;
  final String settlementWalletAddress;
  final bool checkoutStatus;
  final List<NetworkAsset> assets;

  Network({
    required this.name,
    required this.icon,
    required this.settlementWalletAddress,
    required this.checkoutStatus,
    required this.assets,
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      name: json['name'],
      icon: json['icon'],
      settlementWalletAddress: json['settlement_wallet_address'],
      checkoutStatus: json['checkout_status'],
      assets: (json['assets'] as List)
          .map((a) => NetworkAsset.fromJson(a))
          .toList(),
    );
  }
}

class AccountInfoModel {
  final int id;
  final String name;
  final String email;
  final String status;
  final String checkoutKey;
  final List<Wallet> wallets;
  final List<Network> networks;
  final DateTime createdAt;

  AccountInfoModel({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.checkoutKey,
    required this.wallets,
    required this.networks,
    required this.createdAt,
  });

  factory AccountInfoModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return AccountInfoModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      status: data['status'],
      checkoutKey: data['checkout_key'],
      wallets: (data['wallets'] as List)
          .map((w) => Wallet.fromJson(w))
          .toList(),
      networks: (data['networks'] as List)
          .map((n) => Network.fromJson(n))
          .toList(),
      createdAt: DateTime.parse(data['created_at']),
    );
  }

  @override
  String toString() {
    return 'AccountInfo(id: $id, name: $name, email: $email, status: $status)';
  }
}