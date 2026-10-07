import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/app_state.dart';
import '../theme/app_colors.dart';
import 'cart_page.dart';
import 'favorite_page.dart';
import 'login_page.dart';
import 'order_history_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loadingPhoto = false;

  Future<void> pickProfilePhoto() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 700,
        maxHeight: 700,
      );

      if (image == null) return;

      setState(() {
        loadingPhoto = true;
      });

      final bytes = await image.readAsBytes();

      final encoded = base64Encode(bytes);

      await AppState.instance.saveProfilePhoto(encoded);

      if (!mounted) return;

      setState(() {
        loadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Foto profil berhasil diperbarui.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memilih foto: $e',
          ),
        ),
      );
    }
  }

  Future<void> removePhoto() async {
    await AppState.instance.removeProfilePhoto();
  }

  Future<void> logout() async {
    await AppState.instance.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: state,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // FOTO PROFIL
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                        child: state.profilePhotoBase64 == null
                            ? const Icon(
                                Icons.person,
                                size: 65,
                                color: Colors.white,
                              )
                            : ClipOval(
                                child: Image.memory(
                                  base64Decode(
                                    state.profilePhotoBase64!,
                                  ),
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              ),
                      ),
                      GestureDetector(
                        onTap: loadingPhoto ? null : pickProfilePhoto,
                        child: Container(
                          padding: const EdgeInsets.all(
                            10,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: loadingPhoto
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: pickProfilePhoto,
                    child: const Text(
                      'Ubah Foto Profil',
                    ),
                  ),

                  if (state.profilePhotoBase64 != null)
                    TextButton(
                      onPressed: removePhoto,
                      child: const Text(
                        'Hapus Foto',
                        style: TextStyle(
                          color: AppColors.danger,
                        ),
                      ),
                    ),

                  const SizedBox(height: 5),

                  const Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    state.email ?? 'User',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ACCOUNT
                  profileMenu(
                    icon: Icons.person_outline,
                    title: 'Account',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            'Account',
                          ),
                          content: Text(
                            'Email:\n${state.email ?? '-'}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Tutup',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // MY ORDERS
                  profileMenu(
                    icon: Icons.receipt_long_outlined,
                    title: 'My Orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OrderHistoryPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // FAVORITE
                  profileMenu(
                    icon: Icons.favorite_border,
                    title: 'My Favorite',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FavoritePage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // CART
                  profileMenu(
                    icon: Icons.shopping_cart_outlined,
                    title: 'My Cart',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  // LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: logout,
                      icon: const Icon(
                        Icons.logout,
                        color: AppColors.danger,
                      ),
                      label: const Text(
                        'LOGOUT',
                        style: TextStyle(
                          color: AppColors.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget profileMenu({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
