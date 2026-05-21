import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/landing_widgets.dart';
import '../widgets/shared_widgets.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: Stack(
          children: [
            const OrangeGlow(top: -120, right: -120),
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const TalkiveLogo(),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 46),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: AppColors.orange.withOpacity(0.25),
                                                  ),
                        ),
                        child: const Text(
                          'GLOBAL LEARNING COMMUNITY',
                          style: TextStyle(
                            color: AppColors.orange,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          // Gaya dasar untuk seluruh teks di dalam RichText
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 42,
                            height: 1.08,
                            fontWeight: FontWeight.w900, // Membuat teks dasar menjadi tebal (Bold)
                            color: Colors.white,
                            letterSpacing: -1.2,
                          ),
                          children: [ // Kata kunci 'const' di sini dihapus agar style anak bisa diterapkan
                            const TextSpan(text: 'Master Languages by '),
                            const TextSpan(
                              text: 'Conversing',
                              style: TextStyle(
                                color: AppColors.orange,
                                fontWeight: FontWeight.w900, // Menjaga konsistensi ketebalan
                              ),
                            ),
                            const TextSpan(text: ' with Natives.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'The most effective way to learn. Connect with professional tutors worldwide and start speaking from day one.',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: 16,
                          height: 1.7,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Get Started',
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SecondaryButton(
                              text: 'Sign Up',
                              onTap: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 34),
                      const HeroPreviewCard(),
                      const SizedBox(height: 34),
                      const SectionTitle(
                        title: 'Talk native. Be native.',
                        subtitle:
                            'Talkive adalah platform peer-to-peer untuk menghilangkan rasa takut berbicara dalam bahasa asing.',
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Why Choose Talkive?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Dirancang untuk kenyamanan pengajaran dan efektivitas pembelajaran.',
                        style: TextStyle(
                          color: AppColors.textGray,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const FeatureCard(
                        number: '01',
                        title: 'Secure',
                        description:
                            'Registrasi sebagai siswa atau tutor dengan perlindungan data.',
                        icon: Icons.lock_rounded,
                      ),
                      const FeatureCard(
                        number: '02',
                        title: 'Flexibility',
                        description:
                            'Booking sesi sesuai ketersediaan jadwal tutor pilihan.',
                        icon: Icons.calendar_month_rounded,
                      ),
                      const FeatureCard(
                        number: '03',
                        title: 'Payments',
                        description:
                            'Rancangan transaksi pembayaran untuk sesi pembelajaran.',
                        icon: Icons.payments_rounded,
                      ),
                      const FeatureCard(
                        number: '04',
                        title: 'Feedback',
                        description:
                            'Evaluasi untuk membantu melacak progres belajar.',
                        icon: Icons.rate_review_rounded,
                      ),
                    ],
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