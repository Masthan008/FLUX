import 'package:flutter/material.dart';
import '../../services/launcher_service.dart';

class CompilerScreen extends StatelessWidget {
  const CompilerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Online Compilers',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCompilerButton(
              context,
              'Open Python Compiler',
              'https://www.programiz.com/python-programming/online-compiler/',
              Icons.code,
              Colors.yellowAccent,
            ),
            const SizedBox(height: 32),
            _buildCompilerButton(
              context,
              'Open C Compiler',
              'https://www.programiz.com/c-programming/online-compiler/',
              Icons.computer,
              Colors.cyanAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompilerButton(
    BuildContext context,
    String label,
    String url,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: 300,
      height: 80,
      child: ElevatedButton.icon(
        onPressed: () => LauncherService.openLink(url),
        icon: Icon(icon, size: 32, color: Colors.black),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
        ),
      ),
    );
  }
}
