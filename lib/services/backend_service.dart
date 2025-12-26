import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

/// Service for interacting with the FluxFlow Python Backend
/// GitHub: https://github.com/Masthan008/fluxflow-os
/// Deployed on Render.com (free tier)
class BackendService {
  // TODO: Replace with your Render.com URL after deployment
  // Example: https://fluxflow-os.onrender.com
  static const String baseUrl = 'https://fluxflow-os.onrender.com';
  
  // Timeout for wake-up (Render sleeps after 15min, takes ~30s to wake)
  static const Duration wakeUpTimeout = Duration(seconds: 45);
  // Timeout for code execution
  static const Duration executionTimeout = Duration(seconds: 30);
  
  /// Check if backend is healthy and awake
  static Future<BackendHealthStatus> checkHealth() async {
    try {
      final startTime = DateTime.now();
      
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(wakeUpTimeout);
      
      final latency = DateTime.now().difference(startTime).inMilliseconds;
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BackendHealthStatus(
          isHealthy: true,
          version: data['version'] ?? 'unknown',
          latencyMs: latency,
          wasSleeping: latency > 5000, // If took >5s, it was sleeping
        );
      } else {
        return BackendHealthStatus(
          isHealthy: false,
          error: 'Status code: ${response.statusCode}',
        );
      }
    } on TimeoutException {
      return BackendHealthStatus(
        isHealthy: false,
        error: 'Backend unreachable (timeout)',
      );
    } catch (e) {
      return BackendHealthStatus(
        isHealthy: false,
        error: e.toString(),
      );
    }
  }
  
  /// Wake up the backend (call before code execution)
  static Future<bool> wakeUp() async {
    final health = await checkHealth();
    return health.isHealthy;
  }
  
  /// Get list of supported programming languages
  static Future<List<SupportedLanguage>> getLanguages() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/languages'),
      ).timeout(wakeUpTimeout);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final languages = data['languages'] as List;
        return languages.map((l) => SupportedLanguage.fromJson(l)).toList();
      }
    } catch (e) {
      print('Error fetching languages: $e');
    }
    
    // Fallback to known languages
    return [
      SupportedLanguage(id: 'python', name: 'Python 3.11', extension: '.py'),
      SupportedLanguage(id: 'c', name: 'C (GCC)', extension: '.c'),
      SupportedLanguage(id: 'cpp', name: 'C++ (G++)', extension: '.cpp'),
    ];
  }
  
  /// Execute code on the backend
  /// 
  /// [code] - The source code to execute
  /// [language] - Language ID: 'python', 'c', 'cpp'
  /// [input] - Optional stdin input for the program
  /// 
  /// Returns [CodeExecutionResult] with output, error, and success status
  static Future<CodeExecutionResult> runCode({
    required String code,
    required String language,
    String input = '',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/run-code'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'script': code,
          'language': language,
          'stdin': input,
        }),
      ).timeout(executionTimeout);
      
      final data = jsonDecode(response.body);
      
      return CodeExecutionResult(
        success: data['success'] ?? false,
        output: data['output'] ?? '',
        error: data['error'] ?? '',
        exitCode: data['exit_code'] ?? -1,
        language: data['language'] ?? language,
        phase: data['phase'],
      );
      
    } on TimeoutException {
      return CodeExecutionResult(
        success: false,
        output: '',
        error: 'Execution timeout. The backend may be sleeping. Please try again.',
        exitCode: -1,
        language: language,
      );
    } catch (e) {
      return CodeExecutionResult(
        success: false,
        output: '',
        error: 'Connection error: $e',
        exitCode: -1,
        language: language,
      );
    }
  }
  
  /// Run Python code (convenience method)
  static Future<CodeExecutionResult> runPython(String code, {String input = ''}) {
    return runCode(code: code, language: 'python', input: input);
  }
  
  /// Run C code (convenience method)
  static Future<CodeExecutionResult> runC(String code, {String input = ''}) {
    return runCode(code: code, language: 'c', input: input);
  }
  
  /// Run C++ code (convenience method)
  static Future<CodeExecutionResult> runCpp(String code, {String input = ''}) {
    return runCode(code: code, language: 'cpp', input: input);
  }
}

/// Health status of the backend
class BackendHealthStatus {
  final bool isHealthy;
  final String? version;
  final int? latencyMs;
  final bool wasSleeping;
  final String? error;
  
  BackendHealthStatus({
    required this.isHealthy,
    this.version,
    this.latencyMs,
    this.wasSleeping = false,
    this.error,
  });
  
  @override
  String toString() {
    if (isHealthy) {
      return 'Healthy (v$version, ${latencyMs}ms${wasSleeping ? ", was sleeping" : ""})';
    } else {
      return 'Unhealthy: $error';
    }
  }
}

/// Supported programming language
class SupportedLanguage {
  final String id;
  final String name;
  final String extension;
  
  SupportedLanguage({
    required this.id,
    required this.name,
    required this.extension,
  });
  
  factory SupportedLanguage.fromJson(Map<String, dynamic> json) {
    return SupportedLanguage(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      extension: json['extension'] ?? '',
    );
  }
}

/// Result of code execution
class CodeExecutionResult {
  final bool success;
  final String output;
  final String error;
  final int exitCode;
  final String language;
  final String? phase; // 'compilation' or 'execution' for C/C++
  
  CodeExecutionResult({
    required this.success,
    required this.output,
    required this.error,
    required this.exitCode,
    required this.language,
    this.phase,
  });
  
  /// Check if this was a compilation error
  bool get isCompilationError => phase == 'compilation' && !success;
  
  /// Check if this was a runtime error
  bool get isRuntimeError => phase == 'execution' && !success;
  
  /// Get combined output (stdout + stderr)
  String get combinedOutput {
    if (error.isEmpty) return output;
    if (output.isEmpty) return error;
    return '$output\n\n--- Errors ---\n$error';
  }
  
  @override
  String toString() {
    return 'CodeExecutionResult(success: $success, exitCode: $exitCode, output: ${output.length} chars)';
  }
}
