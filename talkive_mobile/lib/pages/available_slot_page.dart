import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'app_colors.dart';
import 'top_bar.dart';
import 'dart:async';

class AvailableSlotPage extends StatefulWidget {
  final int userId;
  const AvailableSlotPage({super.key, required this.userId});

  @override
  State<AvailableSlotPage> createState() => _AvailableSlotPageState();
}

class _AvailableSlotPageState extends State<AvailableSlotPage> {
  List<Map<String, dynamic>> _slots = [];
  bool _isLoading = true;
  bool _isBooking = false;

  // Filter state
  String _selectedLanguage = '';
  String _selectedLevel = '';
  String _selectedLesson = '';
  DateTime? _selectedDate;

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchSlots();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchSlots();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchSlots() async {
    setState(() => _isLoading = true);
    try {
      final params = <String, String>{};
      if (_selectedLanguage.isNotEmpty) params['language'] = _selectedLanguage;
      if (_selectedLevel.isNotEmpty) params['level'] = _selectedLevel;
      if (_selectedLesson.isNotEmpty) params['lessonType'] = _selectedLesson;
      if (_selectedDate != null) {
        params['date'] = _selectedDate!.toIso8601String().split('T')[0];
      }

      final uri = Uri.parse(
        'http://10.0.2.2:8080/api/slots',
      ).replace(queryParameters: params.isNotEmpty ? params : null);

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() => _slots = List<Map<String, dynamic>>.from(data));
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _bookSlot(Map<String, dynamic> slot) async {
    setState(() => _isBooking = true);
    try {
      final response = await http.post(
        Uri.parse(
          'http://10.0.2.2:8080/api/bookings',
        ), // tetap 10.0.2.2 untuk API call dari app
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': widget.userId,
          'slotId': slot['id'],
          'source': 'mobile', // tambah ini
        }),
      );

      final data = jsonDecode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200 && data['success'] == true) {
        final redirectUrl = data['redirectUrl'] as String?;
        debugPrint('=== REDIRECT URL: $redirectUrl');

        if (redirectUrl != null && redirectUrl.isNotEmpty) {
          final uri = Uri.parse(redirectUrl);
          try {
            // Langsung launchUrl tanpa canLaunchUrl — lebih reliable
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } catch (e) {
            debugPrint('Launch error: $e');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tidak bisa membuka halaman pembayaran.'),
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
        _fetchSlots();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Booking failed.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Booking error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server.')),
      );
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  void _showFilterSheet() {
    // Temp state untuk filter di sheet
    String tempLanguage = _selectedLanguage;
    String tempLevel = _selectedLevel;
    String tempLesson = _selectedLesson;
    DateTime? tempDate = _selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Slots',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedLanguage = '';
                              _selectedLevel = '';
                              _selectedLesson = '';
                              _selectedDate = null;
                            });
                            Navigator.pop(context);
                            _fetchSlots();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    _SheetLabel(label: 'Date'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: tempDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: AppColors.orange,
                                  surface: Color(0xFF2A2A2A),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setSheetState(() => tempDate = picked);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: tempDate != null
                                ? AppColors.orange
                                : Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: tempDate != null
                                  ? AppColors.orange
                                  : AppColors.textGray,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              tempDate != null
                                  ? '${tempDate!.year}-${tempDate!.month.toString().padLeft(2, '0')}-${tempDate!.day.toString().padLeft(2, '0')}'
                                  : 'Select date',
                              style: TextStyle(
                                color: tempDate != null
                                    ? Colors.white
                                    : AppColors.textGray,
                                fontSize: 14,
                              ),
                            ),
                            if (tempDate != null) ...[
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    setSheetState(() => tempDate = null),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppColors.textGray,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LANGUAGE
                    _SheetLabel(label: 'Language'),
                    const SizedBox(height: 10),
                    _SheetDropdown(
                      value: tempLanguage.isEmpty ? null : tempLanguage,
                      hint: '🌍 All Languages',
                      items: const [
                        '🇬🇧 English',
                        '🇮🇩 Indonesia',
                        '🇯🇵 Japanese',
                        '🇰🇷 Korean',
                        '🇨🇳 Chinese',
                        '🇫🇷 French',
                        '🇩🇪 German',
                        '🇪🇸 Spanish',
                      ],
                      values: const [
                        'English',
                        'Indonesia',
                        'Japanese',
                        'Korean',
                        'Chinese',
                        'French',
                        'German',
                        'Spanish',
                      ],
                      onChanged: (val) =>
                          setSheetState(() => tempLanguage = val ?? ''),
                    ),

                    const SizedBox(height: 20),

                    // LEVEL
                    _SheetLabel(label: 'Level'),
                    const SizedBox(height: 10),
                    _SheetDropdown(
                      value: tempLevel.isEmpty ? null : tempLevel,
                      hint: 'All Levels',
                      items: const ['Beginner', 'Intermediate', 'Advanced'],
                      values: const ['Beginner', 'Intermediate', 'Advanced'],
                      onChanged: (val) =>
                          setSheetState(() => tempLevel = val ?? ''),
                    ),

                    const SizedBox(height: 20),

                    // LESSON
                    _SheetLabel(label: 'Lesson Type'),
                    const SizedBox(height: 10),
                    _SheetDropdown(
                      value: tempLesson.isEmpty ? null : tempLesson,
                      hint: 'All Lessons',
                      items: const [
                        'Conversation',
                        'Grammar',
                        'Pronunciation',
                        'Vocabulary',
                        'Speaking Practice',
                        'Exam Preparation',
                        'Business Language',
                        'Kids Learning',
                      ],
                      values: const [
                        'Conversation',
                        'Grammar',
                        'Pronunciation',
                        'Vocabulary',
                        'Speaking Practice',
                        'Exam Preparation',
                        'Business Language',
                        'Kids Learning',
                      ],
                      onChanged: (val) =>
                          setSheetState(() => tempLesson = val ?? ''),
                    ),

                    const SizedBox(height: 28),

                    // Apply button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _selectedLanguage = tempLanguage;
                            _selectedLevel = tempLevel;
                            _selectedLesson = tempLesson;
                            _selectedDate = tempDate;
                          });
                          Navigator.pop(context);
                          _fetchSlots();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: const Text(
                          'Apply Filter',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool get _hasActiveFilter =>
      _selectedLanguage.isNotEmpty ||
      _selectedLevel.isNotEmpty ||
      _selectedLesson.isNotEmpty ||
      _selectedDate != null;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: SafeArea(
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

                  // Header + filter button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                          children: [
                            TextSpan(
                              text: 'Find Your ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextSpan(
                              text: 'Tutor',
                              style: TextStyle(color: AppColors.orange),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _showFilterSheet,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: _hasActiveFilter
                                ? AppColors.orange
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _hasActiveFilter
                                  ? AppColors.orange
                                  : Colors.white.withOpacity(0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 16,
                                color: _hasActiveFilter
                                    ? Colors.white
                                    : AppColors.textGray,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _hasActiveFilter ? 'Filtered' : 'Filter',
                                style: TextStyle(
                                  color: _hasActiveFilter
                                      ? Colors.white
                                      : AppColors.textGray,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  const Text(
                    'Pick a schedule that fits your learning',
                    style: TextStyle(color: AppColors.textGray, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Slot list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.orange),
                    )
                  : _slots.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy_outlined,
                            size: 56,
                            color: AppColors.textGray.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No Slots Available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Try a different filter.',
                            style: TextStyle(
                              color: AppColors.textGray,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (notification) =>
                          true, // block scroll notif ke parent
                      child: RefreshIndicator(
                        onRefresh: _fetchSlots,
                        color: AppColors.orange,
                        backgroundColor: AppColors.surface,
                        displacement: 60, // harus tarik lebih jauh
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                          itemCount: _slots.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final slot = _slots[index];
                            final tutor =
                                slot['tutor'] as Map<String, dynamic>?;
                            return Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.05),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _flagEmoji(tutor?['language']),
                                            style: const TextStyle(
                                              fontSize: 22,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          slot['level'] ?? '-',
                                          style: const TextStyle(
                                            color: Color(0xFF60A5FA),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Divider(
                                    color: Colors.white.withOpacity(0.05),
                                    height: 1,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      _SlotDetail(
                                        icon: Icons.calendar_today_outlined,
                                        text: slot['date'] ?? '-',
                                      ),
                                      const SizedBox(width: 16),
                                      _SlotDetail(
                                        icon: Icons.access_time_outlined,
                                        text:
                                            '${slot['startTime']} - ${slot['endTime']}',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  _SlotDetail(
                                    icon: Icons.menu_book_outlined,
                                    text: slot['lessonType'] ?? '-',
                                  ),
                                  if (slot['description'] != null &&
                                      slot['description']
                                          .toString()
                                          .isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    _SlotDetail(
                                      icon: Icons.notes_outlined,
                                      text: slot['description'],
                                    ),
                                  ],
                                  const SizedBox(height: 14),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'IDR ${_formatPrice(slot['price'])}',
                                        style: const TextStyle(
                                          color: AppColors.orange,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: _isBooking
                                            ? null
                                            : () => _bookSlot(slot),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 18,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _isBooking
                                                ? AppColors.surface
                                                : AppColors.orange,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: _isBooking
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Text(
                                                  'Book Now',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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

class _SheetLabel extends StatelessWidget {
  final String label;
  const _SheetLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textGray,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SheetDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final List<String> items;
  final List<String> values;
  final void Function(String?) onChanged;

  const _SheetDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value != null
              ? AppColors.orange
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.textGray, fontSize: 14),
          ),
          dropdownColor: const Color(0xFF2A2A2A),
          isExpanded: true,
          iconEnabledColor: AppColors.textGray,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          onChanged: onChanged,
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                hint,
                style: const TextStyle(color: AppColors.textGray, fontSize: 14),
              ),
            ),
            ...List.generate(
              items.length,
              (i) => DropdownMenuItem<String>(
                value: values[i],
                child: Text(items[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SlotDetail({required this.icon, required this.text});

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
