import 'package:url_launcher/url_launcher.dart';

class LauncherService {
  static Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      // Try opening in external app (Best for Drive/PDFs)
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("Error launching: $e");
    }
  }
}
