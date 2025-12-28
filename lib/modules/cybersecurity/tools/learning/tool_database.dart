class CyberTool {
  final String name;
  final String category;
  final String description;
  final String usage;
  final List<String> commands;
  final String howItWorks;
  final List<String> defenses;
  final String icon;
  final String color;

  CyberTool({
    required this.name,
    required this.category,
    required this.description,
    required this.usage,
    required this.commands,
    required this.howItWorks,
    required this.defenses,
    required this.icon,
    required this.color,
  });
}

final List<CyberTool> cyberTools = [
  CyberTool(
    name: 'Nmap',
    category: 'Reconnaissance',
    description: 'Network Mapper - The industry standard for network discovery and security auditing.',
    usage: 'Scan networks to discover hosts, services, operating systems, and vulnerabilities.',
    commands: [
      'nmap 192.168.1.1',
      'nmap -sV 192.168.1.0/24',
      'nmap -O 192.168.1.1',
      'nmap -A -T4 scanme.nmap.org',
    ],
    howItWorks: 'Nmap sends specially crafted packets to target hosts and analyzes responses to determine what ports are open, what services are running, and what operating system is in use.',
    defenses: [
      'Use firewalls to block unnecessary ports',
      'Implement IDS/IPS to detect scanning',
      'Regular security audits',
      'Network segmentation',
    ],
    icon: 'radar',
    color: 'green',
  ),
  CyberTool(
    name: 'Metasploit',
    category: 'Exploitation',
    description: 'The world\'s most used penetration testing framework.',
    usage: 'Exploit known vulnerabilities in systems and applications.',
    commands: [
      'msfconsole',
      'search ms17-010',
      'use exploit/windows/smb/ms17_010_eternalblue',
      'set RHOSTS 192.168.1.100',
      'exploit',
    ],
    howItWorks: 'Metasploit contains a database of known exploits. It automates the process of exploiting vulnerabilities by providing pre-built modules that can be configured and executed against target systems.',
    defenses: [
      'Keep systems patched and updated',
      'Use antivirus and EDR solutions',
      'Implement least privilege access',
      'Regular vulnerability assessments',
    ],
    icon: 'bug_report',
    color: 'red',
  ),
  CyberTool(
    name: 'Hydra',
    category: 'Password Attacks',
    description: 'Fast and flexible password cracking tool supporting numerous protocols.',
    usage: 'Brute force attack against authentication services.',
    commands: [
      'hydra -l admin -P passwords.txt ftp://192.168.1.1',
      'hydra -L users.txt -P passwords.txt ssh://192.168.1.1',
      'hydra -l root -P rockyou.txt 192.168.1.1 ssh',
    ],
    howItWorks: 'Hydra systematically tries username/password combinations from wordlists against authentication services until it finds valid credentials or exhausts all possibilities.',
    defenses: [
      'Use strong, complex passwords (12+ characters)',
      'Implement account lockout policies',
      'Use fail2ban to block brute force attempts',
      'Enable multi-factor authentication (MFA)',
    ],
    icon: 'lock_open',
    color: 'orange',
  ),
  CyberTool(
    name: 'Wireshark',
    category: 'Network Analysis',
    description: 'The world\'s foremost network protocol analyzer.',
    usage: 'Capture and analyze network traffic in real-time.',
    commands: [
      'wireshark',
      'tshark -i eth0',
      'tshark -r capture.pcap',
      'tshark -i eth0 -f "port 80"',
    ],
    howItWorks: 'Wireshark captures all packets on a network interface and decodes them to show detailed information about protocols, headers, and payload data.',
    defenses: [
      'Use encryption (HTTPS, SSH, VPN)',
      'Implement network segmentation',
      'Monitor for suspicious packet captures',
      'Use switched networks instead of hubs',
    ],
    icon: 'analytics',
    color: 'blue',
  ),
  CyberTool(
    name: 'Burp Suite',
    category: 'Web Application',
    description: 'Integrated platform for web application security testing.',
    usage: 'Test web applications for vulnerabilities like SQL injection, XSS, CSRF.',
    commands: [
      'burpsuite',
      'Configure browser proxy to 127.0.0.1:8080',
      'Intercept and modify HTTP requests',
      'Use Scanner to find vulnerabilities',
    ],
    howItWorks: 'Burp Suite acts as a proxy between your browser and the web server, allowing you to intercept, inspect, and modify HTTP/HTTPS traffic to test for security flaws.',
    defenses: [
      'Input validation and sanitization',
      'Use prepared statements for SQL',
      'Implement Content Security Policy (CSP)',
      'Regular security testing and code reviews',
    ],
    icon: 'web',
    color: 'purple',
  ),
  CyberTool(
    name: 'Aircrack-ng',
    category: 'Wireless',
    description: 'Complete suite of tools to assess WiFi network security.',
    usage: 'Crack WEP and WPA/WPA2-PSK keys.',
    commands: [
      'airmon-ng start wlan0',
      'airodump-ng wlan0mon',
      'airodump-ng -c 6 --bssid XX:XX:XX:XX:XX:XX -w capture wlan0mon',
      'aircrack-ng -w wordlist.txt capture.cap',
    ],
    howItWorks: 'Aircrack-ng captures wireless packets, specifically the 4-way handshake, then uses dictionary attacks or brute force to crack the encryption key.',
    defenses: [
      'Use WPA3 encryption',
      'Strong, random WiFi passwords (20+ characters)',
      'Disable WPS',
      'Hide SSID broadcast (security through obscurity)',
    ],
    icon: 'wifi',
    color: 'cyan',
  ),
  CyberTool(
    name: 'SQLMap',
    category: 'Web Application',
    description: 'Automatic SQL injection and database takeover tool.',
    usage: 'Detect and exploit SQL injection vulnerabilities.',
    commands: [
      'sqlmap -u "http://example.com/page?id=1"',
      'sqlmap -u "http://example.com/page?id=1" --dbs',
      'sqlmap -u "http://example.com/page?id=1" -D database --tables',
      'sqlmap -u "http://example.com/page?id=1" -D database -T users --dump',
    ],
    howItWorks: 'SQLMap automatically tests parameters for SQL injection vulnerabilities by sending crafted payloads and analyzing responses to extract database information.',
    defenses: [
      'Use parameterized queries/prepared statements',
      'Input validation and sanitization',
      'Least privilege database accounts',
      'Web Application Firewall (WAF)',
    ],
    icon: 'storage',
    color: 'pink',
  ),
  CyberTool(
    name: 'John the Ripper',
    category: 'Password Attacks',
    description: 'Fast password cracker for offline hash cracking.',
    usage: 'Crack password hashes from system files.',
    commands: [
      'john --wordlist=rockyou.txt hashes.txt',
      'john --format=NT hashes.txt',
      'john --show hashes.txt',
      'john --incremental hashes.txt',
    ],
    howItWorks: 'John the Ripper takes password hashes and tries to crack them by hashing dictionary words or generating combinations until it finds a match.',
    defenses: [
      'Use strong hashing algorithms (bcrypt, Argon2)',
      'Implement password complexity requirements',
      'Use salted hashes',
      'Regular password rotation policies',
    ],
    icon: 'vpn_key',
    color: 'yellow',
  ),
];
