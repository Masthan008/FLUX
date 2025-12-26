import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:clipboard/clipboard.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pattern_data.dart';
import '../../services/launcher_service.dart';

class CPatternsScreen extends StatelessWidget {
  const CPatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: const Text(
            'C-Pattern Master',
            style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.cyanAccent),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.cyanAccent,
            labelColor: Colors.cyanAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Cloud'),
              Tab(text: 'Star'),
              Tab(text: 'Number'),
              Tab(text: 'Alphabet'),
              Tab(text: 'Pyramid'),
              Tab(text: 'Hollow'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const _CloudPatternList(),
            _PatternList(patterns: PatternRepository.starPatterns),
            _PatternList(patterns: PatternRepository.numberPatterns),
            _PatternList(patterns: PatternRepository.alphabetPatterns),
            _PatternList(patterns: PatternRepository.pyramidPatterns),
            _PatternList(patterns: PatternRepository.hollowPatterns),
          ],
        ),
      ),
    );
  }
}

// Cloud-based Pattern List from Supabase
class _CloudPatternList extends StatelessWidget {
  const _CloudPatternList();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: Supabase.instance.client
          .from('code_snippets')
          .stream(primaryKey: ['id'])
          .order('created_at', ascending: true), // Order by timestamp for reliable updates
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'Error loading cloud programs',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyanAccent),
          );
        }

        final programs = snapshot.data!;

        if (programs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.code_off, color: Colors.grey, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'No programs available',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add programs from Supabase Dashboard',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: programs.length,
          itemBuilder: (context, index) {
            final program = programs[index];
            final title = program['title'] ?? 'Untitled';
            final category = program['category'] ?? '';

            return Card(
              color: Colors.grey.shade900,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: category.isNotEmpty
                    ? Text(
                        category,
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      )
                    : null,
                trailing: const Icon(Icons.cloud, color: Colors.cyanAccent, size: 20),
                onTap: () => _showCloudProgramDetails(context, program),
              ),
            );
          },
        );
      },
    );
  }

  void _showCloudProgramDetails(BuildContext context, Map<String, dynamic> program) {
    final title = program['title'] ?? 'Untitled';
    final code = program['code'] ?? '// No code available';
    final output = program['output'] ?? 'No output available';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud, color: Colors.cyanAccent, size: 20),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Console Output:',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          output,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'Courier',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Source Code:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.cyanAccent),
                        onPressed: () {
                          FlutterClipboard.copy(code).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Code copied!')),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  HighlightView(
                    code,
                    language: 'c',
                    theme: monokaiTheme,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => LauncherService.openLink('https://www.programiz.com/c-programming/online-compiler/'),
                      icon: const Icon(Icons.play_arrow, color: Colors.black),
                      label: const Text('Run Online', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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
}

class _PatternList extends StatelessWidget {
  final List<PatternData> patterns;

  const _PatternList({required this.patterns});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patterns.length,
      itemBuilder: (context, index) {
        final pattern = patterns[index];
        return Card(
          color: Colors.grey.shade900,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: ListTile(
            title: Text(
              pattern.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.cyanAccent, size: 16),
            onTap: () => _showPatternDetails(context, pattern),
          ),
        );
      },
    );
  }

  void _showPatternDetails(BuildContext context, PatternData pattern) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                pattern.name,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Console Output
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Console Output:',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pattern.output,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'Courier',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Source Code:',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.cyanAccent),
                        onPressed: () {
                          FlutterClipboard.copy(pattern.code).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Code copied!')),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  HighlightView(
                    pattern.code,
                    language: 'c',
                    theme: monokaiTheme,
                    padding: const EdgeInsets.all(12),
                    textStyle: const TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => LauncherService.openLink('https://www.programiz.com/c-programming/online-compiler/'),
                      icon: const Icon(Icons.play_arrow, color: Colors.black),
                      label: const Text('Run Online', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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
}
