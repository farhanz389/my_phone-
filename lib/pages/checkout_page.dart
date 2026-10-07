import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../models/order.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';
import 'receipt_page.dart' as receipt;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _paymentMethod = 'Transfer Bank';
  bool _isSubmitting = false;

  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  Future<void> _submitOrder() async {
    setState(() => _isSubmitting = true);

    try {
      final order = await AppState.instance.createOrder(_paymentMethod);

      if (!mounted) return;

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => receipt.ReceiptPage(order: order),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final cartProducts = products
              .where((product) => state.cartItems.containsKey(product.id))
              .toList();
          final total = cartProducts.fold<double>(
            0,
            (sum, product) =>
                sum + product.price * (state.cartItems[product.id] ?? 0),
          );

          if (cartProducts.isEmpty) {
            return const Center(child: Text('Keranjang masih kosong'));
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Ringkasan Pesanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...cartProducts.map((product) {
                final quantity = state.cartItems[product.id] ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(child: Text('${product.name} x$quantity')),
                      Text(_formatPrice(product.price * quantity)),
                    ],
                  ),
                );
              }),
              const Divider(height: 28),
              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...['Transfer Bank', 'E-Wallet', 'COD'].map(
                (method) => RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(method),
                  value: method,
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _paymentMethod = value);
                    }
                  },
                ),
              ),
              const Divider(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _formatPrice(total),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitOrder,
                  child: _isSubmitting
                      ? const CircularProgressIndicator()
                      : const Text('BUAT PESANAN'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ReceiptPage extends StatelessWidget {
  final Order order;

  const ReceiptPage({
    super.key,
    required this.order,
  });

  String formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]}.',
        )}';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Struk Pembayaran',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 15),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Pembayaran Berhasil!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Pesanan kamu telah berhasil dibuat.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  18,
                ),
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  receiptRow(
                    'Order ID',
                    order.id,
                  ),
                  receiptRow(
                    'Tanggal',
                    formatDate(
                      order.date,
                    ),
                  ),
                  receiptRow(
                    'Pembayaran',
                    order.paymentMethod,
                  ),
                  receiptRow(
                    'Status',
                    order.status,
                    valueColor: AppColors.success,
                  ),
                  const Divider(
                    height: 30,
                  ),
                  const Text(
                    'Pesanan',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...order.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.name} x${item.quantity}',
                            ),
                          ),
                          Text(
                            formatPrice(
                              item.subtotal,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'TOTAL',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatPrice(
                          order.total,
                        ),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
                child: const Text(
                  'KEMBALI KE HOME',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  'LIHAT PESANAN',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget receiptRow(
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
