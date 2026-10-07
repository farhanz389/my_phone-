import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

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
        title: const Text('Product Detail'),
        actions: [
          ListenableBuilder(
            listenable: state,
            builder: (context, _) {
              final favorite = state.isFavorite(
                product.id,
              );

              return IconButton(
                onPressed: () {
                  state.toggleFavorite(
                    product.id,
                  );
                },
                icon: Icon(
                  favorite ? Icons.favorite : Icons.favorite_border,
                  color: favorite ? Colors.red : null,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              product.brand,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                const SizedBox(width: 5),
                Text(
                  product.rating.toString(),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              formatPrice(product.price),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Specifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            specification(
              'RAM',
              product.ram,
            ),
            specification(
              'Storage',
              product.storage,
            ),
            specification(
              'Camera',
              product.camera,
            ),
            specification(
              'Battery',
              product.battery,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await state.addToCart(
                    product.id,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Produk berhasil ditambahkan ke cart.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                label: const Text(
                  'ADD TO CART',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget specification(
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
