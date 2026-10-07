import 'package:flutter/material.dart';

import '../services/app_state.dart';
import '../theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();

    super.dispose();
  }

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirm = confirmController.text;

    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      showMessage(
        'Semua field wajib diisi.',
      );
      return;
    }

    if (password.length < 6) {
      showMessage(
        'Password minimal 6 karakter.',
      );
      return;
    }

    if (password != confirm) {
      showMessage(
        'Konfirmasi password tidak cocok.',
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final success = await AppState.instance.register(
      email,
      password,
    );

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (!success) {
      showMessage(
        'Email sudah terdaftar.',
      );
      return;
    }

    showMessage(
      'Registrasi berhasil. Silakan login.',
    );

    Navigator.pop(context);
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Create your account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Buat akun untuk menggunakan My Phone.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 35),
              const Text('Email'),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'Email',
                ),
              ),
              const SizedBox(height: 20),
              const Text('Password'),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Password',
                  suffixIcon: IconButton(
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
              const SizedBox(height: 20),
              const Text('Confirm Password'),
              const SizedBox(height: 8),
              TextField(
                controller: confirmController,
                obscureText: obscureConfirm,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  hintText: 'Konfirmasi password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                    icon: Icon(
                      obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : register,
                  child: loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'CREATE ACCOUNT',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
