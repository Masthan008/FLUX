import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashGeneratorScreen extends StatefulWidget {
  const HashGeneratorScreen({super.key});

  @override
  State<HashGeneratorScreen> createState() => _HashGeneratorScreenState();
}

class _HashGeneratorScreenState extends State<HashGeneratorScreen> {
  final _textController = TextEditingController();
  String _md5 = '';
  String _sha1 = '';
  String _sha256 = '';
  String _sha512 = '';
  String _base64 = '';

  void _generateHashes() {
    final input = _textController.text;
    if (input.isEmpty) return;

    final bytes = utf8.encode(input);

    setState(() {
      _md5 = md5.convert(bytes).toString();
      _sha1 = sha1.convert(bytes).toString();
      _sha256 = sha256.convert(bytes).toString();
      _sha512 = sha512.convert(bytes).toString();
      _base64 = base64.encode(bytes);
    });
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copied to clipboard', style: GoogleFonts.montserrat()),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.tag, color: Colors.orange),
            const SizedBox(width: 12),
            Text(
              'Hash Generator',
              style: GoogleFonts.orbitron(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        iconTheme: const IconThemeData(color: Colors.cyan),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Input section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withOpacity(0.1),
                  Colors.red.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input Text',
                  style: GoogleFonts.orbitron(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _textController,
                  maxLines: 3,
                  style: GoogleFonts.robotoMono(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter text to hash...',
                    hintStyle: GoogleFonts.robotoMono(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.orange.withOpacity(0.5)),
                    ),
                  ),
                  onChanged: (_) => _generateHashes(),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2),

          const SizedBox(height: 24),

          // Hash results
          if (_md5.isNotEmpty) ...[
            _buildHashCard('MD5', _md5, Colors.red),
            _buildHashCard('SHA-1', _sha1, Colors.orange),
            _buildHashCard('SHA-256', _sha256, Colors.green),
            _buildHashCard('SHA-512', _sha512, Colors.blue),
            _buildHashCard('Base64', _base64, Colors.purple),
          ],
        ],
      ),
    );
  }

  Widget _buildHashCard(String label, String hash, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.orbitron(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                color: color,
                onPressed: () => _copyToClipboard(hash, label),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hash,
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 12,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}
