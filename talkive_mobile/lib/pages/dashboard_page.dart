import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'app_colors.dart';
import 'top_bar.dart';
import 'dart:async';

class DashboardPage extends StatefulWidget {
  final int userId;
  final String userName;

  const DashboardPage({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _ReportSection extends StatelessWidget {
  final String title;
  final dynamic content;

  const _ReportSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    if (content == null || content.toString().isEmpty)
      return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textGray,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  List<Map<String, dynamic>> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // register lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    _fetchBookings();
  }

  @override
  void dispose() {
    // remove observer
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  // otomatis jalan saat user balik ke app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      debugPrint('APP RESUMED -> REFRESH BOOKINGS');

      // kasih delay sedikit supaya webhook midtrans sempat update
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _fetchBookings();
        }
      });
    }
  }

  Future<void> _fetchBookings() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/bookings/user/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (mounted) {
          setState(() {
            _bookings = List<Map<String, dynamic>>.from(data).reversed.toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching bookings: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  int get _totalBookings => _bookings.length;

  int get _successSessions => _bookings
      .where(
        (b) =>
            b['paymentStatus'] == 'PAID' || b['paymentStatus'] == 'LINK_SENT',
      )
      .length;

  int get _pendingAction =>
      _bookings.where((b) => b['paymentStatus'] == 'PENDING').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Stack(
        children: [
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TopBar(),

                      const SizedBox(height: 20),

                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Welcome, ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: widget.userName,
                              style: const TextStyle(color: AppColors.orange),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'Track your sessions and stay on top of your learning',
                        style: TextStyle(
                          color: AppColors.textGray,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          _StatCard(
                            label: 'Total\nBookings',
                            value: '$_totalBookings',
                            color: Colors.white,
                          ),

                          const SizedBox(width: 12),

                          _StatCard(
                            label: 'Active\nSessions',
                            value: '$_successSessions',
                            color: const Color(0xFF4ADE80),
                          ),

                          const SizedBox(width: 12),

                          _StatCard(
                            label: 'Pending\nActions',
                            value: '$_pendingAction',
                            color: const Color(0xFFFBBF24),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'My Bookings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 14),
                    ],
                  ),
                ),

                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.orange,
                          ),
                        )
                      : _bookings.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 56,
                                color: AppColors.textGray.withOpacity(0.3),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                'No Bookings Yet',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 6),

                              const Text(
                                'Explore tutors and book your first session.',
                                style: TextStyle(
                                  color: AppColors.textGray,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchBookings,
                          color: AppColors.orange,
                          backgroundColor: AppColors.surface,
                          displacement: 60,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                            itemCount: _bookings.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _BookingCard(booking: _bookings[index]);
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textGray,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Diubah dari StatelessWidget ke StatefulWidget
class _BookingCard extends StatefulWidget {
  final Map<String, dynamic> booking;

  const _BookingCard({required this.booking});

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  static const String _baseUrl = 'http://10.0.2.2:8080';
  bool _isPaying = false;

  Color _statusColor(String status) {
    switch (status) {
      case 'COMPLETED':
        return const Color(0xFF60A5FA);
      case 'PAID':
      case 'LINK_SENT':
        return const Color(0xFF4ADE80);
      case 'PENDING':
        return const Color(0xFFFBBF24);
      default:
        return AppColors.textGray;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'COMPLETED':
        return 'Completed';
      case 'PAID':
        return 'Success';
      case 'LINK_SENT':
        return 'Link Sent';
      case 'PENDING':
        return 'Pending';
      default:
        return status;
    }
  }

  String _flagEmoji(String? language) {
    switch (language) {
      case 'English':
        return '🇬🇧';
      case 'Indonesia':
        return '🇮🇩';
      case 'Japanese':
        return '🇯🇵';
      case 'Korean':
        return '🇰🇷';
      case 'Chinese':
        return '🇨🇳';
      case 'French':
        return '🇫🇷';
      case 'German':
        return '🇩🇪';
      case 'Spanish':
        return '🇪🇸';
      default:
        return '🌍';
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null) return '-';
    final num p = price is num ? price : num.tryParse(price.toString()) ?? 0;
    return p
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  Future<void> _launchUrl(String url) async {
    String cleanUrl = url;
    if (url.startsWith('intent://') || url.contains('meet.app.goo.gl')) {
      final linkMatch = RegExp(r'link=(https://[^&]+)').firstMatch(url);
      if (linkMatch != null) {
        cleanUrl = Uri.decodeComponent(linkMatch.group(1)!);
      }
    }
    if (!cleanUrl.startsWith('http://') && !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://$cleanUrl';
    }
    final uri = Uri.parse(cleanUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) debugPrint('Could not launch: $cleanUrl');
    } catch (e) {
      debugPrint('Could not launch $cleanUrl: $e');
    }
  }

  Future<void> _launchPdfUrl(String url) async {
    debugPrint('=== LAUNCHING PDF: $url');
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) debugPrint('Could not launch PDF: $url');
    } catch (e) {
      debugPrint('PDF launch error: $e');
    }
  }

  // ✅ Method baru: hit /repay lalu redirect ke Midtrans
  Future<void> _repay(int bookingId) async {
    setState(() => _isPaying = true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/bookings/$bookingId/repay'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'source': 'mobile'}),
      );
      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200 && data['success'] == true) {
        final redirectUrl = data['redirectUrl'] as String?;
        debugPrint('=== REPAY REDIRECT URL: $redirectUrl');

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          try {
            await launchUrl(
              Uri.parse(redirectUrl),
              mode: LaunchMode.externalApplication,
            );
          } catch (e) {
            debugPrint('Launch error: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Tidak bisa membuka halaman pembayaran.'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            }
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Payment failed.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Repay error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat terhubung ke server.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isPaying = false);
    }
  }

  void _showReportDialog(BuildContext context, dynamic report) {
    final r = report as Map<String, dynamic>;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Consultation Report',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              _ReportSection(
                title: 'Session Summary',
                content: r['sessionSummary'],
              ),
              _ReportSection(
                title: 'Student Progress',
                content: r['studentProgress'],
              ),
              _ReportSection(title: 'Strengths', content: r['strengths']),
              _ReportSection(title: 'Weaknesses', content: r['weaknesses']),
              _ReportSection(title: 'Improvement', content: r['improvement']),
              _ReportSection(
                title: 'Recommendation',
                content: r['recommendation'],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String status,
    String? meetingLink,
    dynamic report,
    String? reportUrl,
    int? bookingId,
  ) {
    if (status == 'COMPLETED') {
      if (reportUrl != null) {
        return _ActionBtn(
          label: 'View Report',
          color: Colors.white,
          textColor: AppColors.dark,
          onTap: () => _launchPdfUrl(reportUrl),
        );
      }
      if (report != null) {
        return _ActionBtn(
          label: 'View Report',
          color: Colors.white,
          textColor: AppColors.dark,
          onTap: () => _showReportDialog(context, report),
        );
      }
    }

    if ((status == 'PAID' || status == 'LINK_SENT') &&
        meetingLink != null &&
        meetingLink.isNotEmpty) {
      return _ActionBtn(
        label: 'Join Call',
        color: AppColors.orange,
        textColor: Colors.white,
        onTap: () {
          debugPrint('MEETING LINK: $meetingLink');
          _launchUrl(meetingLink);
        },
      );
    }

    if (status == 'PAID' && (meetingLink == null || meetingLink.isEmpty)) {
      return const Text(
        'Waiting for link...',
        style: TextStyle(
          color: AppColors.textGray,
          fontSize: 11,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    // ✅ PENDING: hit /repay, bukan pakai paymentUrl lama
    if (status == 'PENDING') {
      return _isPaying
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.orange,
                strokeWidth: 2,
              ),
            )
          : _ActionBtn(
              label: 'Pay Now',
              color: Colors.white,
              textColor: AppColors.dark,
              onTap: () {
                if (bookingId != null) _repay(bookingId);
              },
            );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.booking['slot'] as Map<String, dynamic>?;
    final tutor = slot?['tutor'] as Map<String, dynamic>?;
    final status = widget.booking['paymentStatus'] as String? ?? '';
    final report = widget.booking['consultationReport'];
    final bookingId = widget.booking['id'] as int?;

    final String? reportUrl = bookingId != null
        ? '$_baseUrl/user/bookings/$bookingId/pdf/view'
        : null;

    final meetingLink = widget.booking['meetingLink'] as String?;
    final description = slot?['description'] as String?;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      _flagEmoji(tutor?['language']),
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tutor?['name'] ?? '-',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${tutor?['language'] ?? '-'} · ${tutor?['yearsExperience']} yrs',
                            style: const TextStyle(
                              color: AppColors.textGray,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel(status),
                  style: TextStyle(
                    color: _statusColor(status),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.05), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _Detail(
                icon: Icons.calendar_today_outlined,
                text: slot?['date'] ?? '-',
              ),
              const SizedBox(width: 16),
              _Detail(
                icon: Icons.access_time_outlined,
                text: '${slot?['startTime'] ?? ''} - ${slot?['endTime'] ?? ''}',
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _Detail(
                icon: Icons.signal_cellular_alt_outlined,
                text: slot?['level'] ?? '-',
              ),
              const SizedBox(width: 16),
              _Detail(
                icon: Icons.menu_book_outlined,
                text: slot?['lessonType'] ?? '-',
              ),
            ],
          ),
          if (description != null && description.isNotEmpty) ...[
            const SizedBox(height: 6),
            _Detail(icon: Icons.notes_outlined, text: description),
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'IDR ${_formatPrice(slot?['price'])}',
                style: const TextStyle(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              _buildActionButton(
                context,
                status,
                meetingLink,
                report,
                reportUrl,
                bookingId,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Detail({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textGray),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textGray,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.color,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
