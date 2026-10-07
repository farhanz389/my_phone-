import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final cartProducts = products
              .where(
                (product) => state.cartItems.containsKey(product.id),
              )
              .toList();

          if (cartProducts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          double total = 0;

          for (final product in cartProducts) {
            final quantity = state.cartItems[product.id] ?? 0;

            total += product.price * quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(
                    16,
                  ),
                  itemCount: cartProducts.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 12,
                  ),
                  itemBuilder: (context, index) {
                    final product = cartProducts[index];

                    final quantity = state.cartItems[product.id] ?? 0;

                    return Container(
                      padding: const EdgeInsets.all(
                        12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          16,
                        ),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            padding: const EdgeInsets.all(
                              6,
                            ),
                            child: Image.asset(
                              product.image,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.phone_android,
                                size: 45,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  formatPrice(
                                    product.price,
                                  ),
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        state.removeFromCart(
                                          product.id,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                    ),
                                    Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        state.addToCart(
                                          product.id,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(
                  20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            formatPrice(
                              total,
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutPage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.payments_outlined,
                          ),
                          label: const Text(
                            'CHECKOUT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
