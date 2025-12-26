import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Added Hive import
import '../../services/backend_service.dart';
import '../../services/student_auth_service.dart'; // ✅ ADD THIS LINE


/// Practice Code Compiler Screen - Write and run code in-app
class JDoodleCompilerScreen extends StatefulWidget {
  final String? challengeId;       // ID of the challenge (if this IS a challenge)
  final String? expectedOutput;    // The answer we want (e.g., "Hello World")
  final int pointsReward;          // How many points they win

  const JDoodleCompilerScreen({
    super.key, 
    this.challengeId, 
    this.expectedOutput, 
    this.pointsReward = 0
  });

  @override
  State<JDoodleCompilerScreen> createState() => _JDoodleCompilerScreenState();
}

class _JDoodleCompilerScreenState extends State<JDoodleCompilerScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _codeFocusNode = FocusNode();
  
  String _output = '';
  String _selectedLanguage = 'c';
  bool _isRunning = false;
  bool _showInput = false;
  bool _showOutput = true;

  // Languages: Core → Web/Mobile/Systems
  final List<Map<String, dynamic>> _languagesList = [
    // === CORE LANGUAGES ===
    {
      'id': 'c',
      'name': 'C',
      'icon': Icons.memory,
      'color': Colors.blue,
      'extension': 'c',
      'template': '''#include <stdio.h>

int main() {
    printf("Hello, FluxFlow!\\n");
    
    int num = 42;
    printf("Number: %d\\n", num);
    
    return 0;
}
''',
    },
    {
      'id': 'cpp',
      'name': 'C++',
      'icon': Icons.developer_mode,
      'color': Colors.purple,
      'extension': 'cpp',
      'template': '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello, FluxFlow!" << endl;
    
    int num = 42;
    cout << "Number: " << num << endl;
    
    return 0;
}
''',
    },
    {
      'id': 'java',
      'name': 'Java',
      'icon': Icons.coffee,
      'color': Colors.orange,
      'extension': 'java',
      'template': '''public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, FluxFlow!");
        
        int num = 42;
        System.out.println("Number: " + num);
    }
}
''',
    },
    {
      'id': 'python',
      'name': 'Python',
      'icon': Icons.code,
      'color': Colors.yellow,
      'extension': 'py',
      'template': '''# Python Program
print("Hello, FluxFlow!")

name = "Student"
print(f"Welcome, {name}!")
''',
    },
    // === WEB & MOBILE ===
    {
      'id': 'js',
      'name': 'JavaScript',
      'icon': Icons.javascript,
      'color': Colors.amber,
      'extension': 'js',
      'template': '''// JavaScript (Node.js)
console.log("Hello, FluxFlow!");

const name = "Student";
console.log(\`Welcome, \${name}!\`);

// Arrays
const nums = [1, 2, 3, 4, 5];
console.log("Sum:", nums.reduce((a, b) => a + b));
''',
    },
    {
      'id': 'csharp',
      'name': 'C#',
      'icon': Icons.gamepad,
      'color': Colors.green,
      'extension': 'cs',
      'template': '''using System;

class Program {
    static void Main() {
        Console.WriteLine("Hello, FluxFlow!");
        
        int num = 42;
        Console.WriteLine("Number: " + num);
    }
}
''',
    },
    {
      'id': 'go',
      'name': 'Go',
      'icon': Icons.speed,
      'color': Colors.cyan,
      'extension': 'go',
      'template': '''package main

import "fmt"

func main() {
    fmt.Println("Hello, FluxFlow!")
    
    num := 42
    fmt.Println("Number:", num)
}
''',
    },
    {
      'id': 'kotlin',
      'name': 'Kotlin',
      'icon': Icons.android,
      'color': Colors.deepPurple,
      'extension': 'kt',
      'template': '''fun main() {
    println("Hello, FluxFlow!")
    
    val num = 42
    println("Number: \$num")
    
    // Kotlin is great for Android!
}
''',
    },
    {
      'id': 'swift',
      'name': 'Swift',
      'icon': Icons.apple,
      'color': Colors.orangeAccent,
      'extension': 'swift',
      'template': '''import Foundation

print("Hello, FluxFlow!")

let num = 42
print("Number: \\(num)")

// Swift is for iOS/macOS apps!
''',
    },
  ];

  Map<String, dynamic> get _currentLang => 
      _languagesList.firstWhere((l) => l['id'] == _selectedLanguage);

  @override
  void initState() {
    super.initState();
    _codeController.text = _currentLang['template'];
    _wakeUpBackend();
    
    // Listen for focus to handle keyboard properly
    _codeFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_codeFocusNode.hasFocus) {
      // Collapse output when editing code
      setState(() => _showOutput = false);
    }
  }

  Future<void> _wakeUpBackend() async {
    await BackendService.wakeUp();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _runCode() async {
    if (_isRunning) return;
    
    // Hide keyboard and show output
    FocusScope.of(context).unfocus();
    setState(() {
      _isRunning = true;
      _output = '⏳ Running code...';
      _showOutput = true;
    });

    HapticFeedback.mediumImpact();

    try {
      final result = await BackendService.runCode(
        code: _codeController.text,
        language: _selectedLanguage,
        input: _inputController.text,
      );

      setState(() {
        if (result.success) {
          _output = result.output.isEmpty ? '✅ (No output)' : result.output;
          
          // 2. CHECK: Is this a Challenge?
          if (widget.challengeId != null && widget.expectedOutput != null) {
            
            // Compare Output (Trim removes accidental spaces, normalize newlines)
            String normalizedActual = result.output.trim().replaceAll('\r\n', '\n');
            String normalizedExpected = widget.expectedOutput!.trim().replaceAll('\r\n', '\n');
            
            if (normalizedActual == normalizedExpected) {
              // SUCCESS! They passed the test.
              _handleChallengeSuccess();
            } else {
              // ❌ CASE 2: FAILURE
              showDialog(
                context: context, 
                builder: (_) => AlertDialog(
                  backgroundColor: Colors.grey.shade900,
                  title: const Row(children: [
                    Icon(Icons.error_outline, color: Colors.red),
                    SizedBox(width: 10),
                    Text("Incorrect Output", style: TextStyle(color: Colors.white))
                  ]),
                  content: Text(
                    "Expected: ${widget.expectedOutput}\n\n"
                    "Your Output: $normalizedActual\n\n"
                    "Try checking for extra spaces or typos!",
                    style: const TextStyle(color: Colors.white70)
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Try Again", style: TextStyle(color: Colors.redAccent)),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                )
              );
            }
          }
        } else {
          _output = '❌ Error:\n${result.error}';
        }
      });
    } catch (e) {
      setState(() {
        _output = '❌ Connection error: $e';
      });
    } finally {
      setState(() => _isRunning = false);
    }
  }

  void _selectLanguage(String lang) {
    final langData = _languagesList.firstWhere((l) => l['id'] == lang);
    setState(() {
      _selectedLanguage = lang;
      _codeController.text = langData['template'];
      _output = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      resizeToAvoidBottomInset: true, // Handle keyboard properly
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Language selector (fixed at top)
            _buildLanguageSelector(),
            
            // Main content area (scrollable when keyboard opens)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: bottomPadding > 0 ? 80 : 0),
                child: Column(
                  children: [
                    // Code Editor
                    _buildCodeEditor(),
                    
                    // Input Section (collapsible)
                    if (_showInput) _buildInputSection(),
                    
                    // Output Section (collapsible)
                    if (_showOutput) _buildOutputSection(),
                  ],
                ),
              ),
            ),
            
            // Run button (fixed at bottom)
            _buildRunButton(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _currentLang['color'] as Color,
                  (_currentLang['color'] as Color).withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _currentLang['icon'] as IconData,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Practice Code',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        // Toggle Input
        IconButton(
          icon: Icon(
            Icons.input,
            color: _showInput ? Colors.cyan : Colors.grey,
            size: 22,
          ),
          onPressed: () => setState(() => _showInput = !_showInput),
          tooltip: 'Toggle Input',
        ),
        // Toggle Output
        IconButton(
          icon: Icon(
            Icons.terminal,
            color: _showOutput ? Colors.green : Colors.grey,
            size: 22,
          ),
          onPressed: () => setState(() => _showOutput = !_showOutput),
          tooltip: 'Toggle Output',
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _languagesList.length,
        itemBuilder: (context, index) {
          final lang = _languagesList[index];
          final isSelected = _selectedLanguage == lang['id'];
          
          return GestureDetector(
            onTap: () => _selectLanguage(lang['id']),
            child: Container(
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(colors: [
                        lang['color'] as Color,
                        (lang['color'] as Color).withOpacity(0.5),
                      ])
                    : null,
                color: isSelected ? null : Colors.grey.shade900,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? lang['color'] as Color : Colors.grey.shade700,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    lang['icon'] as IconData,
                    color: isSelected ? Colors.white : Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    lang['name'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ).animate(delay: Duration(milliseconds: 40 * index)).fadeIn().slideX(begin: 0.1);
        },
      ),
    );
  }

  Widget _buildCodeEditor() {
    return Container(
      height: 280, // Fixed height to prevent overflow
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        children: [
          // Editor header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                // Window buttons
                Row(
                  children: [
                    _buildDot(Colors.red),
                    const SizedBox(width: 6),
                    _buildDot(Colors.yellow),
                    const SizedBox(width: 6),
                    _buildDot(Colors.green),
                  ],
                ),
                const SizedBox(width: 12),
                Text(
                  'main.${_currentLang['extension']}',
                  style: GoogleFonts.firaCode(color: Colors.grey, fontSize: 11),
                ),
                const Spacer(),
                // Copy button
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _codeController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied!'), duration: Duration(seconds: 1)),
                    );
                  },
                  child: const Icon(Icons.copy, color: Colors.grey, size: 16),
                ),
                const SizedBox(width: 8),
                // Clear button
                GestureDetector(
                  onTap: () => _codeController.clear(),
                  child: const Icon(Icons.clear, color: Colors.grey, size: 16),
                ),
              ],
            ),
          ),
          // Code input
          Expanded(
            child: TextField(
              controller: _codeController,
              focusNode: _codeFocusNode,
              style: GoogleFonts.firaCode(
                color: Colors.white,
                fontSize: 13,
                height: 1.4,
              ),
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
                hintText: 'Write your code here...',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10, height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildInputSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.input, color: Colors.cyan, size: 14),
              const SizedBox(width: 6),
              Text('Input (stdin)', style: GoogleFonts.firaCode(color: Colors.cyan, fontSize: 11)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _showInput = false),
                child: const Icon(Icons.close, color: Colors.grey, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _inputController,
            style: GoogleFonts.firaCode(color: Colors.white, fontSize: 12),
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Enter input values (one per line)...',
              hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 11),
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.black,
              contentPadding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildOutputSection() {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _output.contains('❌') 
              ? Colors.red.withOpacity(0.4) 
              : Colors.green.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _output.contains('❌') 
                  ? Colors.red.withOpacity(0.1) 
                  : Colors.green.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.terminal, 
                  color: _output.contains('❌') ? Colors.red : Colors.green, 
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Output',
                  style: GoogleFonts.firaCode(
                    color: _output.contains('❌') ? Colors.red : Colors.green, 
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                if (_output.isNotEmpty && !_output.contains('⏳'))
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _output));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Output copied!'), duration: Duration(seconds: 1)),
                      );
                    },
                    child: const Icon(Icons.copy, color: Colors.grey, size: 14),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: SelectableText(
                _output.isEmpty ? 'Press ▶ Run to execute code' : _output,
                style: GoogleFonts.firaCode(
                  color: _output.contains('❌') 
                      ? Colors.red.shade300 
                      : _output.contains('⏳')
                          ? Colors.orange.shade300
                          : Colors.green.shade300,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: ElevatedButton(
        onPressed: _isRunning ? null : _runCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade700,
          disabledBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isRunning)
              const SizedBox(
                width: 18, height: 18,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            else
              const Icon(Icons.play_arrow, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              _isRunning ? 'Running...' : 'Run Code',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _handleChallengeSuccess() async {
    // ✅ USE StudentAuthService instead of Supabase Auth
    final student = StudentAuthService.currentStudent;

    // 1. Check if logged in via YOUR service
    if (student == null || student.id == null) {
      _showDialog("Not Logged In", "You must be logged in to save progress.");
      return;
    }
    
    // 2. Use student.id instead of user.id
    final userId = student.id!;

    try {
      // 1. Check if they already did this challenge
      final check = await Supabase.instance.client
          .from('user_completed_tasks')
          .select()
          .eq('user_id', userId)
          .eq('task_id', widget.challengeId!) // task_id can store challenge_id
          .maybeSingle();

      if (check != null) {
        _showDialog("Good Job!", "You already solved this, so no new points.");
        return;
      }

      // 2. Record it as "Done"
      await Supabase.instance.client.from('user_completed_tasks').insert({
        'user_id': userId,
        'task_id': widget.challengeId,
      });

      // 3. Add Points (This updates the Leaderboard automatically!)
      await Supabase.instance.client.rpc('increment_points', params: { 
        'userid': userId, 
        'points': widget.pointsReward 
      });

      _showDialog("Correct! 🎉", "You earned ${widget.pointsReward} points!");

    } catch (e) {
      print("Error saving score: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving score: $e")),
      );
    }
  }

  void _showDialog(String title, String body) {
    showDialog(context: context, builder: (_) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(title, style: const TextStyle(color: Colors.white)), 
        content: Text(body, style: const TextStyle(color: Colors.white70)),
        actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text("OK", style: TextStyle(color: Colors.cyanAccent))
            )
        ]
    ));
  }
}
