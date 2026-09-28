class BillInformation {
  final String key;
  final String value;

  const BillInformation({
    required this.key,
    required this.value
  });
}

class DetailBillModel {
  final List<BillInformation> information;
  final double price;
  final double fee;
  final double discount;

  const DetailBillModel({
    required this.information,
    required this.price,
    required this.fee,
    required this.discount,
  });
}

class BillProduct {
  final String name;
  final String description;
  final String imageAsset;

  const BillProduct({
    required this.name,
    required this.description,
    required this.imageAsset,
  });
}