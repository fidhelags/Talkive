import 'package:flutter/material.dart';

class LocalAppColors {
  static const Color dark = Color(0xFF181818);
  static const Color surface = Color(0xFF313131);
  static const Color orange = Color(0xFFF97316);
  static const Color textGray = Color(0xFF94A3B8);
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LocalAppColors.dark,
      body: Stack(
        children: [
          // Background glow
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: LocalAppColors.orange.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: LocalAppColors.orange.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const Spacer(),

                  // LOGO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: LocalAppColors.orange,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: LocalAppColors.orange.withOpacity(0.35),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Text(
                          'T',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Talkive',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // TAG
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: LocalAppColors.orange.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: LocalAppColors.orange.withOpacity(0.2),
                      ),
                    ),
                    child: const Text(
                      '🌍 Global Learning Community',
                      style: TextStyle(
                        color: LocalAppColors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  // TITLE
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        letterSpacing: -0.8,
                      ),
                      children: [
                        TextSpan(text: 'Master Languages\nby '),
                        TextSpan(
                          text: 'Conversing',
                          style: TextStyle(color: LocalAppColors.orange),
                        ),
                        TextSpan(text: ' with Natives.'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // DESCRIPTION
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Connect with professional tutors worldwide and start speaking from day one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: LocalAppColors.textGray,
                        fontSize: 15,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // PREVIEW CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: LocalAppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.asset(
                            'assets/language.png',
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: LocalAppColors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(
                                  Icons.language,
                                  color: LocalAppColors.orange,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '5,000+ Tutors',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Verified native speakers worldwide.',
                                style: TextStyle(
                                  color: LocalAppColors.textGray,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Stats
                        Column(
                          children: [
                            _StatChip(label: '50+', sub: 'Languages'),
                            const SizedBox(height: 6),
                            _StatChip(label: '4.9★', sub: 'Rating'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // GET STARTED BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/signup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: LocalAppColors.orange,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // LOGIN LINK
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: LocalAppColors.textGray,
                          fontSize: 15,
                        ),
                        children: [
                          TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: LocalAppColors.orange,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String sub;

  const _StatChip({required this.label, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: LocalAppColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: LocalAppColors.orange.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: LocalAppColors.orange,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              color: LocalAppColors.textGray,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
