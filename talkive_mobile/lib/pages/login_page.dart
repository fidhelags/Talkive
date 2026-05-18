import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../services/auth_service.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/shared_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email wajib diisi';
    }

    if (!email.contains('@')) {
      return 'Email harus menggunakan @';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password wajib diisi';
    }

    return null;
  }

  Future<void> _handleLogin() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await AuthService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau password salah'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal terhubung ke server'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Stack(
          children: [
            const OrangeGlow(top: 150, right: -140),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 35,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          const TalkiveLogo(),
                          const SizedBox(height: 28),
                          const Text(
                            'Welcome Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Login to your account and start talking.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 30),

                          AuthInput(
                            label: 'Email Address',
                            hint: 'you@example.com',
                            icon: Icons.email_rounded,
                            controller: _emailController,
                            validator: _validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 16),

                          AuthInput(
                            label: 'Password',
                            hint: 'Input your password',
                            icon: Icons.lock_rounded,
                            obscureText: true,
                            controller: _passwordController,
                            validator: _validatePassword,
                            textInputAction: TextInputAction.done,
                          ),

                          const SizedBox(height: 12),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          _isLoading
                              ? const CircularProgressIndicator(
                                  color: AppColors.orange,
                                )
                              : PrimaryButton(
                                  text: 'Login',
                                  onTap: _handleLogin,
                                ),

                          const SizedBox(height: 22),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(color: AppColors.textGray),
                                children: [
                                  TextSpan(text: 'New to Talkive? '),
                                  TextSpan(
                                    text: 'Create account',
                                    style: TextStyle(
                                      color: AppColors.orange,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Back to Home',
                              style: TextStyle(color: AppColors.textGray),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}