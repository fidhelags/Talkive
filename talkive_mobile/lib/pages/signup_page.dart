import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/shared_widgets.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name wajib diisi';
    }

    if (value.trim().length < 3) {
      return 'Nama minimal 3 karakter';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email wajib diisi';
    }

    if (!email.contains('@')) {
      return 'Email harus menggunakan @';
    }

    if (!email.contains('.')) {
      return 'Email harus memiliki domain, contoh: email@gmail.com';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';

    if (password.isEmpty) {
      return 'Password wajib diisi';
    }

    if (password.length < 8) {
      return 'Password minimal 8 karakter';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password harus memiliki huruf besar';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password harus memiliki huruf kecil';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password harus memiliki angka';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final confirmPassword = value ?? '';

    if (confirmPassword.isEmpty) {
      return 'Confirm password wajib diisi';
    }

    if (confirmPassword != _passwordController.text) {
      return 'Confirm password harus sama dengan password';
    }

    return null;
  }

  void _handleSignUp() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/dashboard',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Stack(
          children: [
            const OrangeGlow(top: -120, right: -120),
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
                            'Create Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Join Talkive and start your language journey.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 30),

                          AuthInput(
                            label: 'Full Name',
                            hint: 'Input your name',
                            icon: Icons.person_rounded,
                            controller: _nameController,
                            validator: _validateName,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 16),

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
                            hint: 'Create your password',
                            icon: Icons.lock_rounded,
                            obscureText: true,
                            controller: _passwordController,
                            validator: _validatePassword,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 10),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password minimal 8 karakter, huruf besar, huruf kecil, dan angka.',
                              style: TextStyle(
                                color: AppColors.textGray,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          AuthInput(
                            label: 'Confirm Password',
                            hint: 'Repeat your password',
                            icon: Icons.verified_user_rounded,
                            obscureText: true,
                            controller: _confirmPasswordController,
                            validator: _validateConfirmPassword,
                            textInputAction: TextInputAction.done,
                          ),

                          const SizedBox(height: 24),

                          PrimaryButton(
                            text: 'Sign Up',
                            onTap: _handleSignUp,
                          ),

                          const SizedBox(height: 22),

                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(color: AppColors.textGray),
                                children: [
                                  TextSpan(text: 'Already have account? '),
                                  TextSpan(
                                    text: 'Login',
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