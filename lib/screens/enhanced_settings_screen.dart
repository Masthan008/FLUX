import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart'; // For timeDilation
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/battery_service.dart';
import '../services/auth_service.dart';
import '../services/backup_service.dart';
import '../services/enhanced_data_management_service.dart';
import '../providers/theme_provider.dart';
import '../providers/accessibility_provider.dart';
import 'settings/main_settings_screen.dart';
import 'auth_screen.dart';

class EnhancedSettingsScreen extends StatefulWidget {
  const EnhancedSettingsScreen({super.key});

  @override
  State<EnhancedSettingsScreen> createState() => _EnhancedSettingsScreenState();
}

class _EnhancedSettingsScreenState extends State<EnhancedSettingsScreen> 
    with TickerProviderStateMixin {
  late Box _settingsBox;
  bool _powerSaverMode = false;
  bool _biometricLock = false;
  bool _batteryOptimizationDisabled = false;
  late AnimationController _mainAnimationController;
  late AnimationController _profileAnimationController;
  late AnimationController _settingsAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSettings();
  }

  void _initializeAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _profileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _settingsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _profileAnimationController,
      curve: Curves.elasticOut,
    ));

    _mainAnimationController.forward();
    _profileAnimationController.forward();
    _settingsAnimationController.forward();
  }

  void _loadSettings() async {
    _settingsBox = await Hive.openBox('user_prefs');
    setState(() {
      _powerSaverMode = _settingsBox.get('power_saver_mode', defaultValue: false);
      _biometricLock = _settingsBox.get('biometric_lock', defaultValue: false);
      _batteryOptimizationDisabled = _settingsBox.get('battery_optimization_disabled', defaultValue: false);
    });
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _profileAnimationController.dispose();
    _settingsAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final accessibilityProvider = Provider.of<AccessibilityProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    // Dynamic colors based on theme
    final primaryColor = isDark ? Colors.cyanAccent : Colors.blue;
    final backgroundColor = isDark ? const Color(0xFF0A0A0A) : Colors.grey[50];
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar with Gradient
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.8),
                      primaryColor.withOpacity(0.6),
                      primaryColor.withOpacity(0.4),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Profile Avatar with Animation
                      AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.3),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.5),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      // User Name with Animation
                      Text(
                        'Settings & Preferences',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                      const SizedBox(height: 8),
                      Text(
                        'Customize your experience',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          
          // Settings Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Theme Settings Section
                  _buildSettingsSection(
                    title: 'Appearance',
                    icon: Icons.palette_outlined,
                    color: primaryColor,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    cardColor: cardColor,
                    children: [
                      _buildThemeSelector(themeProvider, textColor, subtitleColor, cardColor),
                      const SizedBox(height: 16),
                      _buildAccessibilitySettings(accessibilityProvider, textColor, subtitleColor, cardColor),
                    ],
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.3),
                  
                  const SizedBox(height: 24),
                  
                  // Performance Settings Section
                  _buildSettingsSection(
                    title: 'Performance',
                    icon: Icons.speed_outlined,
                    color: Colors.orange,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    cardColor: cardColor,
                    children: [
                      _buildPerformanceSettings(textColor, subtitleColor),
                    ],
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.3),
                  
                  const SizedBox(height: 24),
                  
                  // Security Settings Section
                  _buildSettingsSection(
                    title: 'Security & Privacy',
                    icon: Icons.security_outlined,
                    color: Colors.green,
                    textColor: textColor,
                    subtitleColor: subtitleColor,
                    cardColor: cardColor,
                    children: [
                      _buildSecuritySettings(textColor, subtitleColor),
                    ],
                  ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.3),
                  
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  _buildActionButtons(textColor, cardColor, primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required Color color,
    required Color textColor,
    required Color? subtitleColor,
    required Color cardColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
  Widget _buildThemeSelector(ThemeProvider themeProvider, Color textColor, Color? subtitleColor, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Mode',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              _buildThemeOption(
                'Light',
                Icons.light_mode_outlined,
                !themeProvider.isDarkMode,
                () => themeProvider.setThemeMode(false),
                textColor,
                subtitleColor,
              ),
              _buildThemeOption(
                'Dark',
                Icons.dark_mode_outlined,
                themeProvider.isDarkMode,
                () => themeProvider.setThemeMode(true),
                textColor,
                subtitleColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption(String title, IconData icon, bool isSelected, VoidCallback onTap, Color textColor, Color? subtitleColor) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue : subtitleColor,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.blue : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibilitySettings(AccessibilityProvider accessibilityProvider, Color textColor, Color? subtitleColor, Color cardColor) {
    return Column(
      children: [
        _buildSwitchTile(
          title: 'Large Text',
          subtitle: 'Increase text size for better readability',
          value: accessibilityProvider.largeText,
          onChanged: (value) => accessibilityProvider.setLargeText(value),
          icon: Icons.text_fields_outlined,
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          title: 'High Contrast',
          subtitle: 'Enhance visual contrast',
          value: accessibilityProvider.highContrast,
          onChanged: (value) => accessibilityProvider.setHighContrast(value),
          icon: Icons.contrast_outlined,
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          title: 'Reduce Animations',
          subtitle: 'Minimize motion for sensitive users',
          value: accessibilityProvider.reduceAnimations,
          onChanged: (value) => accessibilityProvider.setReduceAnimations(value),
          icon: Icons.animation_outlined,
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
      ],
    );
  }

  Widget _buildPerformanceSettings(Color textColor, Color? subtitleColor) {
    return Column(
      children: [
        _buildSwitchTile(
          title: 'Power Saver Mode',
          subtitle: 'Disable animations to save battery',
          value: _powerSaverMode,
          onChanged: (value) {
            setState(() {
              _powerSaverMode = value;
              // 🚀 THE MAGIC LINE: Kill all animations when Power Saver is ON
              timeDilation = value ? 0.0 : 1.0;
            });
            _settingsBox.put('power_saver_mode', value);
            if (value) {
              BatteryService.enablePowerSaverMode();
            } else {
              BatteryService.disablePowerSaverMode();
            }
          },
          icon: Icons.battery_saver_outlined,
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          title: 'Battery Optimization',
          subtitle: 'Disable battery optimization for better performance',
          value: _batteryOptimizationDisabled,
          onChanged: (value) async {
            setState(() {
              _batteryOptimizationDisabled = value;
            });
            _settingsBox.put('battery_optimization_disabled', value);
            if (value) {
              await BatteryService.requestIgnoreBatteryOptimizations();
            }
          },
          icon: Icons.battery_charging_full_outlined,
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
      ],
    );
  }

  Widget _buildSecuritySettings(Color textColor, Color? subtitleColor) {
    return Column(
      children: [
        _buildActionTile(
          title: 'Privacy Settings',
          subtitle: 'Manage data collection and permissions',
          icon: Icons.privacy_tip_outlined,
          onTap: () {
            // Navigate to privacy settings
          },
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
      ],
    );
  }

  Widget _buildDataManagementSettings(Color textColor, Color? subtitleColor) {
    return Column(
      children: [
        _buildActionTile(
          title: 'Full Backup',
          subtitle: 'Complete backup with cloud sync',
          icon: Icons.backup_outlined,
          onTap: () => _showBackupDialog(textColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          title: 'Cloud Sync',
          subtitle: 'Sync data with Supabase cloud',
          icon: Icons.cloud_sync_outlined,
          onTap: () => _performCloudSync(),
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          title: 'Restore Data',
          subtitle: 'Restore from backup file or cloud',
          icon: Icons.restore_outlined,
          onTap: () => _showRestoreDialog(textColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          title: 'Export Options',
          subtitle: 'Export data in various formats',
          icon: Icons.file_download_outlined,
          onTap: () => _showExportDialog(textColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          title: 'Academic Report',
          subtitle: 'Generate detailed progress report',
          icon: Icons.assessment_outlined,
          onTap: () => _generateAcademicReport(),
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          title: 'Data Statistics',
          subtitle: 'View backup and storage info',
          icon: Icons.analytics_outlined,
          onTap: () => _showDataStatistics(textColor),
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
    required Color textColor,
    required Color? subtitleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? Colors.blue : subtitleColor,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Switch.adaptive(
              key: ValueKey(value),
              value: value,
              onChanged: onChanged,
              activeColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required Color textColor,
    required Color? subtitleColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: subtitleColor,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Color textColor, Color cardColor, Color primaryColor) {
    return Column(
      children: [
        // Logout Button
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.6)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showLogoutDialog(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3),
        
        const SizedBox(height: 16),
        
        // Version Info
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Version 1.0.0',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3),
      ],
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.logout();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false,
                );
              }
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBackupDialog(Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.backup, color: Colors.blue, size: 24),
            const SizedBox(width: 8),
            Text(
              'Create Backup',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose backup options:',
              style: GoogleFonts.poppins(color: textColor),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _createLocalBackup();
                    },
                    icon: Icon(Icons.storage),
                    label: Text('Local Only'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _createCloudBackup();
                    },
                    icon: Icon(Icons.cloud),
                    label: Text('Cloud Sync'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createLocalBackup() async {
    try {
      _showLoadingDialog('Creating backup...');
      
      // Initialize Hive boxes first
      await EnhancedDataManagementService.initializeHiveBoxes();
      
      final backup = await EnhancedDataManagementService.createFullBackup(includeCloudData: false);
      final filePath = await EnhancedDataManagementService.saveBackupToFile(backup);
      
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Backup saved to: ${filePath.split('/').last}'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Share',
            onPressed: () async {
              await Share.shareXFiles([XFile(filePath)]);
            },
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Backup failed: $e');
    }
  }

  Future<void> _createCloudBackup() async {
    try {
      _showLoadingDialog('Syncing to cloud...');
      
      // Initialize Hive boxes first
      await EnhancedDataManagementService.initializeHiveBoxes();
      
      final backup = await EnhancedDataManagementService.createFullBackup();
      final cloudFileName = await EnhancedDataManagementService.uploadBackupToCloud(backup);
      
      Navigator.pop(context); // Close loading dialog
      
      if (cloudFileName != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Backup synced to cloud successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorDialog('Cloud sync failed. Check your internet connection.');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Cloud backup failed: $e');
    }
  }

  Future<void> _performCloudSync() async {
    try {
      _showLoadingDialog('Syncing with cloud...');
      
      final success = await EnhancedDataManagementService.syncWithCloud();
      
      Navigator.pop(context); // Close loading dialog
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cloud sync completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorDialog('Cloud sync failed. Please try again.');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Cloud sync error: $e');
    }
  }

  void _showRestoreDialog(Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.restore, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            Text(
              'Restore Data',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose restore source:',
              style: GoogleFonts.poppins(color: textColor),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _restoreFromFile();
                    },
                    icon: Icon(Icons.file_open),
                    label: Text('From File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _showCloudBackups();
                    },
                    icon: Icon(Icons.cloud_download),
                    label: Text('From Cloud'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreFromFile() async {
    try {
      _showLoadingDialog('Restoring from file...');
      
      final success = await EnhancedDataManagementService.importFromFile();
      
      Navigator.pop(context); // Close loading dialog
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data restored successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorDialog('Restore failed or cancelled');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Restore error: $e');
    }
  }

  Future<void> _showCloudBackups() async {
    try {
      _showLoadingDialog('Loading cloud backups...');
      
      final backups = await EnhancedDataManagementService.listCloudBackups();
      
      Navigator.pop(context); // Close loading dialog
      
      if (backups.isEmpty) {
        _showErrorDialog('No cloud backups found');
        return;
      }
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            'Cloud Backups',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: backups.length,
              itemBuilder: (context, index) {
                final backup = backups[index];
                final createdAt = DateTime.parse(backup['created_at']);
                final size = backup['file_size'] ?? 0;
                
                return ListTile(
                  leading: Icon(Icons.backup, color: Colors.blue),
                  title: Text(
                    backup['file_name'],
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
                  ),
                  subtitle: Text(
                    '${createdAt.toString().split('.')[0]}\nSize: ${EnhancedDataManagementService._formatBytes(size)}',
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 10),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _restoreFromCloud(backup['file_name']);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Failed to load cloud backups: $e');
    }
  }

  Future<void> _restoreFromCloud(String fileName) async {
    try {
      _showLoadingDialog('Restoring from cloud...');
      
      final success = await EnhancedDataManagementService.restoreFromCloudBackup(fileName);
      
      Navigator.pop(context); // Close loading dialog
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Data restored from cloud successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorDialog('Cloud restore failed');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Cloud restore error: $e');
    }
  }

  void _showExportDialog(Color textColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.file_download, color: Colors.purple, size: 24),
            const SizedBox(width: 8),
            Text(
              'Export Data',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose export format:',
              style: GoogleFonts.poppins(color: textColor),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _exportData('json');
                    },
                    icon: Icon(Icons.code),
                    label: Text('JSON Format'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _exportData('csv');
                    },
                    icon: Icon(Icons.table_chart),
                    label: Text('CSV Format'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _exportData('txt');
                    },
                    icon: Icon(Icons.text_snippet),
                    label: Text('Text Report'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(String format) async {
    try {
      _showLoadingDialog('Exporting data...');
      
      final filePath = await EnhancedDataManagementService.exportToFormat(format);
      
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data exported to: ${filePath.split('/').last}'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Share',
            onPressed: () async {
              await Share.shareXFiles([XFile(filePath)]);
            },
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Export failed: $e');
    }
  }

  Future<void> _generateAcademicReport() async {
    try {
      _showLoadingDialog('Generating report...');
      
      final filePath = await BackupService.exportAcademicReport();
      
      Navigator.pop(context); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Academic report generated'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'Share',
            onPressed: () async {
              await Share.shareXFiles([XFile(filePath)]);
            },
          ),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Report generation failed: $e');
    }
  }

  Future<void> _showDataStatistics(Color textColor) async {
    try {
      _showLoadingDialog('Loading statistics...');
      
      // Initialize Hive boxes first
      await EnhancedDataManagementService.initializeHiveBoxes();
      
      final stats = await EnhancedDataManagementService.getBackupStatistics();
      
      Navigator.pop(context); // Close loading dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.analytics, color: Colors.cyan, size: 24),
              const SizedBox(width: 8),
              Text(
                'Data Statistics',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStatRow('Total Items', '${stats['total_items'] ?? 0}', Icons.storage),
                _buildStatRow('Backup Size', stats['backup_size_formatted'] ?? '0 B', Icons.folder_zip),
                _buildStatRow('Last Backup', _formatDate(stats['last_backup']), Icons.schedule),
                _buildStatRow('Version', stats['version'] ?? 'Unknown', Icons.info),
                const SizedBox(height: 16),
                Text(
                  'Category Breakdown:',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                ...((stats['category_stats'] as Map<String, dynamic>?) ?? {}).entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        Text(
                          '${entry.value}',
                          style: GoogleFonts.poppins(color: Colors.white),
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
              child: Text(
                'Close',
                style: GoogleFonts.poppins(color: Colors.cyan),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      _showErrorDialog('Failed to load statistics: $e');
    }
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyan, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Never';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Unknown';
    }
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.cyan),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}