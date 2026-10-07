import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/product_data.dart';
import '../models/order.dart';

class AppState extends ChangeNotifier {
  AppState._();

  static final AppState instance = AppState._();

  SharedPreferences? _prefs;

  String? _email;

  String? profilePhotoBase64;

  Set<String> favoriteIds = {};

  Map<String, int> cartItems = {};

  List<Order> orders = [];

  String? get email => _email;

  bool get isLoggedIn => _email != null;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    _email = _prefs!.getString('email');

    profilePhotoBase64 = _prefs!.getString('profilePhoto');

    favoriteIds = Set<String>.from(
      _prefs!.getStringList('favorites') ?? [],
    );

    final savedCart = _prefs!.getString('cart');

    if (savedCart != null) {
      final Map<String, dynamic> decoded = jsonDecode(savedCart);

      cartItems = decoded.map(
        (key, value) => MapEntry(
          key,
          (value as num).toInt(),
        ),
      );
    }

    final savedOrders = _prefs!.getString('orders');

    if (savedOrders != null) {
      final List<dynamic> decodedOrders = jsonDecode(savedOrders);

      orders = decodedOrders
          .map(
            (item) => Order.fromJson(
              Map<String, dynamic>.from(
                item as Map,
              ),
            ),
          )
          .toList();
    }
  }

  // ============================================================
  // REGISTER
  // ============================================================

  Future<bool> register(
    String email,
    String password,
  ) async {
    final users = _prefs!.getStringList('users') ?? [];

    final exists = users.any(
      (user) => user.split('|').first == email,
    );

    if (exists) {
      return false;
    }

    users.add('$email|$password');

    await _prefs!.setStringList(
      'users',
      users,
    );

    return true;
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<bool> login(
    String email,
    String password,
  ) async {
    final users = _prefs!.getStringList('users') ?? [];

    final valid = users.any((user) {
      final parts = user.split('|');

      return parts.length == 2 && parts[0] == email && parts[1] == password;
    });

    if (!valid) {
      return false;
    }

    _email = email;

    await _prefs!.setString(
      'email',
      email,
    );

    notifyListeners();

    return true;
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    _email = null;

    await _prefs!.remove('email');

    notifyListeners();
  }

  // ============================================================
  // PROFILE PHOTO
  // ============================================================

  Future<void> saveProfilePhoto(
    String base64Photo,
  ) async {
    profilePhotoBase64 = base64Photo;

    await _prefs!.setString(
      'profilePhoto',
      base64Photo,
    );

    notifyListeners();
  }

  Future<void> removeProfilePhoto() async {
    profilePhotoBase64 = null;

    await _prefs!.remove('profilePhoto');

    notifyListeners();
  }

  // ============================================================
  // FAVORITE
  // ============================================================

  bool isFavorite(String productId) {
    return favoriteIds.contains(productId);
  }

  Future<void> toggleFavorite(
    String productId,
  ) async {
    if (favoriteIds.contains(productId)) {
      favoriteIds.remove(productId);
    } else {
      favoriteIds.add(productId);
    }

    await _prefs!.setStringList(
      'favorites',
      favoriteIds.toList(),
    );

    notifyListeners();
  }

  // ============================================================
  // CART
  // ============================================================

  Future<void> addToCart(
    String productId,
  ) async {
    cartItems[productId] = (cartItems[productId] ?? 0) + 1;

    await _saveCart();

    notifyListeners();
  }

  Future<void> removeFromCart(
    String productId,
  ) async {
    if (!cartItems.containsKey(productId)) {
      return;
    }

    final quantity = cartItems[productId]!;

    if (quantity <= 1) {
      cartItems.remove(productId);
    } else {
      cartItems[productId] = quantity - 1;
    }

    await _saveCart();

    notifyListeners();
  }

  Future<void> clearCart() async {
    cartItems.clear();

    await _saveCart();

    notifyListeners();
  }

  Future<void> _saveCart() async {
    await _prefs!.setString(
      'cart',
      jsonEncode(cartItems),
    );
  }

  // ============================================================
  // CREATE ORDER
  // ============================================================

  Future<Order> createOrder(
    String paymentMethod,
  ) async {
    final List<OrderItem> items = [];

    double total = 0;

    for (final entry in cartItems.entries) {
      final productId = entry.key;
      final quantity = entry.value;

      final product = products.firstWhere(
        (item) => item.id == productId,
      );

      final orderItem = OrderItem(
        productId: product.id,
        name: product.name,
        image: product.image,
        price: product.price,
        quantity: quantity,
      );

      items.add(orderItem);

      total += product.price * quantity;
    }

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: items,
      total: total,
      paymentMethod: paymentMethod,
      status: 'TERBAYAR',
    );

    orders.insert(0, order);

    await _saveOrders();

    await clearCart();

    notifyListeners();

    return order;
  }

  Future<void> _saveOrders() async {
    final data = orders.map((order) => order.toJson()).toList();

    await _prefs!.setString(
      'orders',
      jsonEncode(data),
    );
  }
}
