import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/shared_widgets.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                        const AuthInput(
                          label: 'Full Name',
                          hint: 'Input your name',
                          icon: Icons.person_rounded,
                        ),
                        const SizedBox(height: 16),
                        const AuthInput(
                          label: 'Email Address',
                          hint: 'you@example.com',
                          icon: Icons.email_rounded,
                        ),
                        const SizedBox(height: 16),
                        const AuthInput(
                          label: 'Password',
                          hint: 'Create your password',
                          icon: Icons.lock_rounded,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          text: 'Sign Up',
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              '/dashboard',
                            );
                          },
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
          ],
        ),
      ),
    );
  }
}