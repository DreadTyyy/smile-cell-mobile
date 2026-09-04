enum TypeProvider {
  telkomsel("telkomsel"), 
  indosat("indosat"),
  xl("xl"),
  smartfren("smartfren"),
  unknown("unknown");

  const TypeProvider(this.value);
  final String value;
}

enum TelcoType {
  pulsa("pulsa"),
  data("data");

  const TelcoType(this.value);

  final String value;
}

class TelcoModel {
  final String id;
  final TelcoType type;
  final String nominal;
  final String price;
  final String provider;
  final String? description;
  final bool isDiscount;
  final String? priceDiscount;

  const TelcoModel({
    required this.id,
    required this.type,
    required this.nominal,
    required this.price,
    required this.provider,
    this.description,
    required this.isDiscount,
    this.priceDiscount,

  });
}

class ProviderModel {
  final TypeProvider id;
  final String name;
  final String logoAsset;
  final List<String> prefix;

  const ProviderModel({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.prefix,
  });
}