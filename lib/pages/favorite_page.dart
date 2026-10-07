import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../services/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return SafeArea(
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final favorites = products
              .where(
                (product) => state.isFavorite(
                  product.id,
                ),
              )
              .toList();

          return CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'My Favorite',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (favorites.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 70,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Belum ada favorite.',
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  sliver: SliverGrid.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.62,
                    ),
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final product = favorites[index];

                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailPage(
                                product: product,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
