class PaymentMethod {
  final String id;
  final String name;
  final String accountNumber;
  final String logoAsset;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.logoAsset,
  });

  String get logoPath => "assets/$logoAsset";

  String get transferLabel => "BANK $name";
}