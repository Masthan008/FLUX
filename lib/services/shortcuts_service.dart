import 'package:flutter/material.dart';

/// ShortcutsService provides quick tips, formulas, and shortcuts
/// for all subjects in the academic syllabus.
/// 
/// This service can be used independently from the syllabus screen
/// to display shortcuts in widgets, tooltips, or a dedicated shortcuts screen.
class ShortcutsService {
  // Singleton pattern
  static final ShortcutsService _instance = ShortcutsService._internal();
  factory ShortcutsService() => _instance;
  ShortcutsService._internal();

  /// Get all shortcuts for a specific subject
  static List<Map<String, dynamic>> getShortcutsForSubject(String subjectCode) {
    return _allShortcuts[subjectCode] ?? [];
  }

  /// Get shortcuts for a specific topic within a subject
  static List<Map<String, dynamic>> getShortcutsForTopic(String subjectCode, String topicName) {
    final subjectShortcuts = _allShortcuts[subjectCode] ?? [];
    return subjectShortcuts.where((s) => s['topic'] == topicName).toList();
  }

  /// Get all shortcuts across all subjects
  static List<Map<String, dynamic>> getAllShortcuts() {
    List<Map<String, dynamic>> all = [];
    for (var subject in _allShortcuts.values) {
      all.addAll(subject);
    }
    return all;
  }

  /// Get shortcuts by category (formulas, tips, patterns, etc.)
  static List<Map<String, dynamic>> getShortcutsByType(String type) {
    List<Map<String, dynamic>> result = [];
    for (var subject in _allShortcuts.values) {
      result.addAll(subject.where((s) => s['type'] == type));
    }
    return result;
  }

  /// Search shortcuts by keyword
  static List<Map<String, dynamic>> searchShortcuts(String query) {
    query = query.toLowerCase();
    List<Map<String, dynamic>> result = [];
    for (var subject in _allShortcuts.values) {
      result.addAll(subject.where((s) {
        final title = (s['title'] ?? '').toLowerCase();
        final content = (s['content'] ?? '').toLowerCase();
        return title.contains(query) || content.contains(query);
      }));
    }
    return result;
  }

  /// Master shortcuts data organized by subject
  static final Map<String, List<Map<String, dynamic>>> _allShortcuts = {
    // Introduction to Programming (C Language)
    'IP': [
      // Control Structures
      {'topic': 'Decision Making', 'type': 'tip', 'title': '🎯 Quick Tip', 'content': 'No semicolon after if condition!'},
      {'topic': 'Decision Making', 'type': 'pattern', 'title': '📝 Pattern', 'content': 'if(x>y) max=x; else max=y;'},
      {'topic': 'Decision Making', 'type': 'shortcut', 'title': '⚡ Shortcut', 'content': 'Ternary: result = (a>b) ? a : b;'},
      
      // Switch Case
      {'topic': 'Switch-Case', 'type': 'warning', 'title': '⚠️ Important', 'content': 'ALWAYS use break; after each case!'},
      {'topic': 'Switch-Case', 'type': 'pattern', 'title': '📝 Pattern', 'content': "case 'A': or case 1: (char/int only)"},
      {'topic': 'Switch-Case', 'type': 'trick', 'title': '💡 Trick', 'content': 'Multiple cases: case 1: case 2: code;'},
      
      // Loops
      {'topic': 'Loops', 'type': 'formula', 'title': '🔢 Iterations', 'content': 'for(i=1;i<=n;i++) → n times'},
      {'topic': 'Loops', 'type': 'formula', 'title': '📐 Sum Formula', 'content': '1+2+...+n = n(n+1)/2', 'isFormula': true},
      {'topic': 'Loops', 'type': 'pattern', 'title': '⚡ Infinite Loop', 'content': 'while(1) or for(;;)'},
      {'topic': 'Loops', 'type': 'tip', 'title': '🎯 Key Diff', 'content': 'do-while: minimum 1 execution'},
      
      // Break & Continue
      {'topic': 'Break & Continue', 'type': 'tip', 'title': '🛑 break', 'content': 'Exits the ENTIRE loop immediately'},
      {'topic': 'Break & Continue', 'type': 'tip', 'title': '⏭️ continue', 'content': 'Skips CURRENT iteration, goes to next'},
      {'topic': 'Break & Continue', 'type': 'warning', 'title': '🔄 Nested break', 'content': 'Only exits innermost loop'},
      
      // Arrays
      {'topic': 'Arrays', 'type': 'tip', 'title': '📍 Index', 'content': 'First: arr[0], Last: arr[n-1]'},
      {'topic': 'Arrays', 'type': 'pattern', 'title': '📐 Sum', 'content': 'Loop: sum += arr[i];'},
      {'topic': 'Arrays', 'type': 'pattern', 'title': '🔍 Search', 'content': 'if(arr[i]==key) found=1;'},
      {'topic': 'Arrays', 'type': 'formula', 'title': '📊 Average', 'content': 'avg = (float)sum / n;'},
      
      // 2D Arrays
      {'topic': '2D Arrays', 'type': 'formula', 'title': '📐 Diagonal', 'content': 'Main: i==j, Anti: i+j==n-1'},
      {'topic': '2D Arrays', 'type': 'pattern', 'title': '🔄 Transpose', 'content': 'Swap matrix[i][j] ↔ matrix[j][i]'},
      {'topic': '2D Arrays', 'type': 'formula', 'title': '➕ Addition', 'content': 'C[i][j] = A[i][j] + B[i][j]'},
      {'topic': '2D Arrays', 'type': 'formula', 'title': '✖️ Multiply', 'content': 'C[i][j] = Σ A[i][k] * B[k][j]'},
      
      // Nested Loops
      {'topic': 'Nested Loops', 'type': 'formula', 'title': '🔢 Iterations', 'content': 'Total = outer × inner loops'},
      {'topic': 'Nested Loops', 'type': 'pattern', 'title': '📐 Pattern: ▷', 'content': 'for(i=1;i<=n;i++) for(j=1;j<=i;j++)'},
      {'topic': 'Nested Loops', 'type': 'formula', 'title': '📊 Complexity', 'content': 'Usually O(n²) time complexity'},
      
      // Pointers
      {'topic': 'Pointers', 'type': 'tip', 'title': '⚡ Operators', 'content': '& → address, * → value'},
      {'topic': 'Pointers', 'type': 'formula', 'title': '📊 Arithmetic', 'content': 'ptr++ moves by sizeof(datatype)'},
      {'topic': 'Pointers', 'type': 'pattern', 'title': '🔗 Array', 'content': 'arr[i] ≡ *(arr+i)'},
      
      // Structures
      {'topic': 'Structures', 'type': 'formula', 'title': '📝 Struct Size', 'content': 'sizeof(struct) = sum + padding'},
      {'topic': 'Structures', 'type': 'formula', 'title': '📝 Union Size', 'content': 'sizeof(union) = largest member'},
      {'topic': 'Structures', 'type': 'tip', 'title': '⚡ Access', 'content': 'Dot (.) for variable, Arrow (->) for pointer'},
      {'topic': 'Structures', 'type': 'pattern', 'title': '💡 typedef', 'content': 'Creates alias, skip struct keyword'},
      
      // Strings
      {'topic': 'Strings', 'type': 'warning', 'title': '⚠️ Null', 'content': "String ends with '\\0' (null character)"},
      {'topic': 'Strings', 'type': 'pattern', 'title': '📝 Length', 'content': 'strlen(str) (excludes \\0)'},
      {'topic': 'Strings', 'type': 'pattern', 'title': '📝 Copy', 'content': 'strcpy(dest, src)'},
      {'topic': 'Strings', 'type': 'pattern', 'title': '📝 Compare', 'content': 'strcmp(s1, s2) → 0 if equal'},
    ],
    
    // Linear Algebra & Analytical Calculus
    'LAAC': [
      // Matrices
      {'topic': 'Matrices', 'type': 'formula', 'title': '📐 Symmetric', 'content': 'A = Aᵀ', 'isFormula': true},
      {'topic': 'Matrices', 'type': 'formula', 'title': '📐 Skew-Symmetric', 'content': 'A = -Aᵀ', 'isFormula': true},
      {'topic': 'Matrices', 'type': 'formula', 'title': '📐 Orthogonal', 'content': 'AAᵀ = I', 'isFormula': true},
      {'topic': 'Matrices', 'type': 'tip', 'title': '💡 Decomposition', 'content': 'Any matrix = Sym + Skew'},
      {'topic': 'Matrices', 'type': 'formula', 'title': '✖️ Transpose Rule', 'content': '(AB)ᵀ = BᵀAᵀ', 'isFormula': true},
      {'topic': 'Matrices', 'type': 'formula', 'title': '✖️ Inverse Rule', 'content': '(AB)⁻¹ = B⁻¹A⁻¹', 'isFormula': true},
      
      // Determinants
      {'topic': 'Determinants', 'type': 'formula', 'title': '📐 2×2 Det', 'content': '|A| = ad - bc', 'isFormula': true},
      {'topic': 'Determinants', 'type': 'tip', 'title': '💡 Property', 'content': 'Row swap → sign changes'},
      {'topic': 'Determinants', 'type': 'formula', 'title': '📐 Product', 'content': '|AB| = |A| × |B|', 'isFormula': true},
      
      // Eigenvalues
      {'topic': 'Eigenvalues', 'type': 'formula', 'title': '📐 Equation', 'content': '|A - λI| = 0', 'isFormula': true},
      {'topic': 'Eigenvalues', 'type': 'formula', 'title': '📊 Sum', 'content': 'Σλ = trace(A)', 'isFormula': true},
      {'topic': 'Eigenvalues', 'type': 'formula', 'title': '📊 Product', 'content': 'Πλ = det(A)', 'isFormula': true},
      
      // Calculus
      {'topic': 'Differentiation', 'type': 'formula', 'title': '📐 Power Rule', 'content': 'd/dx(xⁿ) = nxⁿ⁻¹', 'isFormula': true},
      {'topic': 'Differentiation', 'type': 'formula', 'title': '📐 Chain Rule', 'content': 'd/dx[f(g(x))] = f\'(g(x))·g\'(x)', 'isFormula': true},
      {'topic': 'Differentiation', 'type': 'formula', 'title': '📐 Product Rule', 'content': "(uv)' = u'v + uv'", 'isFormula': true},
      
      // Integration
      {'topic': 'Integration', 'type': 'formula', 'title': '📐 Power Rule', 'content': '∫xⁿdx = xⁿ⁺¹/(n+1) + C', 'isFormula': true},
      {'topic': 'Integration', 'type': 'formula', 'title': '📐 By Parts', 'content': '∫udv = uv - ∫vdu', 'isFormula': true},
    ],
    
    // Engineering Chemistry
    'EC': [
      // Water Treatment
      {'topic': 'Water Hardness', 'type': 'formula', 'title': '📐 Temp Hardness', 'content': 'Ca(HCO₃)₂ + Mg(HCO₃)₂', 'isFormula': true},
      {'topic': 'Water Hardness', 'type': 'formula', 'title': '📐 Perm Hardness', 'content': 'CaSO₄ + MgCl₂', 'isFormula': true},
      {'topic': 'Water Hardness', 'type': 'tip', 'title': '💡 Removal', 'content': 'Boiling removes temporary hardness'},
      
      // Electrochemistry
      {'topic': 'Electrochemistry', 'type': 'formula', 'title': '📐 Nernst', 'content': 'E = E° - (RT/nF)ln(Q)', 'isFormula': true},
      {'topic': 'Electrochemistry', 'type': 'formula', 'title': '📐 Faraday', 'content': 'W = ZIt = (M×I×t)/(n×F)', 'isFormula': true},
      
      // Polymers
      {'topic': 'Polymers', 'type': 'tip', 'title': '🔗 Addition', 'content': 'Monomers add without byproduct'},
      {'topic': 'Polymers', 'type': 'tip', 'title': '🔗 Condensation', 'content': 'Releases H₂O or small molecules'},
    ],
    
    // Engineering Physics
    'EP': [
      // Optics
      {'topic': 'Optics', 'type': 'formula', 'title': '📐 Snell\'s Law', 'content': 'n₁sinθ₁ = n₂sinθ₂', 'isFormula': true},
      {'topic': 'Optics', 'type': 'formula', 'title': '📐 Lens', 'content': '1/f = 1/v - 1/u', 'isFormula': true},
      
      // Quantum
      {'topic': 'Quantum Mechanics', 'type': 'formula', 'title': '📐 de Broglie', 'content': 'λ = h/mv', 'isFormula': true},
      {'topic': 'Quantum Mechanics', 'type': 'formula', 'title': '📐 Heisenberg', 'content': 'Δx·Δp ≥ ℏ/2', 'isFormula': true},
      
      // Semiconductor
      {'topic': 'Semiconductors', 'type': 'tip', 'title': '💡 n-type', 'content': 'Pentavalent dopants (P, As, Sb)'},
      {'topic': 'Semiconductors', 'type': 'tip', 'title': '💡 p-type', 'content': 'Trivalent dopants (B, Al, Ga)'},
    ],
  };

  /// Get icon for shortcut type
  static IconData getIconForType(String type) {
    switch (type) {
      case 'formula':
        return Icons.functions;
      case 'tip':
        return Icons.lightbulb_outline;
      case 'pattern':
        return Icons.pattern;
      case 'warning':
        return Icons.warning_amber;
      case 'trick':
        return Icons.auto_fix_high;
      case 'shortcut':
        return Icons.flash_on;
      default:
        return Icons.info_outline;
    }
  }

  /// Get color for shortcut type
  static Color getColorForType(String type) {
    switch (type) {
      case 'formula':
        return Colors.blue;
      case 'tip':
        return Colors.amber;
      case 'pattern':
        return Colors.purple;
      case 'warning':
        return Colors.orange;
      case 'trick':
        return Colors.green;
      case 'shortcut':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }
}
