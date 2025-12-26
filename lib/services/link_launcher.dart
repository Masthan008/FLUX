import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkLauncher {
  
  // Call this function from ANYWHERE (Books, Videos, Projects)
  static Future<void> openLink(BuildContext context, String? rawUrl) async {
    
    // 1. Check if URL is empty
    if (rawUrl == null || rawUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Link is missing!")),
      );
      return;
    }

    // 2. Clean up the URL (Fix missing https)
    String url = rawUrl.trim();
    if (!url.startsWith('http')) {
      url = 'https://$url';
    }

    // 3. Try to Launch
    try {
      final Uri uri = Uri.parse(url);
      
      // Use 'externalApplication' to force Chrome/YouTube/Drive to open
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // 4. Show a helpful error if it fails
      print("Link Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open link. Check your internet.")),
        );
      }
    }
  }
}
