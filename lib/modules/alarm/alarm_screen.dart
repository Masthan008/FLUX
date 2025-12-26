import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:alarm/alarm.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/glass_button.dart';
import '../../services/audio_preview_service.dart';
import 'alarm_provider.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late Timer _clockTimer;
  String _currentTime = '';
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final userPrefs = Hive.box('user_prefs');
    final use24h = userPrefs.get('use24h', defaultValue: false);
    
    setState(() {
      _currentTime = use24h 
          ? DateFormat('HH:mm:ss').format(now)
          : DateFormat('h:mm:ss a').format(now);
      _currentDate = DateFormat('EEEE, MMMM d, y').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AlarmProvider>(context);
    final alarms = provider.alarms;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildAnimatedFloatingButtons(context, provider),
      body: Column(
        children: [
          // Real-Time Clock Display
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurpleAccent.withOpacity(0.3),
                  Colors.cyanAccent.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.cyanAccent.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _currentTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentDate,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
          
          // Do Not Disturb Warning
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please ensure "Do Not Disturb" allows Alarms',
                    style: TextStyle(
                      color: Colors.orange.shade200,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: alarms.isEmpty
                ? const Center(
                    child: Text(
                      "No Alarms Set",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100), // Bottom padding for FAB/Nav
                    itemCount: alarms.length,
              itemBuilder: (context, index) {
                final alarm = alarms[index];
                
                // Read time format preference from Hive
                final userPrefs = Hive.box('user_prefs');
                final use24h = userPrefs.get('use24h', defaultValue: false);
                
                // Format time based on preference
                final timeFormat = use24h ? DateFormat('HH:mm') : DateFormat('h:mm a');
                final formattedTime = timeFormat.format(alarm.dateTime);
                
                // Calculate "Rings in X hours"
                final now = DateTime.now();
                final difference = alarm.dateTime.difference(now);
                final hoursUntil = difference.inHours;
                final minutesUntil = difference.inMinutes % 60;
                String ringsIn = '';
                if (difference.isNegative) {
                  ringsIn = 'Passed';
                } else if (hoursUntil > 0) {
                  ringsIn = 'Rings in ${hoursUntil}h ${minutesUntil}m';
                } else {
                  ringsIn = 'Rings in ${minutesUntil}m';
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GlassContainer(
                    width: double.infinity,
                    child: ListTile(
                      title: Text(
                        formattedTime,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$ringsIn | ${alarm.loopAudio ? 'Daily' : 'Once'}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          // Display alarm label/note if exists
                          if (alarm.notificationSettings.body.contains('\n\n📝 '))
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "📝 ${alarm.notificationSettings.body.split('\n\n📝 ')[1]}",
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.cyanAccent),
                            onPressed: () => _showEditAlarmDialog(context, alarm),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => provider.stopAlarm(alarm.id),
                          ),
                        ],
                      ),
                    ),
                  ).animate().slideX(begin: 1.0, end: 0.0, curve: Curves.easeOut),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _setPowerNap(BuildContext context, AlarmProvider provider) async {
    final napTime = DateTime.now().add(const Duration(minutes: 20));
    
    // Generate unique ID to avoid conflicts - use larger range
    final uniqueId = DateTime.now().millisecondsSinceEpoch % 1000000;
    
    await provider.scheduleAlarmWithNote(
      napTime,
      'assets/sounds/alarm_1.mp3',
      'Quick 20-minute power nap',
      loopAudio: false,
      alarmId: uniqueId,
    );
    
    // No snackbar - silent alarm set
  }

  Widget _buildAnimatedFloatingButtons(BuildContext context, AlarmProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // History Button
          FloatingActionButton.extended(
            heroTag: 'history',
            backgroundColor: Colors.grey.shade800.withOpacity(0.9),
            elevation: 8,
            onPressed: () => _showHistoryDialog(context, provider),
            icon: const Icon(Icons.history, color: Colors.white),
            label: const Text(
              'History',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 1.0, end: 0.0, curve: Curves.elasticOut),
          
          // Power Nap Button
          FloatingActionButton.extended(
            heroTag: 'power_nap',
            backgroundColor: Colors.amber.withOpacity(0.9),
            elevation: 8,
            onPressed: () => _setPowerNap(context, provider),
            icon: const Icon(Icons.bolt, color: Colors.black),
            label: const Text(
              'Power Nap',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 1.0, end: 0.0, curve: Curves.elasticOut),
          
          // Add Alarm Button
          FloatingActionButton(
            heroTag: 'add_alarm',
            backgroundColor: Colors.deepPurpleAccent.withOpacity(0.9),
            elevation: 8,
            child: const Icon(Icons.add, size: 28),
            onPressed: () => _showAddAlarmDialog(context),
          ).animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideY(begin: 1.0, end: 0.0, curve: Curves.elasticOut)
            .then()
            .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
        ],
      ),
    );
  }

  void _showEditAlarmDialog(BuildContext context, AlarmSettings alarm) {
    // Pre-fill with existing alarm data
    TimeOfDay selectedTime = TimeOfDay(hour: alarm.dateTime.hour, minute: alarm.dateTime.minute);
    bool repeatDaily = alarm.loopAudio;
    bool randomizeSound = false;
    String selectedSound = alarm.assetAudioPath;
    final notesController = TextEditingController(text: ''); // Note: AlarmSettings doesn't store notes, so empty
    
    List<bool> selectedDays = List.filled(7, false);
    
    // Enhanced features
    String selectedCategory = 'General';
    bool gradualVolume = false;
    bool enableVibration = true;
    
    _showAlarmDialog(context, selectedTime, repeatDaily, randomizeSound, selectedSound, notesController, selectedDays, alarm.id, selectedCategory, gradualVolume, enableVibration);
  }

  void _showAddAlarmDialog(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.now();
    bool repeatDaily = false;
    bool randomizeSound = false;
    String selectedSound = 'assets/sounds/alarm_1.mp3'; // Default
    final notesController = TextEditingController();
    
    // v5.0: Day selector for specific days
    List<bool> selectedDays = List.filled(7, false); // M T W T F S S
    
    // Enhanced features
    String selectedCategory = 'General';
    bool gradualVolume = false;
    bool enableVibration = true;
    
    _showAlarmDialog(context, selectedTime, repeatDaily, randomizeSound, selectedSound, notesController, selectedDays, null, selectedCategory, gradualVolume, enableVibration);
  }

  void _showAlarmDialog(BuildContext context, TimeOfDay initialTime, bool initialRepeatDaily, 
      bool initialRandomizeSound, String initialSound, TextEditingController notesController, 
      List<bool> initialSelectedDays, int? editingAlarmId, String initialCategory, bool initialGradualVolume, bool initialEnableVibration) {
    TimeOfDay selectedTime = initialTime;
    bool repeatDaily = initialRepeatDaily;
    bool randomizeSound = initialRandomizeSound;
    String selectedSound = initialSound;
    List<bool> selectedDays = List.from(initialSelectedDays);
    String selectedCategory = initialCategory;
    bool gradualVolume = initialGradualVolume;
    bool enableVibration = initialEnableVibration;
    
    final List<String> categories = ['General', 'Study', 'Exercise', 'Medicine', 'Meeting', 'Wake Up', 'Sleep'];
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GlassContainer(
            width: double.infinity,
            borderRadius: 30,
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Set Alarm", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () async {
                          final TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (time != null) {
                            setState(() => selectedTime = time);
                          }
                        },
                        child: Text(
                          "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}",
                          style: const TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // v5.0: Day Selector
                      const Text("Repeat on Days:", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (index) {
                          final dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDays[index] = !selectedDays[index];
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectedDays[index] 
                                    ? Colors.cyanAccent 
                                    : Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: selectedDays[index] 
                                      ? Colors.cyanAccent 
                                      : Colors.white30,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  dayLabels[index],
                                  style: TextStyle(
                                    color: selectedDays[index] 
                                        ? Colors.black 
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      
                      // v5.0: Notes Field
                      TextField(
                        controller: notesController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Reminder Note',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: 'Add a note for this alarm...',
                          hintStyle: const TextStyle(color: Colors.white30),
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
                      
                      // Enhanced: Category Selection
                      const Text("Alarm Category:", style: TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((category) {
                          final isSelected = selectedCategory == category;
                          IconData icon;
                          Color color;
                          
                          switch (category) {
                            case 'Study':
                              icon = Icons.school;
                              color = Colors.blue;
                              break;
                            case 'Exercise':
                              icon = Icons.fitness_center;
                              color = Colors.green;
                              break;
                            case 'Medicine':
                              icon = Icons.medication;
                              color = Colors.red;
                              break;
                            case 'Meeting':
                              icon = Icons.people;
                              color = Colors.orange;
                              break;
                            case 'Wake Up':
                              icon = Icons.wb_sunny;
                              color = Colors.amber;
                              break;
                            case 'Sleep':
                              icon = Icons.bedtime;
                              color = Colors.indigo;
                              break;
                            default:
                              icon = Icons.alarm;
                              color = Colors.cyanAccent;
                          }
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? color.withOpacity(0.3) : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? color : Colors.white30,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(icon, color: isSelected ? color : Colors.white70, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    category,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white70,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      
                      // Enhanced: Smart Wake-up Suggestions
                      if (selectedCategory == 'Wake Up')
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Smart Wake-up Suggestions',
                                    style: TextStyle(
                                      color: Colors.amber.shade200,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Optimal sleep cycles: 6h, 7.5h, or 9h\n• Avoid snoozing for better alertness\n• Consider gradual volume increase',
                                style: TextStyle(
                                  color: Colors.amber.shade100,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (selectedCategory == 'Wake Up')
                        const SizedBox(height: 20),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Repeat Daily", style: TextStyle(color: Colors.white)),
                          Switch(
                            value: repeatDaily,
                            onChanged: (val) => setState(() => repeatDaily = val),
                            activeColor: Colors.deepPurpleAccent,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Randomize Sound", style: TextStyle(color: Colors.white)),
                          Switch(
                            value: randomizeSound,
                            onChanged: (val) => setState(() => randomizeSound = val),
                            activeColor: Colors.cyanAccent,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("Gradual Volume", style: TextStyle(color: Colors.white)),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.volume_up,
                                color: gradualVolume ? Colors.green : Colors.white30,
                                size: 18,
                              ),
                            ],
                          ),
                          Switch(
                            value: gradualVolume,
                            onChanged: (val) => setState(() => gradualVolume = val),
                            activeColor: Colors.green,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text("Vibration", style: TextStyle(color: Colors.white)),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.vibration,
                                color: enableVibration ? Colors.purple : Colors.white30,
                                size: 18,
                              ),
                            ],
                          ),
                          Switch(
                            value: enableVibration,
                            onChanged: (val) => setState(() => enableVibration = val),
                            activeColor: Colors.purple,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (!randomizeSound)
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                value: selectedSound,
                                dropdownColor: Colors.black87,
                                isExpanded: true,
                                items: Provider.of<AlarmProvider>(context, listen: false)
                                    .availableSounds
                                    .map((sound) => DropdownMenuItem(
                                          value: sound,
                                          child: Text(
                                            sound.split('/').last,
                                            style: const TextStyle(color: Colors.white),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => selectedSound = val);
                                    AudioPreviewService.playPreview(val);
                                  }
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
                              onPressed: () => AudioPreviewService.stopPreview(),
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () {
                              AudioPreviewService.stopPreview();
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
                          ),
                          GlassButton(
                            onTap: () {
                              AudioPreviewService.stopPreview();
                              
                              // If editing, delete the old alarm first
                              if (editingAlarmId != null) {
                                Provider.of<AlarmProvider>(context, listen: false).stopAlarm(editingAlarmId);
                              }
                              
                              final now = DateTime.now();
                              
                              // If randomize is selected, pick a random sound now
                              String finalSound = selectedSound;
                              if (randomizeSound) {
                                final sounds = Provider.of<AlarmProvider>(context, listen: false).availableSounds;
                                if (sounds.isNotEmpty) {
                                  finalSound = sounds[DateTime.now().millisecond % sounds.length];
                                }
                              }

                              final reminderNote = notesController.text.trim();
                              
                              // v5.0: Check if specific days are selected
                              final hasSelectedDays = selectedDays.any((selected) => selected);
                              
                              if (hasSelectedDays) {
                                // BUG FIX: Schedule alarms for next occurrence of each selected day
                                final baseId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                                
                                for (int i = 0; i < 7; i++) {
                                  if (selectedDays[i]) {
                                    // Calculate next occurrence of this day
                                    // i=0 is Monday (weekday 1), i=6 is Sunday (weekday 7)
                                    int targetWeekday = i + 1; // Convert to DateTime weekday (1=Monday, 7=Sunday)
                                    int currentWeekday = now.weekday;
                                    int daysUntilTarget = (targetWeekday - currentWeekday) % 7;
                                    
                                    // If it's today but time has passed, schedule for next week
                                    DateTime targetDate = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    ).add(Duration(days: daysUntilTarget));
                                    
                                    if (targetDate.isBefore(now) || targetDate.isAtSameMomentAs(now)) {
                                      targetDate = targetDate.add(const Duration(days: 7));
                                    }
                                    
                                    final alarmId = baseId + i;
                                    Provider.of<AlarmProvider>(context, listen: false)
                                        .scheduleAlarmWithNote(
                                          targetDate, 
                                          finalSound, 
                                          reminderNote,
                                          loopAudio: repeatDaily,
                                          alarmId: alarmId,
                                        );
                                  }
                                }
                              } else {
                                // Single alarm
                                DateTime dt = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                if (dt.isBefore(now)) {
                                  dt = dt.add(const Duration(days: 1));
                                }
                                
                                Provider.of<AlarmProvider>(context, listen: false)
                                    .scheduleAlarmWithNote(
                                      dt, 
                                      finalSound, 
                                      reminderNote,
                                      loopAudio: repeatDaily,
                                    );
                              }
                              
                              Navigator.pop(context);
                            },
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            child: const Text("Save"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

  void _showHistoryDialog(BuildContext context, AlarmProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return GlassContainer(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          borderRadius: 30,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Alarm History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (provider.alarmHistory.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        provider.clearHistory();
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: provider.alarmHistory.isEmpty
                    ? const Center(
                        child: Text(
                          'No alarm history yet',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: provider.alarmHistory.length,
                        itemBuilder: (context, index) {
                          final entry = provider.alarmHistory[index];
                          final timestamp = DateTime.parse(entry['timestamp']);
                          final dateStr = '${timestamp.day}/${timestamp.month}/${timestamp.year}';
                          final timeStr = '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
                          
                          IconData icon;
                          Color iconColor;
                          
                          switch (entry['action']) {
                            case 'Deleted':
                              icon = Icons.delete;
                              iconColor = Colors.red;
                              break;
                            case 'Dismissed':
                              icon = Icons.check_circle;
                              iconColor = Colors.green;
                              break;
                            default:
                              icon = Icons.snooze;
                              iconColor = Colors.orange;
                          }
                          
                          return Card(
                            color: Colors.white.withOpacity(0.1),
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: Icon(icon, color: iconColor),
                              title: Text(
                                entry['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${entry['action']} • $dateStr at $timeStr',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: Text(
                                entry['time'],
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
