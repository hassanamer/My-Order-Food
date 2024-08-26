class OrderItemModel {
  String userId;
  String itemName;
  int quantity;
  double? price;
  double? itemTotalPrice;

  OrderItemModel({
    required this.userId,
    required this.itemName,
    this.quantity = 0,
    this.price,
    this.itemTotalPrice,
  });

  Map<String, dynamic> toMap() {
    // ignore: always_specify_types
    return {
      'userId': userId,
      'price': price,
      'itemName': itemName,
      'quantity': quantity,
      'itemTotalPrice': itemTotalPrice,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      itemName: map['itemName'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      userId: map['userId'] ?? '',
      price: map['price'],
      itemTotalPrice: map['itemTotalPrice'],
    );
  }
}
