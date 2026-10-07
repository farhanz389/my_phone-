class OrderItem {
  final String productId;
  final String name;
  final String image;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );
  }
}

class Order {
  final String id;
  final DateTime date;
  final List<OrderItem> items;
  final double total;
  final String paymentMethod;
  final String status;

  Order({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsData = json['items'] as List<dynamic>;

    return Order(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      items: itemsData
          .map(
            (item) => OrderItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(),
      total: (json['total'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      status: json['status'] as String,
    );
  }
}
