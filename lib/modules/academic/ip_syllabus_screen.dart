import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IPSyllabusScreen extends StatelessWidget {
  const IPSyllabusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'IP Syllabus',
          style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B0082), Color(0xFF191970)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.code, size: 50, color: Colors.cyanAccent),
                  const SizedBox(height: 10),
                  Text(
                    'Introduction to Programming',
                    style: GoogleFonts.orbitron(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Complete C Programming Syllabus',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Unit 1
            _buildUnitCard(
              unitNumber: 'Unit 1',
              unitTitle: 'Introduction to Problem Solving',
              topics: [
                'Computer History & Evolution',
                'Problem Solving Techniques',
                'Algorithms & Flowcharts',
                'Pseudocode',
                'Introduction to Programming Languages',
                'Compilers vs Interpreters',
              ],
              icon: Icons.lightbulb_outline,
              color: Colors.blue,
            ),

            // Unit 2
            _buildUnitCard(
              unitNumber: 'Unit 2',
              unitTitle: 'Basics of C Programming',
              topics: [
                'Structure of C Program',
                'Keywords & Identifiers',
                'Data Types (int, float, char, double)',
                'Variables & Constants',
                'Operators (Arithmetic, Relational, Logical)',
                'Expressions & Type Conversion',
                'Input/Output Functions (printf, scanf)',
              ],
              icon: Icons.code_outlined,
              color: Colors.green,
            ),

            // Unit 3
            _buildUnitCard(
              unitNumber: 'Unit 3',
              unitTitle: 'Control Structures & Arrays',
              topics: [
                'Decision Making (if, if-else, nested if)',
                'Switch-Case Statements',
                'Loops (for, while, do-while)',
                'Break & Continue Statements',
                'One-Dimensional Arrays',
                'Two-Dimensional Arrays',
                'Array Operations',
              ],
              icon: Icons.account_tree,
              color: Colors.orange,
            ),

            // Unit 4
            _buildUnitCard(
              unitNumber: 'Unit 4',
              unitTitle: 'Pointers & Strings',
              topics: [
                'Introduction to Pointers',
                'Pointer Declaration & Initialization',
                'Pointer Arithmetic',
                'Pointers & Arrays',
                'String Basics',
                'String Functions (strlen, strcpy, strcat, strcmp)',
                'Array of Strings',
              ],
              icon: Icons.link,
              color: Colors.purple,
            ),

            // Unit 5
            _buildUnitCard(
              unitNumber: 'Unit 5',
              unitTitle: 'Functions, Structures & File Handling',
              topics: [
                'Function Definition & Declaration',
                'Function Call & Return',
                'Recursion',
                'Structures & Unions',
                'Array of Structures',
                'File Operations (fopen, fclose, fread, fwrite)',
                'File Handling Functions',
              ],
              icon: Icons.functions,
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.info_outline, color: Colors.cyanAccent, size: 30),
                  const SizedBox(height: 10),
                  Text(
                    'Practice regularly in the C-Coding Lab',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Access from Home → C-Coding Lab',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitCard({
    required String unitNumber,
    required String unitTitle,
    required List<String> topics,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: color, size: 30),
          title: Text(
            unitNumber,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            unitTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          iconColor: color,
          collapsedIconColor: Colors.grey,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: topics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: color,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            topic,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
