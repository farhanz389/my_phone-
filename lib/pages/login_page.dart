import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_colors.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validasi field
    if (email.isEmpty || password.isEmpty) {
      showMessage(
        'Email dan password wajib diisi.',
      );
      return;
    }

    // Validasi email sederhana
    if (!email.contains('@')) {
      showMessage(
        'Masukkan email yang valid.',
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final success = await AppState.instance.login(
      email,
      password,
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (!success) {
      showMessage(
        'Email atau password salah.',
      );
      return;
    }

    // Login berhasil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void openRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // =====================================================
              // LOGO
              // =====================================================
              Center(
                child: Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.20,
                        ),
                        blurRadius: 22,
                        spreadRadius: 4,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 125,
                      height: 125,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons.phone_android,
                          size: 62,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =====================================================
              // TITLE
              // =====================================================
              const Text(
                'Welcome to My Phone 👋',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Login untuk melanjutkan ke aplikasi.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              // =====================================================
              // EMAIL LABEL
              // =====================================================
              const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 8),

              // =====================================================
              // EMAIL FIELD
              // =====================================================
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                  hintText: 'Masukkan email',
                ),
              ),

              const SizedBox(height: 20),

              // =====================================================
              // PASSWORD LABEL
              // =====================================================
              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(height: 8),

              // =====================================================
              // PASSWORD FIELD
              // =====================================================
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!loading) {
                    login();
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                  ),
                  hintText: 'Masukkan password',

                  // Show / Hide Password
                  suffixIcon: IconButton(
                    tooltip: obscurePassword
                        ? 'Tampilkan password'
                        : 'Sembunyikan password',
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // =====================================================
              // LOGIN BUTTON
              // =====================================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : login,
                  child: loading
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // =====================================================
              // REGISTER
              // =====================================================
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: AppColors.text,
                      ),
                    ),
                    GestureDetector(
                      onTap: openRegisterPage,
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
