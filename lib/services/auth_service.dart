import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';

class AuthService {
  static final Box _box = Hive.box('user_prefs');
  static final LocalAuthentication _auth = LocalAuthentication();

  static String? get userRole => _box.get('user_role');
  static String? get userName => _box.get('user_name');
  static String? get userId => _box.get('user_id'); // Roll No
  static bool get isBiometricEnabled => _box.get('biometric_enabled', defaultValue: false);
  static bool get isLoggedIn => _box.get('user_role') != null;
  static bool get isOnboardingCompleted => _box.get('onboarding_completed', defaultValue: false);

  // 1. Authenticate (The Real Biometric Check)
  static Future<bool> authenticate() async {
    try {
      // Check if hardware is available
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        debugPrint("⚠️ Biometrics not available on this device.");
        return true; // Fallback: Allow entry if no hardware exists
      }

      // Check if biometrics are enrolled
      final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        debugPrint("⚠️ No biometrics enrolled on this device.");
        return true; // Fallback: Allow entry if no biometrics enrolled
      }

      // Trigger the Dialog
      final result = await _auth.authenticate(
        localizedReason: 'Authenticate to access FluxFlow',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allows PIN backup if biometric fails
        ),
      );
      
      debugPrint("✅ Authentication result: $result");
      return result;
    } on PlatformException catch (e) {
      debugPrint("❌ Auth Error: ${e.code} - ${e.message}");
      
      // Handle specific error cases
      switch (e.code) {
        case 'UserCancel':
        case 'SystemCancel':
          return false; // User cancelled
        case 'NotAvailable':
        case 'NotEnrolled':
          return true; // Fallback: Allow entry if biometric not available
        case 'LockedOut':
          debugPrint("🔒 Biometric locked out, allowing fallback");
          return true; // Allow entry but biometric is locked
        default:
          return false;
      }
    } catch (e) {
      debugPrint("❌ Unexpected auth error: $e");
      return false;
    }
  }

  // 2. Student Entry (Local Save)
  static Future<void> studentEntry(String name, String id, String branch) async {
    var box = Hive.box('user_prefs');
    await box.put('user_name', name);
    await box.put('user_id', id);
    await box.put('branch', branch);
    await box.put('user_role', 'student');
  }

  // 3. Logout
  static Future<void> logout() async {
    await Hive.box('user_prefs').clear();
  }

  static Future<void> showSetupDialog(BuildContext context, VoidCallback onComplete) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SetupDialog();
      },
    );
    
    // Only call onComplete if setup was successful
    if (result == true) {
      onComplete();
    }
  }
}

class SetupDialog extends StatefulWidget {
  const SetupDialog({super.key});

  @override
  State<SetupDialog> createState() => _SetupDialogState();
}

class _SetupDialogState extends State<SetupDialog> {
  bool? isStudent;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Welcome to FluxFlow'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isStudent == null) ...[
              const Text('Who are you?'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => setState(() => isStudent = true),
                child: const Text('I am a Student'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => setState(() => isStudent = false),
                child: const Text('I am a Teacher'),
              ),
            ] else if (isStudent == true) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(labelText: 'Roll Number'),
              ),
            ] else ...[
              const Text('Set your Teacher PIN (Default: 1234)'),
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: 'Enter PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (isStudent != null)
          TextButton(
            onPressed: () async {
              final box = Hive.box('user_prefs');
              if (isStudent!) {
                if (_nameController.text.isEmpty || _idController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }
                await box.put('user_role', 'student');
                await box.put('user_name', _nameController.text.trim());
                await box.put('user_id', _idController.text.trim());
              } else {
                final pin = _pinController.text.trim();
                if (pin.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please set a PIN')),
                  );
                  return;
                }
                await box.put('user_role', 'teacher');
                await box.put('teacher_pin', pin);
                await box.put('user_name', 'Teacher');
              }
              if (mounted) Navigator.pop(context, true); // Return success
            },
            child: const Text('Save & Continue'),
          ),
      ],
    );
  }
}
