import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BatteryService {
  /// Check and request battery optimization exemption
  /// This is critical for ensuring alarms work reliably
  static Future<bool> checkBatteryOptimization() async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.status;
      
      if (status.isGranted) {
        debugPrint('✅ Battery optimization already disabled');
        return true;
      }
      
      debugPrint('⚠️ Battery optimization is enabled, requesting permission...');
      return false;
    } catch (e) {
      debugPrint('❌ Error checking battery optimization: $e');
      return false;
    }
  }

  /// Request battery optimization exemption
  static Future<bool> requestBatteryOptimization(BuildContext context) async {
    try {
      final status = await Permission.ignoreBatteryOptimizations.request();
      
      if (status.isGranted) {
        debugPrint('✅ Battery optimization disabled successfully');
        // Snackbar removed - silent success
        return true;
      } else {
        debugPrint('❌ Battery optimization permission denied');
        if (context.mounted) {
          _showBatteryWarningDialog(context);
        }
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error requesting battery optimization: $e');
      return false;
    }
  }

  /// Show warning dialog about battery optimization
  static void _showBatteryWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.battery_alert, color: Colors.orange, size: 32),
            SizedBox(width: 10),
            Text('Battery Warning'),
          ],
        ),
        content: const Text(
          'Battery optimization is enabled. This may prevent alarms from ringing when the screen is off.\n\n'
          'For reliable alarms:\n'
          '1. Go to Settings\n'
          '2. Battery → Battery Optimization\n'
          '3. Find "FluxFlow" and disable optimization',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I Understand'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Initialize battery optimization check (call from splash screen)
  static Future<void> initializeBatteryOptimization(BuildContext context) async {
    final isOptimized = await checkBatteryOptimization();
    
    if (!isOptimized) {
      // Wait a bit before showing the request
      await Future.delayed(const Duration(seconds: 1));
      
      if (context.mounted) {
        await requestBatteryOptimization(context);
      }
    }
  }
}
