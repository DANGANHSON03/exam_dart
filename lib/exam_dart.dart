import 'dart:convert';

/// Lớp Order đại diện cho một đơn hàng
class Order {
  final String item;
  final String itemName;
  final double price;
  final String currency;
  final int quantity;

  /// Constructor chính
  Order({
    required this.item,
    required this.itemName,
    required this.price,
    required this.currency,
    required this.quantity,
  });

  /// Constructor từ JSON Map
  Order.fromJson(Map<String, dynamic> json)
      : item = json['Item'] as String,
        itemName = json['ItemName'] as String,
        price = (json['Price'] as num).toDouble(),
        currency = json['Currency'] as String,
        quantity = json['Quantity'] as int;

  /// Chuyển đổi Order thành JSON Map
  Map<String, dynamic> toJson() => {
        'Item': item,
        'ItemName': itemName,
        'Price': price,
        'Currency': currency,
        'Quantity': quantity,
      };

  /// Chuyển đổi Order thành chuỗi JSON
  String toJsonString() => jsonEncode(toJson());

  /// Hiển thị thông tin đơn hàng dưới dạng chuỗi
  @override
  String toString() {
    return 'Item: $item | Tên: $itemName | Giá: $price $currency | Số lượng: $quantity';
  }
}

/// Chuyển đổi chuỗi JSON thành danh sách Order
List<Order> parseOrdersFromJson(String jsonString) {
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Order.fromJson(json as Map<String, dynamic>)).toList();
}

/// Chuyển đổi danh sách Order thành chuỗi JSON
String ordersToJsonString(List<Order> orders) {
  final List<Map<String, dynamic>> jsonList = orders.map((order) => order.toJson()).toList();
  return jsonEncode(jsonList);
}
