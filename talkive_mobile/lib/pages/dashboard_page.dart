import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/shared_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Catatan: Di masa mendatang, data ini akan diambil dari State Management (Provider/Bloc)
    // atau API Response yang dikirim oleh Controller Spring Boot kamu.
    final String studentName = "Alex"; // Simulasi data dari ${user.name}
    final int totalBookings = 3;       // Simulasi data dari ${fn:length(bookings)}
    final int pendingPayments = 1;     // Simulasi hitungan status PENDING

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
                  // --- HEADER BAR ---
                  Row(
                    children: [
                      const TalkiveLogo(),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          // Menghapus tumpukan halaman dan kembali ke halaman Login/Landing
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

                  // --- GREETING & TITLE ---
                  Text(
                    'Welcome back, $studentName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Ready for your next learning session?',
                    style: TextStyle(
                      color: AppColors.textGray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- STATS CARD (Sama seperti baris Grid di JSP) ---
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStat(
                          title: totalBookings.toString(),
                          subtitle: 'Total Bookings',
                          icon: Icons.calendar_month_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DashboardStat(
                          title: pendingPayments.toString(),
                          subtitle: 'Pending Pay',
                          icon: Icons.pending_actions_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // --- SEARCH BAR SLOTS ---
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

                  // --- UPCOMING SESSIONS SECTION ---
                  const Text(
                    'Your Recent Sessions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Mengambil basis data model booking dari target database yang sama
                  const BookingCard(
                    tutorName: 'Sarah Miller',
                    language: 'English Native Tutor', // Dipetakan dari psychiatrist/tutor di DB
                    date: 'Today, 19:30',
                    status: 'PAID', // Jika PAID, tampilkan tombol 'Join Call' di dalam widget-nya
                  ),
                  const BookingCard(
                    tutorName: 'Kenji Tanaka',
                    language: 'Japanese Conversation',
                    date: 'Friday, 20:00',
                    status: 'PENDING', // Jika PENDING, tampilkan tombol 'Complete Payment'
                  ),
                  const SizedBox(height: 26),

                  // --- EXPLORE SECTION (Pengganti halaman slots di mobile) ---
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