import 'package:flutter/material.dart';
import '../../services/launcher_service.dart';

class CyberVaultScreen extends StatelessWidget {
  const CyberVaultScreen({super.key});

  static final List<Map<String, String>> resources = [
    {
      'name': 'Grey Hat Hacking: The Ethical Hacker\'s Handbook',
      'url': 'https://github.com/topics/ethical-hacking',
      'description': 'Comprehensive guide to ethical hacking and penetration testing',
    },
    {
      'name': 'The Web Application Hacker\'s Handbook',
      'url': 'https://portswigger.net/web-security',
      'description': 'Finding and exploiting security flaws in web applications',
    },
    {
      'name': 'Metasploit: The Penetration Tester\'s Guide',
      'url': 'https://www.metasploit.com/',
      'description': 'Master the Metasploit Framework for penetration testing',
    },
    {
      'name': 'Kali Linux Revealed',
      'url': 'https://www.kali.org/docs/',
      'description': 'Official Kali Linux documentation and training materials',
    },
    {
      'name': 'OWASP Top 10',
      'url': 'https://owasp.org/www-project-top-ten/',
      'description': 'Top 10 web application security risks',
    },
    {
      'name': 'Cybrary - Free Cyber Security Training',
      'url': 'https://www.cybrary.it/',
      'description': 'Free online cybersecurity courses and certifications',
    },
    {
      'name': 'HackTheBox Academy',
      'url': 'https://academy.hackthebox.com/',
      'description': 'Hands-on penetration testing labs and challenges',
    },
    {
      'name': 'NIST Cybersecurity Framework',
      'url': 'https://www.nist.gov/cyberframework',
      'description': 'Framework for improving critical infrastructure cybersecurity',
    },
    {
      'name': 'Awesome Hacking Resources',
      'url': 'https://github.com/vitalysim/Awesome-Hacking-Resources',
      'description': 'Curated collection of hacking tutorials and tools',
    },
    {
      'name': 'The Hacker Playbook 3',
      'url': 'https://github.com/topics/penetration-testing',
      'description': 'Practical guide to penetration testing methodologies',
    },
    {
      'name': 'Wireshark Network Analysis',
      'url': 'https://www.wireshark.org/docs/',
      'description': 'Network protocol analyzer documentation and tutorials',
    },
    {
      'name': 'Social Engineering: The Art of Human Hacking',
      'url': 'https://www.social-engineer.org/',
      'description': 'Understanding and defending against social engineering attacks',
    },
    {
      'name': 'Cyber Security Drive',
      'url': 'https://drive.google.com/drive/folders/1hTsA8zswSV-IzzYcXULy7t2COuPuyRQ7?usp=drive_link',
      'description': 'Collection of cyber security resources and books',
    },
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Cyber Vault',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey.shade900,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final resource = resources[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.security,
                    color: Colors.amber,
                    size: 28,
                  ),
                ),
                title: Text(
                  resource['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    resource['description']!,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.open_in_new,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                onTap: () => LauncherService.openLink(resource['url']!),
              ),
            );
          },
        ),
      ),
    );
  }
}
