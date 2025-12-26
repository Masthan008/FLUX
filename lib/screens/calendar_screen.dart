import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../modules/alarm/alarm_service.dart';
import '../widgets/glass_container.dart';

class CalendarReminder {
  final String id;
  final String title;
  final DateTime dateTime;
  final String category;
  final String? notes;
  final int alarmId;

  CalendarReminder({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.category,
    this.notes,
    required this.alarmId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'category': category,
        'notes': notes,
        'alarmId': alarmId,
      };

  factory CalendarReminder.fromJson(Map<String, dynamic> json) => CalendarReminder(
        id: json['id'],
        title: json['title'],
        dateTime: DateTime.parse(json['dateTime']),
        category: json['category'],
        notes: json['notes'],
        alarmId: json['alarmId'],
      );
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> 
    with TickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late Box _remindersBox;
  Map<DateTime, List<CalendarReminder>> _reminders = {};
  late AnimationController _animationController;
  late AnimationController _calendarAnimationController;

  final List<String> _categories = [
    '📚 Study',
    '📝 Assignment',
    '🎯 Exam',
    '💼 Meeting',
    '🎉 Event',
    '⚡ Important',
    '📌 Other',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initHive();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _calendarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.forward();
    _calendarAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initHive() async {
    _remindersBox = await Hive.openBox('calendar_reminders');
    _loadReminders();
  }

  void _loadReminders() {
    final remindersData = _remindersBox.get('reminders', defaultValue: <String, dynamic>{});
    _reminders.clear();
    
    if (remindersData is Map) {
      remindersData.forEach((key, value) {
        if (value is List) {
          final date = DateTime.parse(key);
          _reminders[_normalizeDate(date)] = value
              .map((item) => CalendarReminder.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
      });
    }
    
    setState(() {});
  }

  Future<void> _saveReminders() async {
    final remindersData = <String, dynamic>{};
    _reminders.forEach((date, reminders) {
      remindersData[date.toIso8601String()] = reminders.map((r) => r.toJson()).toList();
    });
    await _remindersBox.put('reminders', remindersData);
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<CalendarReminder> _getRemindersForDay(DateTime day) {
    return _reminders[_normalizeDate(day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              const Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.cyanAccent,
                        size: 24,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.3),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Student Calendar',
                            style: GoogleFonts.orbitron(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent,
                            ),
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3),
                          Text(
                            'Plan your academic journey',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.3),
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.list_rounded,
                          color: Colors.cyanAccent,
                          size: 24,
                        ),
                        onPressed: _showAllReminders,
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            eventLoader: _getRemindersForDay,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              _showDayReminders(selectedDay);
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyanAccent.withOpacity(0.8),
                                    Colors.cyanAccent.withOpacity(0.6),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.cyanAccent.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              todayTextStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              selectedDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.purpleAccent.withOpacity(0.8),
                                    Colors.purpleAccent.withOpacity(0.6),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purpleAccent.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              selectedTextStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              markerDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.amber,
                                    Colors.amber.withOpacity(0.8),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              markersMaxCount: 3,
                              defaultTextStyle: GoogleFonts.poppins(
                                color: Colors.white,
                              ),
                              weekendTextStyle: GoogleFonts.poppins(
                                color: Colors.white70,
                              ),
                              outsideTextStyle: GoogleFonts.poppins(
                                color: Colors.white30,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              titleTextStyle: GoogleFonts.orbitron(
                                color: Colors.cyanAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              formatButtonTextStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              formatButtonDecoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              leftChevronIcon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                              rightChevronIcon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ),
                            daysOfWeekStyle: DaysOfWeekStyle(
                              weekdayStyle: GoogleFonts.poppins(
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              weekendStyle: GoogleFonts.poppins(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
                      if (_selectedDay != null) _buildSelectedDayReminders(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.cyanAccent,
                Colors.cyanAccent.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => _showAddReminderDialog(_selectedDay ?? DateTime.now()),
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: Icon(Icons.add_rounded, color: Colors.black, size: 24),
            label: Text(
              'Add Reminder',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.8, 0.8)),
    );
  }

  Widget _buildSelectedDayReminders() {
    final reminders = _getRemindersForDay(_selectedDay!);
    if (reminders.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.event_note_rounded,
                  color: Colors.cyanAccent,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Reminders for ${DateFormat('MMM dd, yyyy').format(_selectedDay!)}',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${reminders.length}',
                    style: GoogleFonts.poppins(
                      color: Colors.cyanAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...reminders.asMap().entries.map((entry) {
              final index = entry.key;
              final reminder = entry.value;
              return _buildEnhancedReminderCard(reminder, index);
            }),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildEnhancedReminderCard(CalendarReminder reminder, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
        ),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Category Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.4),
                ),
              ),
              child: Text(
                reminder.category.split(' ')[0], // Get emoji
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reminder.category.substring(2), // Remove emoji
                    style: GoogleFonts.poppins(
                      color: Colors.cyanAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Colors.white70,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('h:mm a').format(reminder.dateTime),
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      reminder.notes!,
                      style: GoogleFonts.poppins(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () => _deleteReminder(reminder),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.3);
  }

  void _showDayReminders(DateTime day) {
    final reminders = _getRemindersForDay(day);
    if (reminders.isEmpty) {
      _showAddReminderDialog(day);
    }
  }

  void _showAllReminders() {
    final allReminders = <CalendarReminder>[];
    _reminders.forEach((date, reminders) {
      allReminders.addAll(reminders);
    });
    allReminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: Colors.cyanAccent, width: 2),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Reminders',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: allReminders.isEmpty
                  ? const Center(
                      child: Text(
                        'No reminders yet',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: allReminders.length,
                      itemBuilder: (context, index) {
                        final reminder = allReminders[index];
                        return _buildEnhancedReminderCard(reminder, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderDialog(DateTime selectedDate) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    String selectedCategory = _categories[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1a1a2e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
          title: const Text(
            '📅 Add Reminder',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF1a1a2e),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Colors.cyanAccent,
                              onPrimary: Colors.black,
                              surface: Color(0xFF1a1a2e),
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          selectedTime.format(context),
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  return;
                }

                final reminderDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                if (reminderDateTime.isBefore(DateTime.now())) {
                  return;
                }

                final alarmId = reminderDateTime.millisecondsSinceEpoch ~/ 1000;
                final reminderId = DateTime.now().millisecondsSinceEpoch.toString();

                try {
                  await AlarmService.scheduleAlarm(
                    id: alarmId,
                    dateTime: reminderDateTime,
                    assetAudioPath: AlarmService.defaultAudioPath,
                    notificationTitle: '$selectedCategory Reminder',
                    notificationBody: title,
                    reminderNote: notesController.text.trim(),
                    loopAudio: true,
                    vibrate: true,
                    androidFullScreenIntent: true,
                  );

                  final reminder = CalendarReminder(
                    id: reminderId,
                    title: title,
                    dateTime: reminderDateTime,
                    category: selectedCategory,
                    notes: notesController.text.trim(),
                    alarmId: alarmId,
                  );

                  final normalizedDate = _normalizeDate(selectedDate);
                  if (_reminders[normalizedDate] == null) {
                    _reminders[normalizedDate] = [];
                  }
                  _reminders[normalizedDate]!.add(reminder);
                  await _saveReminders();

                  setState(() {});
                  Navigator.pop(context);
                } catch (e) {
                  // Silent error handling
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteReminder(CalendarReminder reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: const Text(
          'Delete Reminder?',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${reminder.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AlarmService.stopAlarm(reminder.alarmId);
        
        final normalizedDate = _normalizeDate(reminder.dateTime);
        _reminders[normalizedDate]?.removeWhere((r) => r.id == reminder.id);
        if (_reminders[normalizedDate]?.isEmpty ?? false) {
          _reminders.remove(normalizedDate);
        }
        await _saveReminders();

        setState(() {});

        // Silent deletion
      } catch (e) {
        // Silent error handling
      }
    }
  }
}
