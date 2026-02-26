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

  @override
  String toString() => 'NetworkAsset($name)';
}

class NetworkModel {
  final String name;
  final String icon;
  final String settlementWalletAddress;
  final bool checkoutStatus;
  final List<NetworkAsset> assets;

  NetworkModel({
    required this.name,
    required this.icon,
    required this.settlementWalletAddress,
    required this.checkoutStatus,
    required this.assets,
  });

  factory NetworkModel.fromJson(Map<String, dynamic> json) {
    return NetworkModel(
      name: json['name'],
      icon: json['icon'],
      settlementWalletAddress: json['settlement_wallet_address'],
      checkoutStatus: json['checkout_status'],
      assets: (json['assets'] as List)
          .map((a) => NetworkAsset.fromJson(a))
          .toList(),
    );
  }

  @override
  String toString() => 'Network($name, active: $checkoutStatus)';
}