import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/shared_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: AppColors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'My Bookings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Kelola sesi belajar dan temukan tutor yang sesuai.',
                    style: TextStyle(
                      color: AppColors.textGray,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(
                        child: DashboardStat(
                          title: '3',
                          subtitle: 'Sessions',
                          icon: Icons.calendar_month_rounded,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: DashboardStat(
                          title: '12',
                          subtitle: 'Tutors',
                          icon: Icons.record_voice_over_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search_rounded, color: AppColors.orange),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Search available slots',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Upcoming Session',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const BookingCard(
                    tutorName: 'Sarah Miller',
                    language: 'English Native Tutor',
                    date: 'Today, 19:30',
                    status: 'PAID',
                  ),
                  const BookingCard(
                    tutorName: 'Kenji Tanaka',
                    language: 'Japanese Conversation',
                    date: 'Friday, 20:00',
                    status: 'PENDING',
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Available Tutors',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const TutorCard(
                    name: 'Maria Garcia',
                    language: 'Spanish',
                    rating: '4.9',
                  ),
                  const TutorCard(
                    name: 'Park Minji',
                    language: 'Korean',
                    rating: '4.8',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}