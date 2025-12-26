import 'dart:io';
import 'dart:convert';
import 'package:exam_dart/exam_dart.dart';

/// Chuỗi JSON mẫu ban đầu
const String initialJsonString = '''
[{"Item": "A1000","ItemName": "Iphone 15","Price": 1200,"Currency":  "USD","Quantity": 1},{"Item": "A1001","ItemName": "Iphone 16","Price":  1500,"Currency": "USD","Quantity": 1}]
''';

void main() {
  // Khởi tạo danh sách đơn hàng từ JSON mẫu
  List<Order> orders = parseOrdersFromJson(initialJsonString);

  print('=== CHƯƠNG TRÌNH QUẢN LÝ ĐƠN HÀNG ===\n');

  // Hiển thị danh sách đơn hàng ban đầu
  print('Danh sách đơn hàng ban đầu:');
  displayOrders(orders);
  print('');

  // Menu chính
  bool running = true;
  while (running) {
    printMenu();
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        displayOrders(orders);
        break;
      case '2':
        orders = addNewOrder(orders);
        break;
      case '3':
        searchOrders(orders);
        break;
      case '4':
        saveToJsonFile(orders);
        break;
      case '5':
        print('Cảm ơn bạn đã sử dụng chương trình!');
        running = false;
        break;
      default:
        print('Lựa chọn không hợp lệ. Vui lòng chọn lại.\n');
    }
  }
}

/// Hiển thị menu chính
void printMenu() {
  print('--- MENU ---');
  print('1. Hiển thị danh sách đơn hàng');
  print('2. Thêm đơn hàng mới');
  print('3. Tìm kiếm đơn hàng');
  print('4. Lưu danh sách vào file JSON');
  print('5. Thoát');
  print('Chọn chức năng (1-5): ');
}

/// Tạo chuỗi lặp lại ký tự
String _repeatString(String char, int count) {
  return List.filled(count, char).join();
}

/// Hiển thị danh sách đơn hàng dưới dạng bảng
void displayOrders(List<Order> orders) {
  if (orders.isEmpty) {
    print('Danh sách đơn hàng trống.\n');
    return;
  }

  String separator = _repeatString('=', 80);
  print('\n$separator');
  print('STT'.padRight(5) + 'Item'.padRight(10) + 'Tên sản phẩm'.padRight(25) + 
        'Giá'.padRight(15) + 'Tiền tệ'.padRight(10) + 'Số lượng'.padRight(10));
  print(separator);

  for (int i = 0; i < orders.length; i++) {
    final order = orders[i];
    print('${(i + 1).toString().padRight(5)}${order.item.padRight(10)}${order.itemName.padRight(25)}'
        '${order.price.toStringAsFixed(2).padRight(15)}${order.currency.padRight(10)}${order.quantity.toString().padRight(10)}');
  }

  print('$separator\n');
}

/// Thêm đơn hàng mới từ bàn phím
List<Order> addNewOrder(List<Order> orders) {
  print('\n--- THÊM ĐƠN HÀNG MỚI ---');

  try {
    print('Nhập mã sản phẩm (Item): ');
    String? item = stdin.readLineSync();
    if (item == null || item.trim().isEmpty) {
      print('Mã sản phẩm không được để trống!\n');
      return orders;
    }

    print('Nhập tên sản phẩm (ItemName): ');
    String? itemName = stdin.readLineSync();
    if (itemName == null || itemName.trim().isEmpty) {
      print('Tên sản phẩm không được để trống!\n');
      return orders;
    }

    print('Nhập giá (Price): ');
    String? priceInput = stdin.readLineSync();
    if (priceInput == null || priceInput.trim().isEmpty) {
      print('Giá không được để trống!\n');
      return orders;
    }
    double price = double.parse(priceInput.trim());

    print('Nhập loại tiền tệ (Currency): ');
    String? currency = stdin.readLineSync();
    if (currency == null || currency.trim().isEmpty) {
      print('Loại tiền tệ không được để trống!\n');
      return orders;
    }

    print('Nhập số lượng (Quantity): ');
    String? quantityInput = stdin.readLineSync();
    if (quantityInput == null || quantityInput.trim().isEmpty) {
      print('Số lượng không được để trống!\n');
      return orders;
    }
    int quantity = int.parse(quantityInput.trim());

    // Tạo đơn hàng mới
    Order newOrder = Order(
      item: item.trim(),
      itemName: itemName.trim(),
      price: price,
      currency: currency.trim(),
      quantity: quantity,
    );

    // Thêm vào danh sách
    orders.add(newOrder);
    print('\n✓ Đã thêm đơn hàng mới thành công!\n');
    displayOrders(orders);

    return orders;
  } catch (e) {
    print('Lỗi: $e. Vui lòng nhập lại.\n');
    return orders;
  }
}

/// Tìm kiếm đơn hàng theo tên sản phẩm
void searchOrders(List<Order> orders) {
  print('\n--- TÌM KIẾM ĐƠN HÀNG ---');
  print('Nhập tên sản phẩm cần tìm: ');
  String? searchTerm = stdin.readLineSync();

  if (searchTerm == null || searchTerm.trim().isEmpty) {
    print('Từ khóa tìm kiếm không được để trống!\n');
    return;
  }

  String keyword = searchTerm.trim().toLowerCase();
  List<Order> foundOrders = orders
      .where((order) => order.itemName.toLowerCase().contains(keyword))
      .toList();

  if (foundOrders.isEmpty) {
    print('\nKhông tìm thấy đơn hàng nào có tên chứa "$searchTerm".\n');
  } else {
    print('\nTìm thấy ${foundOrders.length} đơn hàng:');
    displayOrders(foundOrders);
  }
}

/// Lưu danh sách đơn hàng vào file JSON
void saveToJsonFile(List<Order> orders) {
  try {
    String jsonString = ordersToJsonString(orders);
    File file = File('order.json');
    file.writeAsStringSync(jsonString, encoding: utf8);
    print('\n✓ Đã lưu ${orders.length} đơn hàng vào file order.json thành công!\n');
  } catch (e) {
    print('Lỗi khi lưu file: $e\n');
  }
}
