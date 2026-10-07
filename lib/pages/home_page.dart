import 'package:flutter/material.dart';

import '../data/product_data.dart';
import '../theme/app_colors.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'favorite_page.dart';
import 'product_detail_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  String selectedBrand = 'All';
  String searchQuery = '';

  final searchController = TextEditingController();

  final brands = [
    'All',
    'Apple',
    'Samsung',
    'Xiaomi',
    'OPPO',
    'Vivo',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List get filteredProducts {
    return products.where((product) {
      final matchBrand =
          selectedBrand == 'All' || product.brand == selectedBrand;

      final query = searchQuery.toLowerCase();

      final matchSearch = product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);

      return matchBrand && matchSearch;
    }).toList();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHome(),
      const FavoritePage(),
      const CartPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: changePage,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_border,
            ),
            selectedIcon: Icon(
              Icons.favorite,
            ),
            label: 'Favorite',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.shopping_cart_outlined,
            ),
            selectedIcon: Icon(
              Icons.shopping_cart,
            ),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline,
            ),
            selectedIcon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              20,
              25,
              20,
              10,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hello 👋',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Find your smartphone',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: 'Search smartphone...',
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Brands',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 42,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: brands.length,
                      separatorBuilder: (_, __) => const SizedBox(
                        width: 8,
                      ),
                      itemBuilder: (context, index) {
                        final brand = brands[index];

                        final selected = selectedBrand == brand;

                        return ChoiceChip(
                          label: Text(brand),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              selectedBrand = brand;
                            });
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : AppColors.text,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${filteredProducts.length} products',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (filteredProducts.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text(
                  'Produk tidak ditemukan.',
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];

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
          const SliverPadding(
            padding: EdgeInsets.only(
              bottom: 20,
            ),
          ),
        ],
      ),
    );
  }
}
