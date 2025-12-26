import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../services/battery_service.dart';
import '../services/auth_service.dart';
import '../services/backup_service.dart';
import '../providers/theme_provider.dart';
import '../providers/accessibility_provider.dart';
import '../services/student_auth_service.dart'; // Added missing import
import 'settings/main_settings_screen.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  late Box _settingsBox;
  bool _powerSaverMode = false;
  bool _biometricLock = false;
  bool _batteryOptimizationDisabled = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _loadSettings();
    _animationController.forward();
  }

  Future<void> _loadSettings() async {
    _settingsBox = await Hive.openBox('user_prefs');
    
    setState(() {
      _powerSaverMode = _settingsBox.get('power_saver', defaultValue: false);
      _biometricLock = _settingsBox.get('biometric_enabled', defaultValue: true);
    });
    
    // Check battery optimization status
    final batteryStatus = await BatteryService.checkBatteryOptimization();
    setState(() {
      _batteryOptimizationDisabled = batteryStatus;
    });
  }

  Future<void> _togglePowerSaver(bool value) async {
    await _settingsBox.put('power_saver', value);
    setState(() => _powerSaverMode = value);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text(
          value ? 'Power Saver Mode enabled' : 'Power Saver Mode disabled',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    await _settingsBox.put('biometric_enabled', value);
    setState(() => _biometricLock = value);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text(
          value ? 'Biometric Lock enabled' : 'Biometric Lock disabled',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _requestBatteryOptimization() async {
    final result = await BatteryService.requestBatteryOptimization(context);
    setState(() => _batteryOptimizationDisabled = result);
  }

  Future<void> _editProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      // 1. Upload to Supabase Storage & Update Profile
      final imageUrl = await StudentAuthService.uploadProfileImage(File(image.path));
      
      if (imageUrl != null) {
        await StudentAuthService.updateProfile(imageUrl: imageUrl);
        
        // 2. Update Hive (Local Cache) - redundancy, but safe
        final userPrefs = Hive.box('user_prefs');
        await userPrefs.put('user_photo', imageUrl); // Store URL, not path
        
        setState(() {});
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.cyanAccent,
            content: Text('Profile photo updated everywhere!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  Future<void> _createBackup() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.black87,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.cyanAccent),
              SizedBox(width: 16),
              Text('Creating backup...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      // Create backup
      await BackupService.shareBackup();
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup created and ready to share!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Backup failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportData() async {
    try {
      // Show export options
      final option = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Export Options', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.description, color: Colors.cyanAccent),
                title: const Text('Academic Report', style: TextStyle(color: Colors.white)),
                subtitle: const Text('PDF report with statistics', style: TextStyle(color: Colors.grey)),
                onTap: () => Navigator.pop(context, 'report'),
              ),
              ListTile(
                leading: const Icon(Icons.backup, color: Colors.green),
                title: const Text('Full Backup', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Complete data export', style: TextStyle(color: Colors.grey)),
                onTap: () => Navigator.pop(context, 'backup'),
              ),
            ],
          ),
        ),
      );

      if (option != null) {
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const AlertDialog(
            backgroundColor: Colors.black87,
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.green),
                SizedBox(width: 16),
                Text('Exporting data...', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        );

        if (option == 'report') {
          await BackupService.exportAcademicReport();
        } else {
          await BackupService.shareBackup();
        }

        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data exported successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _generateReport() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.black87,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.green),
              SizedBox(width: 16),
              Text('Generating report...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      final reportPath = await BackupService.exportAcademicReport();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Academic report generated successfully!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Share',
            onPressed: () async {
              await Share.shareXFiles([XFile(reportPath)]);
            },
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report generation failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cloudSync() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.black87,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(width: 16),
              Text('Syncing with cloud...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      // Simulate cloud sync
      await Future.delayed(const Duration(seconds: 2));
      await BackupService.performAutoBackup();
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cloud sync completed successfully!'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cloud sync failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showExportOptions() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Export Options', style: TextStyle(color: Colors.purple)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.backup, color: Colors.cyanAccent),
              title: const Text('Full Backup (JSON)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Complete data export', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _createBackup();
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: Colors.green),
              title: const Text('Academic Report (TXT)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Progress and statistics', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _generateReport();
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.orange),
              title: const Text('Data Tables (CSV)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Spreadsheet format', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _exportCSV();
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('PDF Report', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Formatted document', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _exportPDF();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportCSV() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CSV export feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _exportPDF() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF export feature coming soon!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _showDataStatistics() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          backgroundColor: Colors.black87,
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.yellow),
              SizedBox(width: 16),
              Text('Loading statistics...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      final stats = await BackupService.getBackupStats();
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Data Statistics', style: TextStyle(color: Colors.yellow)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatItem('Total Data Size', '${(stats['total_size'] ?? 0) ~/ 1024} KB'),
                _buildStatItem('Academic Records', '${stats['academic_records'] ?? 0}'),
                _buildStatItem('Chat Messages', '${stats['chat_messages'] ?? 0}'),
                _buildStatItem('Calculator History', '${stats['calculator_history'] ?? 0}'),
                _buildStatItem('Last Backup', stats['last_backup']?.toString().split('T')[0] ?? 'Never'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.yellow)),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load statistics: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _restoreData() async {
    try {
      // Show file picker to select backup file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey.shade900,
            title: const Text('Restore Data', style: TextStyle(color: Colors.orange)),
            content: const Text(
              'This will replace your current data with backup data. Are you sure?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Restore', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        );

        if (confirm == true) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              backgroundColor: Colors.black87,
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(width: 16),
                  Text('Restoring data...', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );

          // Read and parse backup file
          final file = File(result.files.single.path!);
          final jsonString = await file.readAsString();
          final backup = jsonDecode(jsonString);

          final success = await BackupService.restoreFromBackup(backup);
          Navigator.pop(context);

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data restored successfully! Please restart the app.'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            throw Exception('Restore operation failed');
          }
        }
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Restore failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?\n\nYour data will be preserved.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Only clear session flag, keep all user data
      final userPrefs = Hive.box('user_prefs');
      await userPrefs.put('is_logged_in', false);
      
      // Navigate to auth screen
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _editName() async {
    final userPrefs = Hive.box('user_prefs');
    final currentName = userPrefs.get('user_name', defaultValue: 'Student');
    
    final TextEditingController controller = TextEditingController(text: currentName);
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                 // 1. UPDATE SUPABASE via Service
                 await StudentAuthService.updateProfile(name: newName);

                 // 2. UPDATE HIVE (The Local Cache)
                 await userPrefs.put('user_name', newName); // Ensure consistency
                 
                 setState(() {});
                 Navigator.pop(context);
                 
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Profile Updated Everywhere! Restart app to see changes in Drawer.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if user_prefs box is open, if not return loading
    if (!Hive.isBoxOpen('user_prefs')) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.grey.shade900,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.cyanAccent),
        ),
      );
    }
    
    final userPrefs = Hive.box('user_prefs');
    final userName = userPrefs.get('user_name', defaultValue: 'Student');
    final userPhoto = userPrefs.get('user_photo');
    
    return Consumer2<ThemeProvider, AccessibilityProvider>(
      builder: (context, themeProvider, accessibilityProvider, child) {
        return Container(
          decoration: themeProvider.getCurrentBackgroundDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Settings'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Card
                // Profile Card (Removed)
                const SizedBox.shrink(),
                
                const SizedBox(height: 24),
                
                // Enhanced Settings Button
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.palette, color: themeProvider.getCurrentPrimaryColor()),
                    title: Text(
                      'Enhanced Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Themes, Accessibility, Dashboard & More',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                    onTap: () {
                      accessibilityProvider.provideFeedback(text: 'Opening enhanced settings');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Legacy Settings Section
                Text(
                  'System Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Power Saver Mode
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: SwitchListTile(
                    title: Text(
                      'Power Saver Mode',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Disable animations to save battery',
                      style: TextStyle(color: Colors.white70),
                    ),
                    value: _powerSaverMode,
                    onChanged: (value) {
                      accessibilityProvider.provideFeedback(
                        text: value ? 'Power saver enabled' : 'Power saver disabled',
                      );
                      _togglePowerSaver(value);
                    },
                    activeColor: Colors.green,
                    secondary: Icon(
                      _powerSaverMode ? Icons.battery_saver : Icons.battery_full,
                      color: _powerSaverMode ? Colors.green : Colors.white70,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Battery Optimization
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(
                      _batteryOptimizationDisabled 
                        ? Icons.battery_charging_full 
                        : Icons.battery_alert,
                      color: _batteryOptimizationDisabled ? Colors.green : Colors.orange,
                    ),
                    title: Text(
                      'Allow Background Running',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    subtitle: Text(
                      _batteryOptimizationDisabled 
                        ? 'Enabled - Alarms will work reliably' 
                        : 'Disabled - May affect alarm reliability',
                      style: TextStyle(
                        color: _batteryOptimizationDisabled ? Colors.green : Colors.orange,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: _batteryOptimizationDisabled 
                        ? null 
                        : () {
                            accessibilityProvider.provideFeedback(text: 'Requesting battery optimization');
                            _requestBatteryOptimization();
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(_batteryOptimizationDisabled ? 'Enabled' : 'Enable'),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Biometric Lock
                // Biometric Lock (Removed)
                const SizedBox.shrink(),
                
                const SizedBox(height: 12),
                
                // System Settings Button
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.settings, color: themeProvider.getCurrentPrimaryColor()),
                    title: Text(
                      'System Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Open Android app settings',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    onTap: () async {
                      accessibilityProvider.provideFeedback(text: 'Opening system settings');
                      await openAppSettings();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: themeProvider.getCurrentPrimaryColor(),
                            content: const Text(
                              'Opening system settings...',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 24-Hour Format Toggle
                ValueListenableBuilder(
                  valueListenable: Hive.box('user_prefs').listenable(),
                  builder: (context, Box box, _) {
                    final use24h = box.get('use24h', defaultValue: false);
                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      child: SwitchListTile(
                        title: Text(
                          'Use 24-Hour Format',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        subtitle: Text(
                          use24h ? 'Time shown as 14:30' : 'Time shown as 2:30 PM',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        value: use24h,
                        onChanged: (value) async {
                          accessibilityProvider.provideFeedback(
                            text: value ? '24-hour format enabled' : '12-hour format enabled',
                          );
                          await box.put('use24h', value);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: themeProvider.getCurrentPrimaryColor(),
                                content: Text(
                                  value ? '24-hour format enabled' : '12-hour format enabled',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        activeColor: themeProvider.getCurrentPrimaryColor(),
                        secondary: Icon(
                          Icons.access_time,
                          color: use24h ? themeProvider.getCurrentPrimaryColor() : Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Data Management Section
                // Data Management Section (Removed)
                const SizedBox.shrink(),

                const SizedBox(height: 24),
                
                // Logout Button
                // Logout Button (Removed)
                const SizedBox.shrink(),
                
                const SizedBox(height: 32),
                
                // App Info
                Text(
                  'About',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: themeProvider.getCurrentPrimaryColor()),
                    title: const Text(
                      'Version',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Text(
                      '1.0.0',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
                
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.code, color: themeProvider.getCurrentPrimaryColor()),
                    title: const Text(
                      'FluxFlow - Ultimate Student OS',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Developed by Masthan Valli',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
