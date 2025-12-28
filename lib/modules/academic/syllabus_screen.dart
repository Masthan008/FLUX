import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_math_fork/flutter_math.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> with TickerProviderStateMixin {
  String _selectedSubject = 'IP';
  late AnimationController _headerController;
  late AnimationController _pulseController;
  late Animation<double> _headerAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _headerController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _headerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Enhanced Master Syllabus Data with Rich Content
  static final Map<String, Map<String, dynamic>> syllabusData = {
    'IP': {
      'fullName': 'Introduction to Programming',
      'icon': Icons.code,
      'color': Colors.purple,
      'description': 'Master the fundamentals of programming with C language - Your gateway to the coding world!',
      'examTips': 'Focus on practical coding, understand logic building, and practice flowcharts extensively.',
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Introduction to Problem Solving',
          'importance': 'Foundation unit - 15-20% weightage in exams',
          'studyTips': 'Draw flowcharts for every problem, understand the evolution timeline',
          'topics': [
            {
              'name': 'Computer History & Evolution',
              'content': 'From ENIAC (1946) to modern computers. Key generations: Vacuum tubes → Transistors → ICs → Microprocessors → AI Era.',
              'examPoint': '⭐ Remember: 1st Gen (1940-56), 2nd Gen (1956-63), 3rd Gen (1964-71), 4th Gen (1971-present)',
              'application': 'Understanding computer evolution helps in appreciating modern programming capabilities.'
            },
            {
              'name': 'Problem Solving Techniques',
              'content': 'Systematic approach: Understand → Plan → Code → Test → Debug. Use divide-and-conquer strategy.',
              'examPoint': '⭐ Steps: Problem Analysis → Algorithm Design → Coding → Testing → Documentation',
              'application': 'Essential for any programming task - from simple calculations to complex software development.'
            },
            {
              'name': 'Algorithms & Flowcharts',
              'content': 'Algorithm: Step-by-step solution. Flowchart: Visual representation using symbols (Oval-Start/End, Rectangle-Process, Diamond-Decision).',
              'examPoint': '⭐ Must know symbols: Oval, Rectangle, Diamond, Parallelogram, Circle. Practice drawing for sorting, searching.',
              'application': 'Used in software design, system analysis, and process documentation in IT industry.'
            },
            {
              'name': 'Pseudocode',
              'content': 'English-like representation of algorithm. No syntax rules, focus on logic. Use BEGIN/END, IF/THEN/ELSE, WHILE/DO.',
              'examPoint': '⭐ Write pseudocode for: Linear search, Binary search, Bubble sort, Finding max/min in array.',
              'application': 'Industry standard for algorithm documentation before actual coding.'
            },
            {
              'name': 'Introduction to Programming Languages',
              'content': 'Types: Low-level (Assembly) vs High-level (C, Java). Paradigms: Procedural, Object-oriented, Functional.',
              'examPoint': '⭐ Classification: Machine → Assembly → High-level. Examples of each category.',
              'application': 'Choosing right language for specific projects - C for system programming, Python for AI, Java for enterprise.'
            },
            {
              'name': 'Compilers vs Interpreters',
              'content': 'Compiler: Translates entire program at once (C, C++). Interpreter: Line-by-line execution (Python, JavaScript).',
              'examPoint': '⭐ Differences: Speed, Error detection, Memory usage, Examples of each type.',
              'application': 'Understanding helps in choosing development environment and debugging strategies.'
            },
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Basics of C Programming',
          'importance': 'Core unit - 25-30% weightage in exams',
          'studyTips': 'Practice syntax extensively, memorize format specifiers, understand memory allocation',
          'topics': [
            {
              'name': 'Structure of C Program',
              'content': 'Basic structure: Preprocessor → Global declarations → main() function → User-defined functions.',
              'examPoint': '⭐ Must include: #include<stdio.h>, int main(), return 0; Remember semicolon after each statement.',
              'application': 'Every C program follows this structure - from simple "Hello World" to complex operating systems.'
            },
            {
              'name': 'Keywords & Identifiers',
              'content': '32 keywords in C (auto, break, case, char, const, continue, default, do, double, else, enum, extern, float, for, goto, if, int, long, register, return, short, signed, sizeof, static, struct, switch, typedef, union, unsigned, void, volatile, while). Identifiers: User-defined names.',
              'examPoint': '⭐ Keywords cannot be used as variable names. Identifier rules: Start with letter/underscore, case-sensitive.',
              'application': 'Foundation for writing any C program - proper naming conventions improve code readability.'
            },
            {
              'name': 'Data Types (int, float, char, double)',
              'content': 'int: 2/4 bytes, range -32768 to 32767. float: 4 bytes, 6 decimal precision. char: 1 byte, ASCII values. double: 8 bytes, 15 decimal precision.',
              'examPoint': '⭐ Size varies by system. Format specifiers: %d(int), %f(float), %c(char), %lf(double), %s(string).',
              'application': 'Choosing correct data type optimizes memory usage - crucial in embedded systems and mobile apps.'
            },
            {
              'name': 'Variables & Constants',
              'content': 'Variables: Storage locations with names. Constants: Fixed values (#define PI 3.14 or const int x=10).',
              'examPoint': '⭐ Declaration vs Definition. Scope: Local vs Global. Storage classes: auto, static, extern, register.',
              'application': 'Proper variable management prevents memory leaks and improves program efficiency.'
            },
            {
              'name': 'Operators (Arithmetic, Relational, Logical)',
              'content': 'Arithmetic: +, -, *, /, % (modulus). Relational: <, >, <=, >=, ==, !=. Logical: && (AND), || (OR), ! (NOT).',
              'examPoint': '⭐ Precedence order: (), *, /, %, +, -, <, >, ==, !=, &&, ||. Associativity: Left to right mostly.',
              'application': 'Building blocks for all calculations and decision-making in programs.'
            },
            {
              'name': 'Expressions & Type Conversion',
              'content': 'Expression: Combination of operands and operators. Type conversion: Implicit (automatic) vs Explicit (casting).',
              'examPoint': '⭐ Implicit: int + float = float. Explicit: (int)3.14 = 3. Understand promotion rules.',
              'application': 'Critical for accurate calculations in scientific computing and financial applications.'
            },
            {
              'name': 'Input/Output Functions (printf, scanf)',
              'content': 'printf(): Output function with format specifiers. scanf(): Input function, requires & for variables (except strings).',
              'examPoint': '⭐ Common formats: %d, %f, %c, %s. scanf pitfalls: buffer issues, space handling. Use fflush(stdin).',
              'application': 'User interaction foundation - from simple calculators to complex user interfaces.'
            },
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Control Structures & Arrays',
          'importance': 'High weightage - 30-35% in exams',
          'studyTips': 'Practice nested loops, array problems, and trace execution step by step',
          'topics': [
            {
              'name': 'Decision Making (if, if-else, nested if)',
              'content': 'if: Single condition. if-else: Two-way branching. nested if: Multiple conditions. Syntax: if(condition) { statements; }',
              'examPoint': '⭐ Practice: Grade calculation, largest of 3 numbers, leap year check. Remember braces for multiple statements.',
              'application': 'Core logic for any decision-based software - from ATM systems to game development.',
              'flowcharts': [
                {'name': 'if Statement', 'path': 'assets/images/flowcharts/if_statement.png'},
                {'name': 'if-else', 'path': 'assets/images/flowcharts/if_else.png'},
                {'name': 'Nested if', 'path': 'assets/images/flowcharts/nested_if.png'},
              ],
              'syntax': '''// Simple if
if (condition) {
    // code block
}

// if-else
if (condition) {
    // if block
} else {
    // else block
}

// Nested if
if (outer_condition) {
    if (inner_condition) {
        // inner if block
    }
}''',
              'shortcuts': [
                {'title': '🎯 Quick Tip', 'content': 'No semicolon after if condition!'},
                {'title': '📝 Pattern', 'content': 'if(x>y) max=x; else max=y;'},
                {'title': '⚡ Shortcut', 'content': 'Ternary: result = (a>b) ? a : b;'},
              ],
            },
            {
              'name': 'Switch-Case Statements',
              'content': 'Multi-way branching based on integer/character values. Must use break to prevent fall-through. Default case optional.',
              'examPoint': '⭐ Common programs: Calculator, menu-driven programs, day of week. Remember break statements.',
              'application': 'Menu systems, command processing, and state machines in embedded systems.',
              'flowcharts': [
                {'name': 'Switch-Case', 'path': 'assets/images/flowcharts/switch_case.png'},
              ],
              'syntax': '''switch (expression) {
    case value1:
        // code for case 1
        break;
    case value2:
        // code for case 2
        break;
    default:
        // default code
}''',
              'shortcuts': [
                {'title': '⚠️ Important', 'content': 'ALWAYS use break; after each case!'},
                {'title': '📝 Pattern', 'content': 'case \'A\': or case 1: (char/int only)'},
                {'title': '💡 Trick', 'content': 'Multiple cases: case 1: case 2: code;'},
              ],
            },
            {
              'name': 'Loops (for, while, do-while)',
              'content': 'for: Known iterations. while: Entry-controlled. do-while: Exit-controlled (executes at least once).',
              'examPoint': '⭐ Practice: Number patterns, factorial, Fibonacci, prime numbers, sum of digits. Understand loop control.',
              'application': 'Repetitive tasks automation - from data processing to game loops.',
              'flowcharts': [
                {'name': 'for Loop', 'path': 'assets/images/flowcharts/for_loop.png'},
                {'name': 'while Loop', 'path': 'assets/images/flowcharts/while_loop.png'},
                {'name': 'do-while', 'path': 'assets/images/flowcharts/do_while.png'},
              ],
              'syntax': '''// for loop
for (init; condition; increment) {
    // loop body
}

// while loop (entry-controlled)
while (condition) {
    // loop body
}

// do-while (exit-controlled)
do {
    // executes at least once
} while (condition);''',
              'shortcuts': [
                {'title': '🔢 Iterations', 'content': 'for(i=1;i<=n;i++) → n times'},
                {'title': '📐 Formula', 'content': '1+2+...+n = n(n+1)/2', 'isFormula': true},
                {'title': '⚡ Pattern', 'content': 'Infinite: while(1) or for(;;)'},
                {'title': '🎯 Key Diff', 'content': 'do-while: min 1 execution'},
              ],
            },
            {
              'name': 'Break & Continue Statements',
              'content': 'break: Exits loop/switch immediately. continue: Skips current iteration, goes to next iteration. Both are jump statements that alter normal control flow.',
              'examPoint': '⭐ Use cases: Searching in arrays, input validation, menu exit options. break exits entirely, continue skips current iteration only.',
              'application': 'Optimizing program flow and handling special cases in real-world applications.',
              'flowcharts': [
                {'name': 'Break Statement', 'path': 'assets/images/flowcharts/break_statement_flowchart_1766076046401.png'},
                {'name': 'Continue Statement', 'path': 'assets/images/flowcharts/continue_statement_flowchart_1766076081469.png'},
              ],
              'syntax': '''// break - exits the entire loop immediately
for (i=0; i<10; i++) {
    if (arr[i] == key) {
        printf("Found at index %d", i);
        break;  // EXIT loop completely
    }
}
// Execution continues here after break

// continue - skips current iteration only
for (i=1; i<=10; i++) {
    if (i % 2 == 0) {
        continue;  // Skip even numbers
    }
    printf("%d ", i);  // Prints: 1 3 5 7 9
}

// break in nested loops - exits INNER loop only
for (i=0; i<3; i++) {
    for (j=0; j<3; j++) {
        if (j == 1) break;  // exits inner loop
        printf("(%d,%d) ", i, j);
    }
}''',
              'shortcuts': [
                {'title': '🛑 break', 'content': 'Exits the ENTIRE loop immediately'},
                {'title': '⏭️ continue', 'content': 'Skips CURRENT iteration, goes to next'},
                {'title': '🔄 Nested break', 'content': 'Only exits innermost loop'},
                {'title': '💡 Use Case', 'content': 'break: search found, continue: filter data'},
                {'title': '⚠️ Warning', 'content': 'break in switch: prevents fall-through'},
              ],
            },
            {
              'name': 'Ternary Operator (Conditional Expression)',
              'content': 'The ternary operator (?:) is a shorthand for if-else. Syntax: condition ? value_if_true : value_if_false. Returns one of two values based on condition.',
              'examPoint': '⭐ Compact alternative to if-else for simple assignments. Can be nested but reduces readability. Result must be used (assignment/print).',
              'application': 'Quick conditional assignments, inline decisions, and compact code in competitive programming.',
              'syntax': '''// Basic ternary operator
int max = (a > b) ? a : b;

// Equivalent if-else
int max;
if (a > b)
    max = a;
else
    max = b;

// Ternary in printf
printf("%s", (age >= 18) ? "Adult" : "Minor");

// Nested ternary (find largest of 3)
int largest = (a > b) ? ((a > c) ? a : c) 
                      : ((b > c) ? b : c);

// Ternary for absolute value
int abs_val = (x < 0) ? -x : x;

// Multiple conditions
char grade = (marks >= 90) ? 'A' :
             (marks >= 80) ? 'B' :
             (marks >= 70) ? 'C' : 'F';''',
              'shortcuts': [
                {'title': '📝 Syntax', 'content': 'cond ? true_val : false_val'},
                {'title': '⚡ Quick Max', 'content': 'max = (a>b) ? a : b;'},
                {'title': '⚡ Quick Min', 'content': 'min = (a<b) ? a : b;'},
                {'title': '🔢 Absolute', 'content': 'abs = (x<0) ? -x : x;'},
                {'title': '⚠️ Note', 'content': 'Cannot use statements, only expressions'},
              ],
            },
            {
              'name': 'Else-If Ladder',
              'content': 'Multiple conditions checked sequentially. First true condition executes, rest are skipped. Useful for mutually exclusive conditions like grading, range checking.',
              'examPoint': '⭐ Conditions checked top-to-bottom. Only ONE block executes. Order matters for efficiency. Final else is optional but recommended.',
              'application': 'Grade calculation, tax slabs, menu options, range-based categorization.',
              'flowcharts': [
                {'name': 'if Statement', 'path': 'assets/images/flowcharts/if_statement_flowchart_1766075817746.png'},
                {'name': 'if-else', 'path': 'assets/images/flowcharts/if_else_flowchart_1766075837979.png'},
              ],
              'syntax': '''// Else-if ladder structure
if (condition1) {
    // executes if condition1 is true
}
else if (condition2) {
    // executes if condition1 false, condition2 true
}
else if (condition3) {
    // executes if above false, condition3 true
}
else {
    // executes if ALL conditions are false
}

// Example: Grade calculation
if (marks >= 90) {
    printf("Grade: A");
}
else if (marks >= 80) {
    printf("Grade: B");
}
else if (marks >= 70) {
    printf("Grade: C");
}
else if (marks >= 60) {
    printf("Grade: D");
}
else {
    printf("Grade: F");
}

// Example: Number sign check
if (num > 0) {
    printf("Positive");
}
else if (num < 0) {
    printf("Negative");
}
else {
    printf("Zero");
}''',
              'shortcuts': [
                {'title': '📋 Order', 'content': 'Check most specific conditions first'},
                {'title': '⚡ Efficiency', 'content': 'Put most likely condition first'},
                {'title': '🎯 Rule', 'content': 'Only ONE block executes'},
                {'title': '💡 Tip', 'content': 'Always include final else for safety'},
                {'title': '🔄 vs switch', 'content': 'Use when conditions are ranges, not exact values'},
              ],
            },
            {
              'name': 'Goto Statement',
              'content': 'Unconditional jump to a labeled statement. Syntax: goto label; ... label: statement; Transfers control directly to the label. Generally avoided in structured programming.',
              'examPoint': '⭐ Creates spaghetti code if misused. Valid uses: Breaking out of deeply nested loops, error handling. Prefer break/continue/return instead.',
              'application': 'Legacy code maintenance, breaking nested loops, low-level programming, error cleanup in C.',
              'flowcharts': [
                {'name': 'Goto Statement', 'path': 'assets/images/flowcharts/goto_statement_flowchart_1766076109094.png'},
              ],
              'syntax': '''// Basic goto syntax
goto label_name;
// ... some code ...
label_name:
    // code after label

// Example: Breaking nested loops
for (i=0; i<10; i++) {
    for (j=0; j<10; j++) {
        if (arr[i][j] == target) {
            printf("Found at [%d][%d]", i, j);
            goto found;  // exit both loops
        }
    }
}
printf("Not found");
goto end;

found:
    printf("Search successful!");

end:
    printf("Program ends");

// goto for error handling (C pattern)
int process_data() {
    if (!allocate_memory())
        goto error;
    if (!read_file())
        goto cleanup_memory;
    if (!process())
        goto cleanup_file;
    return SUCCESS;
    
cleanup_file:
    close_file();
cleanup_memory:
    free_memory();
error:
    return FAILURE;
}''',
              'shortcuts': [
                {'title': '⚠️ Warning', 'content': 'Avoid goto - makes code hard to follow'},
                {'title': '✓ Valid Use', 'content': 'Breaking out of nested loops'},
                {'title': '✓ Valid Use', 'content': 'Error cleanup in C (no exceptions)'},
                {'title': '🚫 Never', 'content': 'Jump INTO a loop or block'},
                {'title': '💡 Alternative', 'content': 'Use functions + return instead'},
              ],
            },
            {
              'name': 'Nested Loops',
              'content': 'Loop inside another loop. Inner loop completes all iterations for each outer loop iteration. Total iterations = outer × inner. Used for 2D patterns, matrices.',
              'examPoint': '⭐ Pattern printing, matrix operations, multiplication tables. Inner loop runs completely for each outer iteration. Time complexity usually O(n²).',
              'application': 'Matrix operations, pattern printing, image processing, game board rendering, bubble sort.',
              'flowcharts': [
                {'name': 'Nested Loops', 'path': 'assets/images/flowcharts/nested_loop_flowchart_1766076137254.png'},
              ],
              'syntax': '''// Basic nested for loops
for (i=1; i<=rows; i++) {      // outer loop
    for (j=1; j<=cols; j++) {  // inner loop
        printf("* ");
    }
    printf("\\n");
}

// Right triangle pattern (*)
for (i=1; i<=5; i++) {
    for (j=1; j<=i; j++) {
        printf("* ");
    }
    printf("\\n");
}
// Output:
// *
// * *
// * * *
// * * * *
// * * * * *

// Number pyramid
for (i=1; i<=5; i++) {
    for (j=1; j<=i; j++) {
        printf("%d ", j);
    }
    printf("\\n");
}

// Multiplication table
for (i=1; i<=10; i++) {
    for (j=1; j<=10; j++) {
        printf("%4d", i*j);
    }
    printf("\\n");
}

// Matrix traversal
for (i=0; i<rows; i++) {
    for (j=0; j<cols; j++) {
        printf("%d ", matrix[i][j]);
    }
    printf("\\n");
}''',
              'shortcuts': [
                {'title': '🔢 Iterations', 'content': 'Total = outer × inner loops'},
                {'title': '📐 Pattern: ▷', 'content': 'for(i=1;i<=n;i++) for(j=1;j<=i;j++)'},
                {'title': '📐 Pattern: ◁', 'content': 'for(i=n;i>=1;i--) for(j=1;j<=i;j++)'},
                {'title': '📊 Complexity', 'content': 'Usually O(n²) time complexity'},
                {'title': '🎯 Matrix', 'content': 'i=row index, j=column index'},
                {'title': '⚡ Tip', 'content': 'break exits inner loop only'},
              ],
            },
            {
              'name': 'Switch-Case Deep Dive',
              'content': '''Switch-case provides efficient multi-way branching based on the value of an expression. Key concepts:

• Expression must evaluate to int, char, or enum type
• Each case label must be a unique compile-time constant
• break statement prevents fall-through to next case
• default handles all unmatched values (optional but recommended)
• Fall-through: Without break, execution continues to next case

EXECUTION FLOW:
1. Expression is evaluated once
2. Value is compared with each case
3. Matching case block executes
4. break exits the switch
5. If no match, default executes (if present)''',
              'examPoint': '⭐ Switch only works with int/char/enum, NOT float/double/string. Always use break. Multiple cases can share code.',
              'application': 'Menu-driven programs, calculators, state machines, game states, command interpreters.',
              'limitations': '''⚠️ LIMITATIONS OF SWITCH-CASE:
• Cannot use float, double, or string expressions
• Case values MUST be compile-time constants
• Cannot use variable expressions in case
• No range checking (like case 1-10:)
• No boolean/relational expressions in case
• Each case value must be unique
• Large switches can be inefficient (use lookup tables)''',
              'flowcharts': [
                {'name': 'Switch-Case Flow', 'path': 'assets/images/flowcharts/switch_case_flowchart.png'},
              ],
              'syntax': '''// Basic Switch-Case Syntax
switch (expression) {
    case constant1:
        // statements for case 1
        break;
    case constant2:
        // statements for case 2
        break;
    default:
        // default statements
}

// Calculator Example
char op;
float a, b, result;
printf("Enter operator (+,-,*,/): ");
scanf(" %c", &op);
printf("Enter two numbers: ");
scanf("%f %f", &a, &b);

switch(op) {
    case '+':
        result = a + b;
        printf("Sum: %.2f", result);
        break;
    case '-':
        result = a - b;
        printf("Difference: %.2f", result);
        break;
    case '*':
        result = a * b;
        printf("Product: %.2f", result);
        break;
    case '/':
        if (b != 0) {
            result = a / b;
            printf("Quotient: %.2f", result);
        } else {
            printf("Error: Division by zero!");
        }
        break;
    default:
        printf("Invalid operator!");
}

// Multiple Cases Sharing Code
switch(grade) {
    case 'A':
    case 'a':
        printf("Excellent! (90-100)");
        break;
    case 'B':
    case 'b':
        printf("Good (80-89)");
        break;
    case 'F':
    case 'f':
        printf("Failed (<60)");
        break;
}

// Intentional Fall-through
switch(month) {
    case 1: case 3: case 5:
    case 7: case 8: case 10: case 12:
        days = 31;
        break;
    case 4: case 6: case 9: case 11:
        days = 30;
        break;
    case 2:
        days = (leap_year) ? 29 : 28;
        break;
}''',
              'shortcuts': [
                {'title': '⚠️ CRITICAL', 'content': 'ALWAYS use break; after each case!'},
                {'title': '🚫 Cannot Use', 'content': 'float, double, string, variables in case'},
                {'title': '💡 Fall-through', 'content': 'Omit break to share code between cases'},
                {'title': '📝 Syntax', 'content': "case 'A': or case 1: (char/int only)"},
                {'title': '🔄 vs if-else', 'content': 'Switch for exact values, if-else for ranges'},
                {'title': '⚡ Efficiency', 'content': 'Jump table for many cases (O(1))'},
              ],
            },
            {
              'name': 'Do-While Loop Mastery',
              'content': '''Do-while is an EXIT-CONTROLLED loop that guarantees at least one execution of the loop body. Key differences from while:

• Body executes FIRST, condition checked LAST
• Guaranteed minimum of ONE iteration
• Semicolon required after while(condition);
• Ideal for menu-driven programs and input validation

EXECUTION FLOW:
1. Execute loop body
2. Evaluate condition
3. If TRUE: go back to step 1
4. If FALSE: exit loop''',
              'examPoint': '⭐ Use when body must execute at least once (menus, input validation). Remember semicolon after while(condition);',
              'application': 'Menu-driven programs, input validation, game loops, password retry systems, ATM transactions.',
              'limitations': '''⚠️ LIMITATIONS OF DO-WHILE:
• Always executes at least once (can't skip entirely)
• Easy to forget semicolon after while()
• Can lead to infinite loops if condition never becomes false
• Less common than for/while (code readability)
• Cannot be easily converted to for loop
• Body runs before condition check (potential side effects)''',
              'flowcharts': [
                {'name': 'Do-While Flow', 'path': 'assets/images/flowcharts/do_while_flowchart.png'},
              ],
              'syntax': '''// Basic Do-While Syntax
do {
    // loop body (executes at least once)
} while (condition);  // NOTE: semicolon required!

// Menu-Driven Program
int choice;
do {
    printf("\\n=== MENU ===\\n");
    printf("1. Add\\n");
    printf("2. Subtract\\n");
    printf("3. Multiply\\n");
    printf("4. Exit\\n");
    printf("Enter choice: ");
    scanf("%d", &choice);
    
    switch(choice) {
        case 1: printf("Addition selected\\n"); break;
        case 2: printf("Subtraction selected\\n"); break;
        case 3: printf("Multiplication selected\\n"); break;
        case 4: printf("Goodbye!\\n"); break;
        default: printf("Invalid choice!\\n");
    }
} while (choice != 4);

// Input Validation
int num;
do {
    printf("Enter a positive number: ");
    scanf("%d", &num);
    if (num <= 0) {
        printf("Invalid! Try again.\\n");
    }
} while (num <= 0);
printf("You entered: %d\\n", num);

// Password Retry (max 3 attempts)
int password, attempts = 0;
int correct = 1234;
do {
    printf("Enter password: ");
    scanf("%d", &password);
    attempts++;
    if (password != correct) {
        printf("Wrong! %d attempts remaining\\n", 3-attempts);
    }
} while (password != correct && attempts < 3);

// Sum until 0 entered
int sum = 0, n;
do {
    printf("Enter number (0 to stop): ");
    scanf("%d", &n);
    sum += n;
} while (n != 0);
printf("Sum: %d\\n", sum);''',
              'shortcuts': [
                {'title': '⚠️ Important', 'content': 'Semicolon required after while(condition);'},
                {'title': '🎯 Key Feature', 'content': 'Executes AT LEAST ONCE'},
                {'title': '💡 Best For', 'content': 'Menu-driven programs, input validation'},
                {'title': '🔄 vs while', 'content': 'while: 0+ times, do-while: 1+ times'},
                {'title': '📝 Pattern', 'content': 'do { action; input; } while(!valid);'},
                {'title': '⚡ Use Case', 'content': 'When you need to attempt before checking'},
              ],
            },
            {
              'name': 'For Loop Variations',
              'content': '''The for loop is the most versatile loop in C, ideal for known iterations. Components:

for (initialization; condition; update) {
    // body
}

• Initialization: Executed once at start
• Condition: Checked before each iteration
• Update: Executed after each iteration
• All three parts are optional

VARIATIONS:
1. Standard counting loop
2. Decrementing loop (countdown)
3. Multiple variables
4. Infinite loop
5. Empty parts
6. Nested for loops''',
              'examPoint': '⭐ Most commonly used loop. Understand all parts. Can omit any part. Semicolons always required inside for().',
              'application': 'Array traversal, counting, iterations, pattern printing, mathematical series, file processing.',
              'limitations': '''⚠️ LIMITATIONS OF FOR LOOP:
• Must know/calculate iteration count (or use break)
• Modifying loop variable inside body is risky
• Complex conditions reduce readability
• Nested loops can be O(n²) or worse
• Cannot skip initialization in some cases
• Infinite loop if condition always true''',
              'flowcharts': [
                {'name': 'For Loop Flow', 'path': 'assets/images/flowcharts/for_loop.png'},
              ],
              'syntax': '''// Basic For Loop
for (int i = 0; i < n; i++) {
    printf("%d ", i);
}

// Countdown (Decrementing)
for (int i = 10; i >= 1; i--) {
    printf("%d ", i);
}
printf("Liftoff!");

// Step by 2 (Even numbers)
for (int i = 0; i <= 20; i += 2) {
    printf("%d ", i);
}

// Multiple Variables
for (int i=0, j=10; i<j; i++, j--) {
    printf("i=%d, j=%d\\n", i, j);
}

// Infinite Loop
for (;;) {
    printf("Press Ctrl+C to stop\\n");
    // break; to exit
}

// Omitting Parts
int i = 0;
for (; i < 5; ) {  // init outside, update inside
    printf("%d ", i);
    i++;
}

// Array Traversal
int arr[] = {10, 20, 30, 40, 50};
int size = sizeof(arr) / sizeof(arr[0]);
for (int i = 0; i < size; i++) {
    printf("%d ", arr[i]);
}

// Reverse Array Traversal
for (int i = size-1; i >= 0; i--) {
    printf("%d ", arr[i]);
}

// Character Loop
for (char c = 'A'; c <= 'Z'; c++) {
    printf("%c ", c);
}

// Factorial Calculation
int fact = 1;
for (int i = 1; i <= n; i++) {
    fact *= i;
}

// Sum of Series: 1 + 2 + ... + n
int sum = 0;
for (int i = 1; i <= n; i++) {
    sum += i;
}
// Or use formula: n*(n+1)/2

// Fibonacci Series
int a=0, b=1, next;
printf("%d %d ", a, b);
for (int i = 2; i < n; i++) {
    next = a + b;
    printf("%d ", next);
    a = b;
    b = next;
}''',
              'shortcuts': [
                {'title': '🔢 Iterations', 'content': 'for(i=0; i<n; i++) runs n times'},
                {'title': '⚡ Infinite', 'content': 'for(;;) or while(1)'},
                {'title': '📐 Formula', 'content': '1+2+...+n = n*(n+1)/2'},
                {'title': '🔄 Step', 'content': 'i+=2 for every 2nd, i*=2 for powers'},
                {'title': '📍 Array Size', 'content': 'sizeof(arr)/sizeof(arr[0])'},
                {'title': '💡 Break', 'content': 'Use break to exit early'},
              ],
            },
            {
              'name': 'One-Dimensional Arrays',
              'content': 'Collection of similar data types. Declaration: int arr[10]; Indexing starts from 0. Size must be constant.',
              'examPoint': '⭐ Programs: Linear search, finding max/min, sum/average, reversing array, sorting (bubble sort).',
              'application': 'Data storage and manipulation - from student records to image processing pixels.',
              'syntax': '''// Declaration
int arr[5];          // size 5
int nums[] = {1,2,3,4,5};  // initialized

// Access
arr[0] = 10;         // first element
arr[n-1]             // last element

// Traversal
for (i=0; i<n; i++) {
    printf("%d ", arr[i]);
}''',
              'shortcuts': [
                {'title': '📍 Index', 'content': 'First: arr[0], Last: arr[n-1]'},
                {'title': '📐 Sum', 'content': 'Loop: sum += arr[i];'},
                {'title': '🔍 Search', 'content': 'if(arr[i]==key) found=1;'},
                {'title': '📊 Average', 'content': 'avg = sum / n; (float cast!)'},
              ],
            },
            {
              'name': 'Two-Dimensional Arrays',
              'content': 'Array of arrays. Declaration: int matrix[3][4]; Row-major storage. Nested loops for processing.',
              'examPoint': '⭐ Matrix operations: Addition, multiplication, transpose, diagonal sum. Understand row-column concept.',
              'application': 'Image processing, game boards, mathematical computations, and data tables.',
              'syntax': '''// Declaration
int matrix[3][4];    // 3 rows, 4 cols
int m[2][3] = {{1,2,3}, {4,5,6}};

// Access: matrix[row][col]
matrix[0][0] = 1;    // first element
matrix[i][j]         // element at (i,j)

// Traversal (nested loops)
for (i=0; i<rows; i++) {
    for (j=0; j<cols; j++) {
        printf("%d ", matrix[i][j]);
    }
}''',
              'shortcuts': [
                {'title': '📐 Diagonal', 'content': 'Main: i==j, Anti: i+j==n-1'},
                {'title': '🔄 Transpose', 'content': 'Swap matrix[i][j] ↔ matrix[j][i]'},
                {'title': '➕ Addition', 'content': 'C[i][j] = A[i][j] + B[i][j]'},
                {'title': '✖️ Multiply', 'content': 'C[i][j] = Σ A[i][k] * B[k][j]'},
              ],
            },
            {
              'name': 'Array Operations',
              'content': 'Insertion, deletion, searching, sorting. Linear search: O(n), Binary search: O(log n) - requires sorted array.',
              'examPoint': '⭐ Algorithms: Bubble sort, selection sort, insertion sort. Understand time complexity basics.',
              'application': 'Database operations, search engines, and data analysis tools.',
              'syntax': '''// Linear Search - O(n)
for (i=0; i<n; i++) {
    if (arr[i] == key) return i;
}

// Bubble Sort - O(n²)
for (i=0; i<n-1; i++) {
    for (j=0; j<n-i-1; j++) {
        if (arr[j] > arr[j+1]) {
            // swap
            temp = arr[j];
            arr[j] = arr[j+1];
            arr[j+1] = temp;
        }
    }
}''',
              'shortcuts': [
                {'title': '📊 Complexity', 'content': 'Linear: O(n), Binary: O(log n)'},
                {'title': '🔀 Swap', 'content': 'temp=a; a=b; b=temp;'},
                {'title': '📈 Bubble', 'content': 'Compare adjacent, swap if larger'},
                {'title': '⚡ Binary', 'content': 'mid=(low+high)/2; halves array'},
              ],
            },
          ],
        },

        {
          'number': 'Unit 4',
          'title': 'Pointers & Strings',
          'importance': 'Critical unit - 25-30% weightage in exams',
          'studyTips': 'Practice pointer arithmetic, understand memory addresses, master string manipulation',
          'topics': [
            {
              'name': 'Introduction to Pointers',
              'content': 'Pointer: Variable that stores memory address of another variable. Declaration: int *ptr; Provides direct memory access.',
              'examPoint': '⭐ Pointer stores address, not value. Use & to get address, * to get value. NULL pointer = 0.',
              'application': 'Dynamic memory allocation, linked lists, system programming, and efficient data structures.'
            },
            {
              'name': 'Pointer Declaration & Initialization',
              'content': 'Declaration: datatype *ptr_name; Initialization: int *p = &var; or int *p; p = &var; Always initialize before use.',
              'examPoint': '⭐ Uninitialized pointers cause segmentation fault. Wild pointers are dangerous. Use NULL for safety.',
              'application': 'Safe memory management in operating systems, embedded systems, and high-performance applications.'
            },
            {
              'name': 'Pointer Arithmetic',
              'content': 'Operations: ptr++, ptr--, ptr+n, ptr-n. Increment moves by sizeof(datatype) bytes. Only addition/subtraction allowed.',
              'examPoint': '⭐ ptr++ moves by 4 bytes for int, 1 byte for char. ptr1-ptr2 gives number of elements between them.',
              'application': 'Array traversal, memory optimization, and implementing data structures like stacks and queues.'
            },
            {
              'name': 'Pointers & Arrays',
              'content': 'Array name is constant pointer to first element. arr[i] ≡ *(arr+i) ≡ *(i+arr) ≡ i[arr]. Pointer can traverse array.',
              'examPoint': '⭐ Array name cannot be changed. Pointer arithmetic works with arrays. Practice array access using pointers.',
              'application': 'Efficient array processing, image manipulation, and matrix operations in scientific computing.'
            },
            {
              'name': 'String Basics',
              'content': 'String: Array of characters ending with \\0 (null terminator). Declaration: char str[20] or char *str = "Hello";',
              'examPoint': '⭐ Always reserve space for \\0. String literal is stored in read-only memory. Length = characters + 1.',
              'application': 'Text processing, web development, database operations, and user interface programming.'
            },
            {
              'name': 'String Functions (strlen, strcpy, strcat, strcmp)',
              'content': 'strlen(): Returns length. strcpy(): Copies string. strcat(): Concatenates. strcmp(): Compares (returns 0 if equal).',
              'examPoint': '⭐ Include <string.h>. strcpy(dest, src), strcat(dest, src), strcmp(str1, str2). Check buffer overflow.',
              'application': 'Text editors, search engines, data validation, and natural language processing applications.'
            },
            {
              'name': 'Array of Strings',
              'content': 'Declaration: char names[5][20] or char *names[5]. First: fixed-size strings, Second: variable-size with pointers.',
              'examPoint': '⭐ 2D array vs array of pointers. Memory allocation differences. Access: names[i] or *(names+i).',
              'application': 'Menu systems, database records, command-line arguments, and configuration file processing.'
            },
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Functions, Structures & File Handling',
          'importance': 'Advanced concepts - 20-25% weightage',
          'studyTips': 'Practice recursion problems, understand structure syntax, master file operations',
          'topics': [
            {
              'name': 'Function Definition & Declaration',
              'content': 'Function: Reusable code block. Declaration: return_type function_name(parameters); Definition includes body.',
              'examPoint': '⭐ Prototype must match definition. Default return type is int. Use void for no return value.',
              'application': 'Modular programming, code reusability, library development, and software engineering practices.'
            },
            {
              'name': 'Function Call & Return',
              'content': 'Call by value: Copies value, original unchanged. Call by reference: Passes address, can modify original.',
              'examPoint': '⭐ Arrays always passed by reference. Use pointers for call by reference. Return statement exits function.',
              'application': 'Parameter passing in APIs, data processing functions, and mathematical computation libraries.'
            },
            {
              'name': 'Recursion',
              'content': 'Function calling itself. Must have base case to stop. Each call creates new stack frame. Memory overhead increases.',
              'examPoint': '⭐ Base case prevents infinite recursion. Stack overflow if too deep. Practice: factorial, Fibonacci, tower of Hanoi.',
              'application': 'Tree traversal, divide-and-conquer algorithms, mathematical computations, and parsing expressions.'
            },
            {
              'name': 'Structures & Unions',
              'content': 'Structure: Groups different data types under a single name. Union: Same memory for different data types, only one member active at a time. Access using dot (.) or arrow (->) operator.',
              'examPoint': '⭐ struct keyword required. Union saves memory but only one member active. typedef creates alias. Size of struct = sum of members (with padding). Size of union = largest member.',
              'application': 'Database records, complex data representation, system programming, and object-oriented design foundation.',
              'syntax': '''// Structure Declaration & Definition
struct student {
    int roll_no;
    char name[50];
    float marks;
};  // Don't forget semicolon!

// Structure Variable Declaration
struct student s1;            // Method 1
struct student s2 = {101, "John", 85.5};  // Method 2

// Accessing Members (dot operator)
s1.roll_no = 102;
strcpy(s1.name, "Alice");
s1.marks = 92.5;

// Structure with typedef
typedef struct {
    int x;
    int y;
} Point;
Point p1 = {10, 20};  // No need for 'struct' keyword

// Nested Structures
struct address {
    char city[30];
    int pin;
};
struct employee {
    char name[50];
    struct address addr;  // Nested
};
struct employee e1;
e1.addr.pin = 500001;  // Access nested member

// Structure Pointer
struct student *ptr = &s1;
printf("%d", ptr->roll_no);  // Arrow operator

// Array of Structures
struct student class[60];
class[0].roll_no = 1;

// Union Declaration
union data {
    int i;
    float f;
    char c;
};
union data d;
d.i = 10;   // Now i is active
d.f = 3.14; // Now f is active, i is overwritten''',
              'shortcuts': [
                {'title': '📝 Struct Size', 'content': 'sizeof(struct) = sum + padding'},
                {'title': '📝 Union Size', 'content': 'sizeof(union) = largest member'},
                {'title': '⚡ Access', 'content': 'Dot (.) for variable, Arrow (->) for pointer'},
                {'title': '💡 typedef', 'content': 'Creates alias, skip struct keyword'},
                {'title': '🔗 Nested', 'content': 'outer.inner.member access pattern'},
                {'title': '📊 Array', 'content': 'struct arr[n]; arr[i].member'},
              ],
            },
            {
              'name': 'Array of Structures',
              'content': 'Collection of structure variables. Declaration: struct student s[100]; Access: s[i].name, s[i].marks.',
              'examPoint': '⭐ Memory allocation: array_size × sizeof(structure). Initialize during declaration or using loops.',
              'application': 'Student management systems, employee databases, inventory management, and data analytics applications.'
            },
            {
              'name': 'File Operations (fopen, fclose, fread, fwrite)',
              'content': 'fopen(): Opens file with mode (r, w, a, rb, wb). fclose(): Closes file. fread()/fwrite(): Binary I/O.',
              'examPoint': '⭐ Always check if file opened successfully (NULL check). Close files to free resources. Binary vs text mode.',
              'application': 'Data persistence, log files, configuration storage, and database file management systems.'
            },
            {
              'name': 'File Handling Functions',
              'content': 'fprintf()/fscanf(): Formatted I/O. fgetc()/fputc(): Character I/O. fgets()/fputs(): String I/O. fseek(): File positioning.',
              'examPoint': '⭐ EOF indicates end of file. fseek(file, offset, whence): SEEK_SET, SEEK_CUR, SEEK_END. Error handling important.',
              'application': 'Text processing, data import/export, backup systems, and file-based database operations.'
            },
          ],
        },
      ],
    },
    'LAAC': {
      'fullName': 'Linear Algebra & Analytical Calculus',
      'icon': Icons.functions,
      'color': Colors.blue,
      'description': 'Mathematical foundation for engineering - Master matrices, calculus, and analytical thinking!',
      'examTips': 'Practice derivations, memorize formulas, solve previous year questions extensively.',
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Matrices',
          'importance': 'Foundation unit - 20-25% weightage',
          'studyTips': 'Practice matrix operations daily, understand determinant properties, memorize formulas',
          'topics': [
            {
              'name': 'Types of Matrices',
              'content': 'Row matrix (1×n), Column matrix (m×1), Square matrix (n×n), Diagonal, Scalar, Identity (I), Null/Zero, Symmetric (A=Aᵀ), Skew-symmetric (A=-Aᵀ), Orthogonal (AAᵀ=I).',
              'examPoint': '⭐ Properties: Symmetric + Skew-symmetric = Any matrix. Diagonal elements of skew-symmetric are zero.',
              'application': 'Computer graphics transformations, quantum mechanics, network analysis, and machine learning.',
              'shortcuts': [
                {'title': '📐 Symmetric', 'content': 'A = A^T', 'isFormula': true},
                {'title': '📐 Skew-Symmetric', 'content': 'A = -A^T', 'isFormula': true},
                {'title': '📐 Orthogonal', 'content': 'AA^T = I', 'isFormula': true},
                {'title': '💡 Decomposition', 'content': 'Any matrix = Sym + Skew'},
              ],
            },
            {
              'name': 'Matrix Operations',
              'content': 'Addition: Same order matrices. Multiplication: (m×n)(n×p)=(m×p). Properties: (AB)ᵀ=BᵀAᵀ, (AB)⁻¹=B⁻¹A⁻¹.',
              'examPoint': '⭐ AB ≠ BA (not commutative). A(BC)=(AB)C (associative). Practice 3×3 matrix multiplication.',
              'application': 'Image processing, 3D graphics, robotics, and solving simultaneous equations.',
              'shortcuts': [
                {'title': '📐 Transpose', 'content': '(AB)^T = B^T A^T', 'isFormula': true},
                {'title': '📐 Inverse', 'content': '(AB)^{-1} = B^{-1} A^{-1}', 'isFormula': true},
                {'title': '⚠️ Not Commutative', 'content': 'AB ≠ BA (usually)'},
                {'title': '✓ Associative', 'content': 'A(BC) = (AB)C'},
              ],
            },
            {
              'name': 'Determinants',
              'content': '2×2: ad-bc. 3×3: Sarrus rule or cofactor expansion. Properties: |AB|=|A||B|, |Aᵀ|=|A|, |kA|=kⁿ|A|.',
              'examPoint': '⭐ If |A|=0, matrix is singular (no inverse). Row/column operations affect determinant value.',
              'application': 'Solving linear systems, finding areas/volumes, and stability analysis in engineering.',
              'shortcuts': [
                {'title': '📐 2×2 Det', 'content': '\\begin{vmatrix} a & b \\\\ c & d \\end{vmatrix} = ad - bc', 'isFormula': true},
                {'title': '📐 Product', 'content': '|AB| = |A| \\cdot |B|', 'isFormula': true},
                {'title': '📐 Scalar', 'content': '|kA| = k^n |A|', 'isFormula': true},
                {'title': '⚠️ Singular', 'content': '|A| = 0 → No inverse'},
              ],
            },
            {
              'name': 'Inverse of a Matrix',
              'content': 'A⁻¹ = (1/|A|) × adj(A). Exists only if |A|≠0. Properties: (A⁻¹)⁻¹=A, (AB)⁻¹=B⁻¹A⁻¹, (Aᵀ)⁻¹=(A⁻¹)ᵀ.',
              'examPoint': '⭐ Adjoint = transpose of cofactor matrix. Practice 3×3 inverse calculation. AA⁻¹=I.',
              'application': 'Cryptography, solving equations, computer graphics, and control systems.',
              'shortcuts': [
                {'title': '📐 Inverse Formula', 'content': 'A^{-1} = \\frac{1}{|A|} \\cdot adj(A)', 'isFormula': true},
                {'title': '📐 Verification', 'content': 'A \\cdot A^{-1} = I', 'isFormula': true},
                {'title': '📐 Double Inverse', 'content': '(A^{-1})^{-1} = A', 'isFormula': true},
                {'title': '💡 2×2 Quick', 'content': 'Swap diagonal, negate off-diagonal, ÷|A|'},
              ],
            },
            {
              'name': 'Rank of a Matrix',
              'content': 'Number of non-zero rows in row echelon form. rank(A) ≤ min(m,n). Full rank if rank = min(m,n).',
              'examPoint': '⭐ Methods: Row reduction, determinant of submatrices. Rank determines solution existence.',
              'application': 'Data compression, image processing, and determining system solvability.',
              'shortcuts': [
                {'title': '📐 Upper Bound', 'content': 'rank(A) \\leq \\min(m, n)', 'isFormula': true},
                {'title': '📐 Full Rank', 'content': 'rank(A) = \\min(m, n)', 'isFormula': true},
                {'title': '💡 Method', 'content': 'Row reduce → Count non-zero rows'},
                {'title': '⚠️ Zero Rank', 'content': 'Only if A = 0 (null matrix)'},
              ],
            },
            {
              'name': 'System of Linear Equations',
              'content': 'AX=B. Solutions: Unique (|A|≠0), Infinite (rank(A)=rank(A|B)<n), No solution (rank(A)≠rank(A|B)).',
              'examPoint': '⭐ Cramer rule: xi=|Ai|/|A|. Matrix method: X=inv(A)B. Understand consistency conditions.',
              'application': 'Circuit analysis, economics, optimization problems, and engineering design.',
              'shortcuts': [
                {'title': '📐 Cramer', 'content': 'x_i = \\frac{|A_i|}{|A|}', 'isFormula': true},
                {'title': '📐 Matrix Method', 'content': 'X = A^{-1}B', 'isFormula': true},
                {'title': '✓ Consistent', 'content': 'rank(A) = rank(A|B)'},
                {'title': '⚠️ Unique', 'content': '|A| ≠ 0 for unique solution'},
              ],
            },
            {
              'name': 'Gauss Elimination Method',
              'content': 'Convert to upper triangular form using row operations. Back substitution for solutions. Partial pivoting for stability.',
              'examPoint': '⭐ Elementary row operations: Ri↔Rj, kRi, Ri+kRj. Practice 3×3 and 4×4 systems.',
              'application': 'Numerical methods, computer algorithms, and large-scale system solving.',
              'shortcuts': [
                {'title': '🔄 Row Swap', 'content': 'R_i \\leftrightarrow R_j', 'isFormula': true},
                {'title': '✖️ Scalar Mult', 'content': 'kR_i', 'isFormula': true},
                {'title': '➕ Row Add', 'content': 'R_i + kR_j \\rightarrow R_i', 'isFormula': true},
                {'title': '💡 Goal', 'content': 'Make upper triangular → back-substitute'},
              ],
            },
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Eigen Values & Eigen Vectors',
          'importance': 'Advanced concepts - 20-25% weightage',
          'studyTips': 'Practice characteristic equation solving, understand diagonalization process, memorize theorems',
          'topics': [
            {
              'name': 'Characteristic Equation',
              'content': 'det(A - λI) = 0. Polynomial equation in λ. Degree equals matrix order. Roots are eigenvalues.',
              'examPoint': '⭐ For 2×2: λ² - trace(A)λ + det(A) = 0. For 3×3: Expand determinant carefully. Check calculations.',
              'application': 'Stability analysis in control systems, vibration analysis, and principal component analysis in data science.'
            },
            {
              'name': 'Eigen Values & Eigen Vectors',
              'content': 'Av = λv, where v ≠ 0. λ: eigenvalue, v: eigenvector. (A - λI)v = 0 for eigenvectors.',
              'examPoint': '⭐ Eigenvectors are not unique (scalar multiples). Zero vector is not an eigenvector. Normalize if required.',
              'application': 'Google PageRank algorithm, facial recognition, quantum mechanics, and structural engineering analysis.'
            },
            {
              'name': 'Cayley-Hamilton Theorem',
              'content': 'Every square matrix satisfies its own characteristic equation. If p(λ) = det(A - λI), then p(A) = 0.',
              'examPoint': '⭐ Use to find A⁻¹, Aⁿ. For 2×2: A² - tr(A)A + det(A)I = 0. Verify by substitution.',
              'application': 'Computing matrix powers efficiently, solving matrix equations, and control system design.'
            },
            {
              'name': 'Diagonalization of Matrices',
              'content': 'A = PDP⁻¹, where D is diagonal matrix of eigenvalues, P is matrix of eigenvectors.',
              'examPoint': '⭐ Matrix is diagonalizable if it has n linearly independent eigenvectors. Check linear independence.',
              'application': 'Solving differential equations, matrix exponentiation, and simplifying linear transformations.'
            },
            {
              'name': 'Quadratic Forms',
              'content': 'Q(x) = xᵀAx. Classification: Positive definite, negative definite, indefinite. Use eigenvalues to classify.',
              'examPoint': '⭐ Positive definite: all λ > 0. Negative definite: all λ < 0. Indefinite: mixed signs.',
              'application': 'Optimization problems, machine learning cost functions, and stability analysis in engineering.'
            },
            {
              'name': 'Reduction to Canonical Form',
              'content': 'Transform quadratic form to sum of squares. Use orthogonal transformation. Eliminate cross terms.',
              'examPoint': '⭐ Canonical form: λ₁y₁² + λ₂y₂² + ... Principal axes are eigenvectors of coefficient matrix.',
              'application': 'Conic section analysis, stress analysis in materials, and principal component analysis.'
            },
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Mean Value Theorems',
          'importance': 'Calculus foundation - 20-25% weightage',
          'studyTips': 'Understand geometric interpretation, practice theorem applications, memorize conditions',
          'topics': [
            {
              'name': 'Rolle\'s Theorem',
              'content': 'If f(a) = f(b), f continuous on [a,b], differentiable on (a,b), then ∃c: f\'(c) = 0.',
              'examPoint': '⭐ Conditions: Continuity, differentiability, equal end values. Geometric: horizontal tangent exists.',
              'application': 'Root finding algorithms, optimization theory, and proving existence of critical points.'
            },
            {
              'name': 'Lagrange\'s Mean Value Theorem',
              'content': 'f\'(c) = [f(b) - f(a)]/(b - a) for some c ∈ (a,b). Generalization of Rolle\'s theorem.',
              'examPoint': '⭐ Geometric interpretation: tangent parallel to secant line. Used to prove other theorems.',
              'application': 'Error analysis in numerical methods, proving inequalities, and velocity-acceleration relationships.'
            },
            {
              'name': 'Cauchy\'s Mean Value Theorem',
              'content': '[f(b) - f(a)]/[g(b) - g(a)] = f\'(c)/g\'(c) for some c ∈ (a,b), where g\'(c) ≠ 0.',
              'examPoint': '⭐ Generalization of LMVT. Reduces to LMVT when g(x) = x. Used to prove L\'Hôpital\'s rule.',
              'application': 'Parametric curve analysis, proving L\'Hôpital\'s rule, and related rates problems.'
            },
            {
              'name': 'Taylor\'s Series',
              'content': 'f(x) = f(a) + f\'(a)(x-a) + f\'\'(a)(x-a)²/2! + ... + Rₙ. Rₙ is remainder term.',
              'examPoint': '⭐ Lagrange form of remainder: Rₙ = f⁽ⁿ⁺¹⁾(c)(x-a)ⁿ⁺¹/(n+1)! for some c between a and x.',
              'application': 'Numerical approximations, computer algorithms, physics modeling, and engineering calculations.'
            },
            {
              'name': 'Maclaurin\'s Series',
              'content': 'Special case of Taylor series with a = 0. f(x) = f(0) + f\'(0)x + f\'\'(0)x²/2! + ...',
              'examPoint': '⭐ Standard series: eˣ, sin x, cos x, ln(1+x), (1+x)ⁿ. Know convergence intervals.',
              'application': 'Calculator algorithms, signal processing, quantum mechanics, and approximation methods.'
            },
            {
              'name': 'Indeterminate Forms',
              'content': '0/0, ∞/∞, 0×∞, ∞-∞, 0⁰, 1^∞, ∞⁰. Cannot be evaluated directly. Need special techniques.',
              'examPoint': '⭐ Identify form first. Use L\'Hôpital\'s rule for 0/0 and ∞/∞. Transform others to these forms.',
              'application': 'Limit evaluation in calculus, asymptotic analysis, and mathematical modeling.'
            },
            {
              'name': 'L\'Hospital\'s Rule',
              'content': 'If lim f(x)/g(x) gives 0/0 or ∞/∞, then lim f(x)/g(x) = lim f\'(x)/g\'(x) (if latter exists).',
              'examPoint': '⭐ Apply repeatedly if needed. Check conditions before applying. Not applicable to all indeterminate forms.',
              'application': 'Evaluating complex limits, asymptotic behavior analysis, and optimization problems.'
            },
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Multivariable Calculus (Differentiation)',
          'importance': 'Advanced calculus - 25-30% weightage',
          'studyTips': 'Practice partial derivatives, understand chain rule applications, master optimization techniques',
          'topics': [
            {
              'name': 'Partial Derivatives',
              'content': '∂f/∂x: Rate of change with respect to x, keeping other variables constant. Higher order: ∂²f/∂x², ∂²f/∂x∂y.',
              'examPoint': '⭐ Clairaut\'s theorem: ∂²f/∂x∂y = ∂²f/∂y∂x if continuous. Geometric interpretation: slope of tangent.',
              'application': 'Heat conduction, fluid dynamics, economics (marginal analysis), and machine learning gradients.'
            },
            {
              'name': 'Total Differential',
              'content': 'df = (∂f/∂x)dx + (∂f/∂y)dy. Approximates change in f due to small changes in x and y.',
              'examPoint': '⭐ Linear approximation formula. Error analysis in measurements. Exact differential conditions.',
              'application': 'Error propagation in experiments, sensitivity analysis, and approximation methods in engineering.'
            },
            {
              'name': 'Chain Rule',
              'content': 'If z = f(x,y), x = g(t), y = h(t), then dz/dt = (∂z/∂x)(dx/dt) + (∂z/∂y)(dy/dt).',
              'examPoint': '⭐ Tree diagram method. Multiple variable cases. Implicit differentiation using chain rule.',
              'application': 'Related rates, parametric curves, coordinate transformations, and physics applications.'
            },
            {
              'name': 'Jacobians',
              'content': 'J = ∂(u,v)/∂(x,y) = |∂u/∂x  ∂u/∂y|. Determinant of partial derivative matrix.',
              'examPoint': '⭐ |∂v/∂x  ∂v/∂y| Change of variables in integration. J ≠ 0 for invertible transformation.',
              'application': 'Coordinate transformations, change of variables in integrals, and differential geometry.'
            },
            {
              'name': 'Maxima & Minima of Functions',
              'content': 'Critical points: ∇f = 0. Second derivative test: D = fₓₓfᵧᵧ - (fₓᵧ)². D > 0: extremum, D < 0: saddle.',
              'examPoint': '⭐ If D > 0: fₓₓ > 0 (minimum), fₓₓ < 0 (maximum). Boundary points for constrained problems.',
              'application': 'Optimization in engineering design, machine learning, economics, and operations research.'
            },
            {
              'name': 'Lagrange\'s Method of Multipliers',
              'content': 'Optimize f(x,y) subject to g(x,y) = 0. Solve ∇f = λ∇g and g(x,y) = 0 simultaneously.',
              'examPoint': '⭐ Set up system: fₓ = λgₓ, fᵧ = λgᵧ, g = 0. Multiple constraints: multiple multipliers.',
              'application': 'Constrained optimization, resource allocation, portfolio optimization, and engineering design.'
            },
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Multivariable Calculus (Integration)',
          'importance': 'Integration techniques - 25-30% weightage',
          'studyTips': 'Practice order of integration, understand geometric interpretation, master coordinate transformations',
          'topics': [
            {
              'name': 'Double Integrals',
              'content': '∬f(x,y)dA over region R. Evaluate as iterated integral: ∫∫f(x,y)dxdy or ∫∫f(x,y)dydx.',
              'examPoint': '⭐ Determine limits carefully. Type I: a ≤ x ≤ b, g₁(x) ≤ y ≤ g₂(x). Type II: c ≤ y ≤ d, h₁(y) ≤ x ≤ h₂(y).',
              'application': 'Area calculation, mass of lamina, center of mass, and moment of inertia calculations.'
            },
            {
              'name': 'Triple Integrals',
              'content': '∭f(x,y,z)dV over region E. Six possible orders of integration. Choose based on region shape.',
              'examPoint': '⭐ Rectangular: constant limits. General: variable limits. Sketch region to determine limits.',
              'application': 'Volume calculation, mass of 3D objects, gravitational fields, and fluid flow analysis.'
            },
            {
              'name': 'Change of Order of Integration',
              'content': 'Convert ∫∫f(x,y)dydx to ∫∫f(x,y)dxdy by changing integration limits and order.',
              'examPoint': '⭐ Sketch region first. Identify new limits. Sometimes one order is easier to evaluate.',
              'application': 'Simplifying complex integrals, computational efficiency, and solving otherwise difficult integrals.'
            },
            {
              'name': 'Change of Variables',
              'content': 'Transform (x,y) → (u,v). ∬f(x,y)dxdy = ∬f(x(u,v),y(u,v))|J|dudv, where J is Jacobian.',
              'examPoint': '⭐ Polar: x = rcosθ, y = rsinθ, J = r. Compute Jacobian carefully. Transform limits.',
              'application': 'Polar coordinates, cylindrical coordinates, spherical coordinates, and simplifying integration regions.'
            },
            {
              'name': 'Applications to Area & Volume',
              'content': 'Area = ∬1dA. Volume under surface = ∬f(x,y)dA. Volume between surfaces = ∬[f₂(x,y) - f₁(x,y)]dA.',
              'examPoint': '⭐ Set up integral correctly. Choose appropriate coordinate system. Check orientation and limits.',
              'application': 'Engineering design, architectural calculations, fluid volume calculations, and geometric modeling.'
            },
          ],
        },
      ],
    },
    'CHE': {
      'fullName': 'Engineering Chemistry',
      'icon': Icons.science,
      'color': Colors.green,
      'description': 'Chemistry for engineers - Understanding materials, reactions, and industrial processes!',
      'examTips': 'Focus on numerical problems, chemical equations, and industrial applications.',
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Atomic Structure & Bonding',
          'importance': 'Fundamental concepts - 15-20% weightage',
          'studyTips': 'Draw orbital diagrams, practice electron configurations, understand bonding theories',
          'topics': [
            {
              'name': 'Bohr\'s Atomic Model',
              'content': 'Electrons in fixed orbits. Energy levels: E = -13.6/n² eV. Radius: r = 0.529n² Å. Explains hydrogen spectrum.',
              'examPoint': '⭐ Limitations: Only for hydrogen, no explanation for fine structure. Quantum numbers: n=1,2,3...',
              'application': 'Foundation for understanding atomic spectra, laser technology, and quantum mechanics.'
            },
            {
              'name': 'Quantum Numbers',
              'content': 'n (principal): Energy level. l (azimuthal): Orbital shape. m (magnetic): Orbital orientation. s (spin): ±1/2.',
              'examPoint': '⭐ Rules: l = 0 to n-1, m = -l to +l, s = ±1/2. Practice electron configuration writing.',
              'application': 'Predicting chemical properties, understanding periodic trends, and material design.'
            },
            {
              'name': 'Aufbau Principle',
              'content': 'Electrons fill orbitals in order of increasing energy: 1s, 2s, 2p, 3s, 3p, 4s, 3d, 4p...',
              'examPoint': '⭐ Energy order: (n+l) rule. Same (n+l), lower n fills first. Practice: Cr, Cu exceptions.',
              'application': 'Predicting electronic properties of materials, semiconductors, and catalysts.'
            },
            {
              'name': 'Pauli\'s Exclusion Principle',
              'content': 'No two electrons can have identical set of four quantum numbers. Maximum 2 electrons per orbital with opposite spins.',
              'examPoint': '⭐ Explains electron capacity: s(2), p(6), d(10), f(14). Important for magnetic properties.',
              'application': 'Understanding magnetism, superconductivity, and electronic device behavior.'
            },
            {
              'name': 'Hund\'s Rule',
              'content': 'Electrons occupy orbitals singly before pairing. Maximum multiplicity in ground state.',
              'examPoint': '⭐ Half-filled and fully-filled orbitals are more stable. Examples: N, P, Mn configurations.',
              'application': 'Predicting magnetic behavior, stability of compounds, and catalytic activity.'
            },
            {
              'name': 'Ionic & Covalent Bonding',
              'content': 'Ionic: Electron transfer, electrostatic attraction. Covalent: Electron sharing. Electronegativity difference determines type.',
              'examPoint': '⭐ Ionic: ΔEN > 1.7, Covalent: ΔEN < 1.7. Lattice energy, bond energy calculations.',
              'application': 'Material properties, drug design, polymer chemistry, and ceramic engineering.'
            },
            {
              'name': 'Hybridization (sp, sp2, sp3)',
              'content': 'sp³: Tetrahedral (109.5°), sp²: Trigonal planar (120°), sp: Linear (180°). Mixing of atomic orbitals.',
              'examPoint': '⭐ Examples: CH₄ (sp³), C₂H₄ (sp²), C₂H₂ (sp). Predict molecular geometry and bond angles.',
              'application': 'Organic synthesis, pharmaceutical design, and understanding molecular properties.'
            },
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Electrochemistry',
          'importance': 'Industrial applications - 20-25% weightage',
          'studyTips': 'Practice Nernst equation calculations, understand cell diagrams, memorize standard potentials',
          'topics': [
            {
              'name': 'Electrochemical Cells',
              'content': 'Galvanic cell: Spontaneous reaction, generates electricity. Electrolytic cell: Non-spontaneous, requires external energy.',
              'examPoint': '⭐ Anode: Oxidation (negative in galvanic, positive in electrolytic). Cathode: Reduction (positive in galvanic, negative in electrolytic).',
              'application': 'Batteries, fuel cells, electroplating, metal refining, and corrosion protection systems.'
            },
            {
              'name': 'Electrode Potential',
              'content': 'Tendency of electrode to lose/gain electrons. Standard electrode potential (E°) measured against SHE (0V).',
              'examPoint': '⭐ E°cell = E°cathode - E°anode. Positive E°cell indicates spontaneous reaction. Learn standard reduction potentials.',
              'application': 'Predicting reaction feasibility, battery design, corrosion studies, and metal extraction processes.'
            },
            {
              'name': 'Nernst Equation',
              'content': 'E = E° - (RT/nF)ln(Q) = E° - (0.059/n)log(Q) at 25°C. Relates potential to concentration.',
              'examPoint': '⭐ At equilibrium: E = 0, so E° = (0.059/n)log(K). Practice numerical problems with different concentrations.',
              'application': 'pH meters, concentration cells, ion-selective electrodes, and analytical chemistry.'
            },
            {
              'name': 'Reference Electrodes',
              'content': 'Standard Hydrogen Electrode (SHE): H₂|H⁺(1M)|Pt, E° = 0V. Calomel electrode: Hg|Hg₂Cl₂|KCl.',
              'examPoint': '⭐ SHE is primary standard. Secondary standards: Calomel, Ag/AgCl. Constant potential reference.',
              'application': 'Electroanalytical measurements, pH determination, and potential measurements in research.'
            },
            {
              'name': 'Batteries (Primary & Secondary)',
              'content': 'Primary: Non-rechargeable (dry cell, alkaline). Secondary: Rechargeable (lead-acid, Li-ion, Ni-Cd).',
              'examPoint': '⭐ Lead-acid: Pb|PbSO₄|H₂SO₄|PbSO₄|PbO₂. Li-ion: High energy density, no memory effect.',
              'application': 'Portable electronics, electric vehicles, grid storage, and backup power systems.'
            },
            {
              'name': 'Fuel Cells',
              'content': 'Convert chemical energy directly to electrical energy. H₂-O₂ fuel cell: 2H₂ + O₂ → 2H₂O + electricity.',
              'examPoint': '⭐ Advantages: High efficiency, clean operation. Types: PEMFC, SOFC, AFC. Catalyst required.',
              'application': 'Clean energy generation, space missions, automotive industry, and stationary power.'
            },
            {
              'name': 'Corrosion & Prevention',
              'content': 'Electrochemical oxidation of metals. Rusting: Fe → Fe²⁺ + 2e⁻. Factors: moisture, oxygen, pH, salts.',
              'examPoint': '⭐ Prevention: Galvanizing (Zn coating), cathodic protection, alloying, painting, passivation.',
              'application': 'Infrastructure protection, marine engineering, automotive industry, and pipeline maintenance.'
            },
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Polymers',
          'importance': 'Material science - 20-25% weightage',
          'studyTips': 'Understand polymerization mechanisms, classify polymers, learn industrial applications',
          'topics': [
            {
              'name': 'Classification of Polymers',
              'content': 'By source: Natural (cellulose, rubber), synthetic (nylon, PVC). By structure: Linear, branched, cross-linked.',
              'examPoint': '⭐ Thermoplastic: Softens on heating (PE, PP). Thermosetting: Hardens permanently (bakelite, epoxy).',
              'application': 'Material selection for engineering applications, recycling processes, and product design.'
            },
            {
              'name': 'Polymerization Techniques',
              'content': 'Addition: Chain reaction, no by-products. Condensation: Step-wise, eliminates small molecules (H₂O, HCl).',
              'examPoint': '⭐ Addition: Initiator required, rapid propagation. Condensation: Functional groups react, slower process.',
              'application': 'Industrial polymer production, specialty materials synthesis, and process optimization.'
            },
            {
              'name': 'Addition Polymerization',
              'content': 'Initiation → Propagation → Termination. Free radical mechanism. Examples: PE, PP, PS, PVC.',
              'examPoint': '⭐ Initiators: Peroxides, AIBN. Chain transfer affects molecular weight. Inhibitors stop polymerization.',
              'application': 'Plastic manufacturing, synthetic rubber production, and coating materials.'
            },
            {
              'name': 'Condensation Polymerization',
              'content': 'Step-growth mechanism. Functional groups react to form bonds. Examples: Nylon, polyester, bakelite.',
              'examPoint': '⭐ Requires bifunctional monomers. High conversion needed for high molecular weight. Eliminates H₂O, HCl.',
              'application': 'Fiber production, engineering plastics, adhesives, and composite materials.'
            },
            {
              'name': 'Properties of Polymers',
              'content': 'Mechanical: Tensile strength, elasticity. Thermal: Tg, Tm. Chemical: Resistance to solvents, acids.',
              'examPoint': '⭐ Crystallinity affects properties. Molecular weight influences strength. Cross-linking increases rigidity.',
              'application': 'Material characterization, quality control, product development, and failure analysis.'
            },
            {
              'name': 'Plastics, Rubbers & Fibers',
              'content': 'Plastics: Rigid polymers (PE, PP, PS). Rubbers: Elastic polymers (natural, synthetic). Fibers: High strength (nylon, polyester).',
              'examPoint': '⭐ Vulcanization improves rubber properties. Fiber spinning: melt, wet, dry spinning methods.',
              'application': 'Packaging industry, automotive parts, textiles, medical devices, and construction materials.'
            },
            {
              'name': 'Engineering Applications',
              'content': 'Composites: Fiber-reinforced plastics. Biodegradable polymers. Conducting polymers. Smart materials.',
              'examPoint': '⭐ Carbon fiber composites: High strength-to-weight ratio. PLA, PGA: Biodegradable. Applications in aerospace.',
              'application': 'Aerospace industry, biomedical implants, electronics, environmental applications, and advanced materials.'
            },
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Water Technology',
          'importance': 'Environmental engineering - 15-20% weightage',
          'studyTips': 'Practice hardness calculations, understand treatment processes, learn industrial applications',
          'topics': [
            {
              'name': 'Hardness of Water',
              'content': 'Temporary: Due to bicarbonates (Ca(HCO₃)₂, Mg(HCO₃)₂). Permanent: Due to sulfates, chlorides (CaSO₄, MgCl₂).',
              'examPoint': '⭐ Temporary hardness removed by boiling. Permanent hardness requires chemical treatment. Total = Temporary + Permanent.',
              'application': 'Water quality assessment, industrial water treatment, and domestic water softening systems.'
            },
            {
              'name': 'Units of Hardness',
              'content': 'ppm (parts per million), mg/L (milligrams per liter). 1 ppm = 1 mg/L. French degree, German degree.',
              'examPoint': '⭐ 1 French degree = 10 ppm CaCO₃. Soft water: <75 ppm, Hard water: >150 ppm. Practice unit conversions.',
              'application': 'Water quality standards, regulatory compliance, and treatment system design.'
            },
            {
              'name': 'Estimation of Hardness (EDTA Method)',
              'content': 'Complexometric titration. EDTA forms stable complexes with Ca²⁺, Mg²⁺. EBT indicator (wine red → blue).',
              'examPoint': '⭐ Buffer pH 10. Mg-EDTA complex more stable than Ca-EDTA. Calculate hardness as ppm CaCO₃.',
              'application': 'Water analysis laboratories, quality control in industries, and environmental monitoring.'
            },
            {
              'name': 'Water Softening Methods',
              'content': 'Lime-soda process: Ca(OH)₂ + Na₂CO₃. Zeolite process: Ion exchange. Removes Ca²⁺, Mg²⁺ ions.',
              'examPoint': '⭐ Lime removes temporary hardness. Soda removes permanent hardness. Zeolite: RNa₂ + Ca²⁺ → RCa + 2Na⁺.',
              'application': 'Municipal water treatment, industrial boiler feed water, and domestic water softeners.'
            },
            {
              'name': 'Ion Exchange Process',
              'content': 'Synthetic resins exchange ions. Cation exchange: R-H + Na⁺ → R-Na + H⁺. Anion exchange: R-OH + Cl⁻ → R-Cl + OH⁻.',
              'examPoint': '⭐ Demineralization: Cation + Anion exchange. Regeneration: HCl for cation, NaOH for anion resin.',
              'application': 'Ultra-pure water production, pharmaceutical industry, and power plant water treatment.'
            },
            {
              'name': 'Reverse Osmosis',
              'content': 'Semi-permeable membrane separates water from dissolved salts. Pressure > osmotic pressure required.',
              'examPoint': '⭐ Removes 95-99% dissolved salts. Pre-treatment required. Energy intensive process. Concentrate disposal needed.',
              'application': 'Desalination plants, drinking water purification, and industrial process water.'
            },
            {
              'name': 'Boiler Troubles',
              'content': 'Scale formation: CaSO₄, Mg(OH)₂ deposits. Corrosion: O₂, CO₂ attack. Priming: Carryover of water droplets.',
              'examPoint': '⭐ Scale reduces heat transfer. Caustic embrittlement: NaOH attack. Prevention: Water treatment, chemical dosing.',
              'application': 'Power plants, industrial boilers, and steam generation systems.'
            },
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Spectroscopy & Nanomaterials',
          'importance': 'Modern analytical techniques - 15-20% weightage',
          'studyTips': 'Understand spectroscopic principles, learn nanomaterial properties, focus on applications',
          'topics': [
            {
              'name': 'UV-Visible Spectroscopy',
              'content': 'Electronic transitions in molecules. λmax depends on conjugation. Beer-Lambert law: A = εcl.',
              'examPoint': '⭐ π→π* transitions in conjugated systems. Bathochromic shift: red shift. Hypsochromic shift: blue shift.',
              'application': 'Quantitative analysis, pharmaceutical quality control, and environmental monitoring.'
            },
            {
              'name': 'IR Spectroscopy',
              'content': 'Vibrational transitions. Functional group identification. Fingerprint region: 1500-500 cm⁻¹.',
              'examPoint': '⭐ O-H: 3200-3600 cm⁻¹, C=O: 1700-1750 cm⁻¹, C-H: 2850-3000 cm⁻¹. Symmetric vibrations IR inactive.',
              'application': 'Structural elucidation, polymer characterization, and forensic analysis.'
            },
            {
              'name': 'NMR Spectroscopy',
              'content': 'Nuclear magnetic resonance. Chemical shift (δ) in ppm. Spin-spin coupling causes splitting.',
              'examPoint': '⭐ ¹H NMR: Integration gives proton ratio. ¹³C NMR: Carbon skeleton. Shielding/deshielding effects.',
              'application': 'Organic structure determination, pharmaceutical research, and metabolomics studies.'
            },
            {
              'name': 'Introduction to Nanomaterials',
              'content': 'Size: 1-100 nm. High surface-to-volume ratio. Quantum size effects. Unique optical, electrical properties.',
              'examPoint': '⭐ Classification: 0D (quantum dots), 1D (nanotubes), 2D (graphene), 3D (nanoparticles).',
              'application': 'Electronics, medicine, catalysis, energy storage, and environmental remediation.'
            },
            {
              'name': 'Synthesis of Nanomaterials',
              'content': 'Top-down: Mechanical milling, lithography. Bottom-up: Chemical vapor deposition, sol-gel, precipitation.',
              'examPoint': '⭐ Sol-gel: Hydrolysis → condensation. CVD: Gas phase precursors. Control size by reaction conditions.',
              'application': 'Semiconductor industry, catalyst preparation, and advanced material manufacturing.'
            },
            {
              'name': 'Properties & Applications',
              'content': 'Mechanical: High strength. Optical: Quantum confinement. Electrical: Tunneling effects. Magnetic: Superparamagnetism.',
              'examPoint': '⭐ Carbon nanotubes: High tensile strength. Quantum dots: Size-tunable emission. Silver nanoparticles: Antimicrobial.',
              'application': 'Drug delivery, solar cells, sensors, composites, and water purification systems.'
            },
          ],
        },
      ],
    },
    'CE': {
      'fullName': 'Communicative English',
      'icon': Icons.language,
      'color': Colors.orange,
      'description': 'Master English communication for professional success - Essential for global careers!',
      'examTips': 'Practice writing daily, read newspapers, focus on grammar rules, and improve vocabulary.',
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Vocabulary & Word Formation',
          'importance': 'Foundation unit - 20-25% weightage',
          'studyTips': 'Learn 10 new words daily, practice word formation rules, use vocabulary in sentences',
          'topics': [
            {
              'name': 'Synonyms & Antonyms',
              'content': 'Synonyms: Words with similar meanings (big-large, happy-joyful). Antonyms: Words with opposite meanings (hot-cold, love-hate).',
              'examPoint': '⭐ Context matters for synonyms. Practice with word pairs. Common exam words: abundant-scarce, benevolent-malevolent.',
              'application': 'Improving writing style, avoiding repetition, enhancing communication clarity, and competitive exams.'
            },
            {
              'name': 'Prefixes & Suffixes',
              'content': 'Prefix: Added before root (un-, re-, pre-). Suffix: Added after root (-tion, -ness, -ful). Changes word meaning/class.',
              'examPoint': '⭐ Common prefixes: un- (not), re- (again), pre- (before). Suffixes: -tion (noun), -ly (adverb), -ful (adjective).',
              'application': 'Expanding vocabulary, understanding new words, technical terminology, and academic writing.'
            },
            {
              'name': 'Root Words',
              'content': 'Base form of word without prefixes/suffixes. Latin/Greek origins common in English. Understanding roots helps decode meanings.',
              'examPoint': '⭐ Common roots: spect (see), dict (say), port (carry), scrib (write). Practice identifying roots in complex words.',
              'application': 'Vocabulary building, understanding technical terms, medical/scientific terminology, and etymology studies.'
            },
            {
              'name': 'One-Word Substitution',
              'content': 'Replace phrases/sentences with single words. Improves conciseness. Example: "One who studies stars" = Astronomer.',
              'examPoint': '⭐ Practice common substitutions: Bibliophile (book lover), Misogynist (woman hater), Omnivore (eats everything).',
              'application': 'Competitive exams, precise communication, professional writing, and vocabulary enhancement.'
            },
            {
              'name': 'Idioms & Phrases',
              'content': 'Expressions with meanings different from literal words. "Break the ice" = start conversation. Cultural significance important.',
              'examPoint': '⭐ Common idioms: "Piece of cake" (easy), "Hit the nail on the head" (exactly right), "Spill the beans" (reveal secret).',
              'application': 'Natural conversation, understanding native speakers, creative writing, and cultural communication.'
            },
            {
              'name': 'Collocations',
              'content': 'Words that naturally go together. "Heavy rain" not "strong rain". "Make a decision" not "do a decision".',
              'examPoint': '⭐ Verb collocations: make/do, take/have. Adjective collocations: strong coffee, fast car. Practice common combinations.',
              'application': 'Natural-sounding English, professional communication, academic writing, and fluency development.'
            },
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Grammar Essentials',
          'importance': 'Core unit - 30-35% weightage',
          'studyTips': 'Practice grammar exercises daily, understand rules with examples, focus on common errors',
          'topics': [
            {
              'name': 'Parts of Speech',
              'content': '8 parts: Noun, Pronoun, Verb, Adjective, Adverb, Preposition, Conjunction, Interjection. Each has specific function.',
              'examPoint': '⭐ Identify parts in sentences. Same word can be different parts: "Light the light light" (verb, adjective, noun).',
              'application': 'Sentence construction, grammar analysis, writing improvement, and language teaching.'
            },
            {
              'name': 'Tenses (Present, Past, Future)',
              'content': '12 tenses total. Each has simple, continuous, perfect, perfect continuous forms. Time and aspect combinations.',
              'examPoint': '⭐ Present perfect vs simple past. Future forms: will, going to, present continuous. Practice timeline exercises.',
              'application': 'Accurate time expression, storytelling, report writing, and professional communication.'
            },
            {
              'name': 'Active & Passive Voice',
              'content': 'Active: Subject performs action (John wrote the letter). Passive: Subject receives action (Letter was written by John).',
              'examPoint': '⭐ Formation: be + past participle. Use passive when doer unknown/unimportant. Not all verbs have passive.',
              'application': 'Formal writing, scientific reports, news writing, and objective communication.'
            },
            {
              'name': 'Direct & Indirect Speech',
              'content': 'Direct: Exact words in quotes. Indirect: Reported speech with changes in tense, pronouns, time expressions.',
              'examPoint': '⭐ Backshift rules: present→past, past→past perfect. Reporting verbs: said, told, asked, exclaimed.',
              'application': 'News reporting, storytelling, academic writing, and professional communication.'
            },
            {
              'name': 'Subject-Verb Agreement',
              'content': 'Singular subject takes singular verb. Plural subject takes plural verb. Tricky cases: collective nouns, compound subjects.',
              'examPoint': '⭐ Either...or, neither...nor: verb agrees with nearest subject. Collective nouns: team is/are (depends on context).',
              'application': 'Correct sentence formation, professional writing, and avoiding common errors.'
            },
            {
              'name': 'Articles (a, an, the)',
              'content': 'A/An: Indefinite articles (general). The: Definite article (specific). Zero article: No article needed.',
              'examPoint': '⭐ A before consonant sounds, An before vowel sounds. The with superlatives, unique things. No article with general plurals.',
              'application': 'Natural English flow, academic writing, and professional communication.'
            },
            {
              'name': 'Prepositions',
              'content': 'Show relationships: time (at, on, in), place (at, on, in), direction (to, from, through), manner (by, with).',
              'examPoint': '⭐ At specific time/place, On days/surfaces, In months/enclosed spaces. Phrasal verbs change meanings.',
              'application': 'Precise expression, avoiding ambiguity, and natural language use.'
            },
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Reading Comprehension',
          'importance': 'Critical skill - 25-30% weightage',
          'studyTips': 'Read diverse materials daily, practice speed reading, develop analytical thinking',
          'topics': [
            {
              'name': 'Reading Strategies',
              'content': 'Pre-reading: Preview, predict. While reading: Question, connect. Post-reading: Summarize, evaluate.',
              'examPoint': '⭐ SQ3R method: Survey, Question, Read, Recite, Review. Active reading improves comprehension.',
              'application': 'Academic success, research skills, information processing, and lifelong learning.'
            },
            {
              'name': 'Skimming & Scanning',
              'content': 'Skimming: Quick overview for main ideas. Scanning: Looking for specific information. Different purposes, different speeds.',
              'examPoint': '⭐ Skimming: Read first/last paragraphs, topic sentences. Scanning: Use keywords, ignore irrelevant text.',
              'application': 'Exam preparation, research efficiency, information retrieval, and time management.'
            },
            {
              'name': 'Understanding Main Ideas',
              'content': 'Main idea: Central message of passage. Supporting details: Evidence, examples. Topic sentences often contain main ideas.',
              'examPoint': '⭐ Distinguish main ideas from details. Look for repeated concepts. Summarize in your own words.',
              'application': 'Academic reading, note-taking, essay writing, and critical thinking development.'
            },
            {
              'name': 'Inference & Interpretation',
              'content': 'Reading between lines. Drawing conclusions from given information. Understanding implied meanings, author\'s purpose.',
              'examPoint': '⭐ Use context clues. Consider author\'s tone, bias. Distinguish facts from opinions. Practice logical reasoning.',
              'application': 'Critical analysis, literature appreciation, research evaluation, and decision-making skills.'
            },
            {
              'name': 'Critical Reading',
              'content': 'Evaluating arguments, identifying bias, questioning assumptions. Analyzing evidence quality, logical fallacies.',
              'examPoint': '⭐ Question everything: Who, what, when, where, why, how. Check source credibility. Look for supporting evidence.',
              'application': 'Academic research, media literacy, professional analysis, and informed decision-making.'
            },
            {
              'name': 'Note-Making',
              'content': 'Condensing information in organized format. Methods: Outline, mind maps, Cornell notes. Use abbreviations, symbols.',
              'examPoint': '⭐ Identify key points, use hierarchical structure. Practice different formats. Review and revise notes.',
              'application': 'Study efficiency, meeting records, research organization, and knowledge retention.'
            },
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Writing Skills',
          'importance': 'Practical application - 25-30% weightage',
          'studyTips': 'Practice different formats, focus on structure, proofread carefully, build vocabulary',
          'topics': [
            {
              'name': 'Paragraph Writing',
              'content': 'Topic sentence + supporting sentences + concluding sentence. Unity, coherence, emphasis. Logical flow of ideas.',
              'examPoint': '⭐ PEEL structure: Point, Evidence, Explanation, Link. Use transition words. One main idea per paragraph.',
              'application': 'Academic essays, reports, professional communication, and content creation.'
            },
            {
              'name': 'Essay Writing',
              'content': 'Introduction + body paragraphs + conclusion. Types: Descriptive, narrative, expository, argumentative.',
              'examPoint': '⭐ Hook in introduction, thesis statement. Body: topic sentences, evidence. Conclusion: restate, reflect.',
              'application': 'Academic assignments, competitive exams, professional proposals, and creative writing.'
            },
            {
              'name': 'Letter Writing (Formal & Informal)',
              'content': 'Formal: Business format, polite tone. Informal: Personal, casual tone. Different purposes, different structures.',
              'examPoint': '⭐ Formal: Sender\'s address, date, recipient\'s address, salutation, body, closing. Informal: More flexible format.',
              'application': 'Business communication, job applications, personal correspondence, and official requests.'
            },
            {
              'name': 'Email Etiquette',
              'content': 'Clear subject lines, professional tone, proper greetings/closings. CC/BCC usage. Attachment guidelines.',
              'examPoint': '⭐ Subject line summarizes content. Use professional language. Proofread before sending. Reply appropriately.',
              'application': 'Workplace communication, academic correspondence, and professional networking.'
            },
            {
              'name': 'Report Writing',
              'content': 'Structured format: Title, executive summary, introduction, methodology, findings, conclusions, recommendations.',
              'examPoint': '⭐ Objective tone, factual content. Use headings, bullet points. Include data, charts if relevant.',
              'application': 'Business reports, research papers, project documentation, and professional analysis.'
            },
            {
              'name': 'Resume & Cover Letter',
              'content': 'Resume: Concise career summary. Cover letter: Personalized application. Highlight relevant skills, achievements.',
              'examPoint': '⭐ Resume: Reverse chronological order, action verbs, quantify achievements. Cover letter: Address specific job.',
              'application': 'Job applications, career advancement, professional branding, and networking.'
            },
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Communication Skills',
          'importance': 'Professional skills - 20-25% weightage',
          'studyTips': 'Practice speaking regularly, record yourself, observe body language, join discussion groups',
          'topics': [
            {
              'name': 'Listening Skills',
              'content': 'Active listening: Full attention, understanding, responding. Barriers: Noise, preconceptions, distractions.',
              'examPoint': '⭐ Types: Informational, critical, empathetic. Techniques: Paraphrasing, questioning, summarizing.',
              'application': 'Effective communication, relationship building, learning enhancement, and conflict resolution.'
            },
            {
              'name': 'Speaking Skills',
              'content': 'Clear articulation, appropriate pace, proper pronunciation. Organize thoughts, use examples, engage audience.',
              'examPoint': '⭐ Voice modulation, pause effectively. Practice tongue twisters. Record and analyze your speech.',
              'application': 'Public speaking, presentations, interviews, and professional interactions.'
            },
            {
              'name': 'Presentation Skills',
              'content': 'Structure: Opening, body, closing. Visual aids, audience engagement. Confidence, eye contact, gestures.',
              'examPoint': '⭐ PREP method: Point, Reason, Example, Point. Practice with timer. Handle questions confidently.',
              'application': 'Academic presentations, business meetings, training sessions, and leadership roles.'
            },
            {
              'name': 'Group Discussion',
              'content': 'Collaborative communication. Listen actively, contribute meaningfully, respect others. Leadership and teamwork.',
              'examPoint': '⭐ Initiate discussion, build on others\' ideas. Avoid dominating. Use facts, examples. Conclude effectively.',
              'application': 'Team meetings, brainstorming sessions, academic seminars, and selection processes.'
            },
            {
              'name': 'Interview Techniques',
              'content': 'Preparation: Research, practice answers. During: Confidence, honesty, examples. Follow-up: Thank you note.',
              'examPoint': '⭐ STAR method: Situation, Task, Action, Result. Prepare questions to ask. Dress appropriately.',
              'application': 'Job interviews, admission interviews, performance reviews, and career advancement.'
            },
            {
              'name': 'Body Language & Non-Verbal Communication',
              'content': 'Posture, gestures, facial expressions, eye contact. 55% of communication is non-verbal. Cultural differences matter.',
              'examPoint': '⭐ Open posture shows confidence. Mirroring builds rapport. Maintain appropriate eye contact. Avoid fidgeting.',
              'application': 'Professional interactions, public speaking, relationship building, and cross-cultural communication.'
            },
          ],
        },
      ],
    },
    'BME': {
      'fullName': 'Basic Mechanical Engineering',
      'icon': Icons.settings,
      'color': Colors.red,
      'description': 'Foundation of mechanical systems - Master forces, materials, thermodynamics, and power transmission!',
      'examTips': 'Focus on numerical problems, understand concepts with diagrams, practice derivations extensively.',
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Force Systems & Equilibrium',
          'importance': 'Foundation unit - 20-25% weightage in exams',
          'studyTips': 'Draw clear free body diagrams, practice vector addition, understand equilibrium conditions',
          'topics': [
            {
              'name': 'Introduction to Mechanics',
              'content': 'Mechanics: Study of forces and motion. Branches: Statics (equilibrium), Dynamics (motion), Kinematics (motion without forces). SI units: Force (N), Length (m), Time (s).',
              'examPoint': '⭐ Fundamental quantities: Mass, Length, Time. Derived: Force, Pressure, Energy. Know unit conversions.',
              'application': 'Foundation for all mechanical design, structural analysis, robotics, and aerospace engineering.'
            },
            {
              'name': 'Force & Types of Forces',
              'content': 'Force: Push or pull causing acceleration. Types: Contact (friction, normal) vs Non-contact (gravity, magnetic). Vector quantity with magnitude and direction.',
              'examPoint': '⭐ Newton\'s laws: F=ma, Action-Reaction pairs. Force components: Fx = F cos θ, Fy = F sin θ.',
              'application': 'Machine design, structural engineering, automotive systems, and mechanical component analysis.'
            },
            {
              'name': 'Resultant of Forces',
              'content': 'Single force equivalent to multiple forces. Methods: Parallelogram law, Triangle law, Component method. R = √(Rx² + Ry²), θ = tan⁻¹(Ry/Rx).',
              'examPoint': '⭐ Concurrent forces: Meet at a point. Coplanar forces: In same plane. Practice graphical and analytical methods.',
              'application': 'Truss analysis, crane design, bridge engineering, and mechanical linkage systems.'
            },
            {
              'name': 'Moment of a Force',
              'content': 'Tendency to rotate about a point. M = F × d (perpendicular distance). Units: N⋅m. Clockwise: negative, Counter-clockwise: positive.',
              'examPoint': '⭐ Varignon\'s theorem: Moment of resultant = Sum of moments. Moment arm is perpendicular distance.',
              'application': 'Lever systems, gear design, wrench applications, and rotational machinery analysis.'
            },
            {
              'name': 'Couple',
              'content': 'Two equal, opposite, parallel forces. Pure rotation without translation. Moment = F × d (distance between forces). Independent of reference point.',
              'examPoint': '⭐ Couple cannot be balanced by single force. Only another couple can balance it. Moment is constant.',
              'application': 'Steering wheels, door handles, motor torque, and rotational control systems.'
            },
            {
              'name': 'Free Body Diagrams',
              'content': 'Isolated body showing all external forces. Essential for equilibrium analysis. Include: Applied forces, reactions, weights, friction.',
              'examPoint': '⭐ Steps: Isolate body, identify forces, show directions clearly, choose coordinate system. Practice extensively.',
              'application': 'Structural analysis, machine design, safety analysis, and engineering problem solving.'
            },
            {
              'name': 'Equilibrium of Rigid Bodies',
              'content': 'Static equilibrium: ΣFx = 0, ΣFy = 0, ΣM = 0. No acceleration or rotation. Stable, unstable, neutral equilibrium types.',
              'examPoint': '⭐ Three equations for 2D problems. Six equations for 3D. Determine unknown forces and reactions.',
              'application': 'Building design, bridge analysis, crane stability, and mechanical system design.'
            },
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Friction',
          'importance': 'Practical applications - 15-20% weightage',
          'studyTips': 'Understand friction laws, practice inclined plane problems, memorize friction coefficients',
          'topics': [
            {
              'name': 'Laws of Friction',
              'content': '1) Friction opposes motion. 2) Independent of contact area. 3) Proportional to normal force. 4) Static > Kinetic friction. 5) Independent of velocity (approximately).',
              'examPoint': '⭐ Coulomb\'s laws of friction. Static friction: f ≤ μsN. Kinetic friction: f = μkN. Always μs > μk.',
              'application': 'Brake systems, clutch design, belt drives, and safety analysis in mechanical systems.'
            },
            {
              'name': 'Coefficient of Friction',
              'content': 'μ = f/N. Dimensionless constant. Static coefficient (μs) > Kinetic coefficient (μk). Material property depending on surface conditions.',
              'examPoint': '⭐ Typical values: Steel on steel (0.6), Rubber on concrete (0.9). Dry vs wet conditions affect μ.',
              'application': 'Tire design, bearing selection, material pairing in machines, and safety factor calculations.'
            },
            {
              'name': 'Angle of Friction',
              'content': 'φ = tan⁻¹(μ). Angle between resultant reaction and normal. At limiting equilibrium, resultant makes angle φ with normal.',
              'examPoint': '⭐ Angle of repose = Angle of friction. Cone of friction concept. tan φ = μ.',
              'application': 'Slope stability, material handling, conveyor design, and granular material storage.'
            },
            {
              'name': 'Friction on Inclined Planes',
              'content': 'Forces: Weight component (mg sin θ), Normal force (mg cos θ), Friction (μN). Motion depends on θ vs φ comparison.',
              'examPoint': '⭐ If θ < φ: No motion. If θ = φ: Limiting equilibrium. If θ > φ: Motion occurs. Practice numerical problems.',
              'application': 'Ramp design, conveyor systems, vehicle parking on slopes, and material transport systems.'
            },
            {
              'name': 'Ladder Friction Problems',
              'content': 'Ladder against wall: Forces at base (friction, normal) and top (normal only). Equilibrium equations determine minimum friction coefficient.',
              'examPoint': '⭐ Three equilibrium equations. Minimum μ for no slipping. Consider ladder weight and applied loads.',
              'application': 'Safety ladder design, scaffolding systems, and structural support analysis.'
            },
            {
              'name': 'Belt Friction',
              'content': 'Eytelwein\'s equation: T₂/T₁ = e^(μβ), where β is wrap angle in radians. Higher wrap angle increases friction capacity.',
              'examPoint': '⭐ β in radians. For flat belt: T₂ = T₁e^(μβ). V-belt has higher effective friction due to wedge action.',
              'application': 'Belt drive design, pulley systems, conveyor belts, and power transmission mechanisms.'
            },
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Properties of Materials',
          'importance': 'Material science foundation - 25-30% weightage',
          'studyTips': 'Understand stress-strain relationships, memorize material properties, practice numerical problems',
          'topics': [
            {
              'name': 'Stress & Strain',
              'content': 'Stress (σ) = Force/Area (Pa or N/m²). Types: Normal (tensile/compressive), Shear. Strain (ε) = Change in length/Original length (dimensionless).',
              'examPoint': '⭐ Normal stress: σ = P/A. Shear stress: τ = V/A. Normal strain: ε = δL/L. Shear strain: γ = tan θ.',
              'application': 'Structural design, material selection, safety analysis, and mechanical component sizing.'
            },
            {
              'name': 'Hooke\'s Law',
              'content': 'Within elastic limit: Stress ∝ Strain. σ = Eε (normal), τ = Gγ (shear). E: Young\'s modulus, G: Shear modulus.',
              'examPoint': '⭐ Linear relationship in elastic region. E = σ/ε. Units: Pa or GPa. Material property independent of geometry.',
              'application': 'Spring design, elastic deformation calculations, and material behavior prediction under loads.'
            },
            {
              'name': 'Elastic Moduli',
              'content': 'Young\'s modulus (E): Normal stress/strain. Shear modulus (G): Shear stress/strain. Bulk modulus (K): Volumetric stress/strain.',
              'examPoint': '⭐ Relationship: E = 2G(1+ν) = 3K(1-2ν). Typical values: Steel E ≈ 200 GPa, Aluminum E ≈ 70 GPa.',
              'application': 'Material selection, deflection calculations, vibration analysis, and structural optimization.'
            },
            {
              'name': 'Stress-Strain Diagrams',
              'content': 'Graphical representation of material behavior. Regions: Elastic, yielding, strain hardening, necking, fracture. Key points: Proportional limit, yield point, ultimate strength.',
              'examPoint': '⭐ Ductile vs Brittle materials. Yield strength, Ultimate tensile strength, % Elongation, % Reduction in area.',
              'application': 'Material characterization, design safety factors, failure analysis, and quality control testing.'
            },
            {
              'name': 'Poisson\'s Ratio',
              'content': 'ν = -Lateral strain/Longitudinal strain. For most materials: 0 < ν < 0.5. Steel ≈ 0.3, Rubber ≈ 0.5, Cork ≈ 0.',
              'examPoint': '⭐ Negative sign indicates opposite strains. Used in 3D stress analysis. Incompressible materials: ν = 0.5.',
              'application': 'Multi-axial stress analysis, pressure vessel design, and composite material behavior prediction.'
            },
            {
              'name': 'Thermal Stresses',
              'content': 'Stress due to temperature change when expansion is constrained. σ = EαΔT, where α is coefficient of thermal expansion.',
              'examPoint': '⭐ Free expansion: δ = αLΔT. Constrained: stress develops. Thermal strain: εth = αΔT.',
              'application': 'Pipeline design, building expansion joints, engine components, and thermal barrier systems.'
            },
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Thermodynamics',
          'importance': 'Energy systems - 20-25% weightage',
          'studyTips': 'Understand energy conservation, practice cycle problems, memorize thermodynamic properties',
          'topics': [
            {
              'name': 'Basic Concepts & Definitions',
              'content': 'System: Matter under study. Surroundings: Everything else. Boundary: Separates system and surroundings. Types: Open, Closed, Isolated systems.',
              'examPoint': '⭐ Properties: Intensive (temperature, pressure) vs Extensive (mass, volume). State vs Process vs Cycle.',
              'application': 'Power plant analysis, refrigeration systems, engine design, and energy conversion processes.'
            },
            {
              'name': 'Zeroth Law of Thermodynamics',
              'content': 'If two systems are in thermal equilibrium with a third system, they are in thermal equilibrium with each other. Basis for temperature measurement.',
              'examPoint': '⭐ Establishes concept of temperature. Thermal equilibrium means no heat transfer. Foundation for thermometry.',
              'application': 'Temperature measurement, calibration standards, and thermal system design.'
            },
            {
              'name': 'First Law of Thermodynamics',
              'content': 'Energy conservation: ΔU = Q - W. For cycle: ΣQ = ΣW. Internal energy is state function. Heat and work are path functions.',
              'examPoint': '⭐ Sign convention: Q positive (heat to system), W positive (work by system). ΔU = U₂ - U₁.',
              'application': 'Energy balance in engines, heat pumps, power plants, and all energy conversion devices.'
            },
            {
              'name': 'Second Law of Thermodynamics',
              'content': 'Heat cannot spontaneously flow from cold to hot body. Entropy of isolated system never decreases. Defines direction of processes.',
              'examPoint': '⭐ Kelvin-Planck and Clausius statements. Entropy: dS ≥ dQ/T. Reversible vs Irreversible processes.',
              'application': 'Heat engine efficiency limits, refrigeration systems, and process feasibility analysis.'
            },
            {
              'name': 'Heat Engines',
              'content': 'Device converting heat to work. Efficiency: η = W/QH = 1 - QL/QH. Requires hot and cold reservoirs. Cannot have 100% efficiency.',
              'examPoint': '⭐ Thermal efficiency always < 1. Carnot engine has maximum possible efficiency. η = 1 - TC/TH (absolute temperatures).',
              'application': 'Internal combustion engines, steam turbines, gas turbines, and power generation systems.'
            },
            {
              'name': 'Carnot Cycle',
              'content': 'Ideal reversible cycle with maximum efficiency. Four processes: Two isothermal, two adiabatic. ηCarnot = 1 - TL/TH.',
              'examPoint': '⭐ Most efficient cycle between two temperature limits. All real engines have lower efficiency. Benchmark for comparison.',
              'application': 'Theoretical limit for heat engines, performance comparison standard, and thermodynamic cycle analysis.'
            },
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Power Transmission',
          'importance': 'Mechanical systems - 15-20% weightage',
          'studyTips': 'Understand gear ratios, practice belt drive calculations, know transmission types',
          'topics': [
            {
              'name': 'Belt Drives',
              'content': 'Flexible connector between pulleys. Types: Flat, V-belt, Timing belt. Velocity ratio: N₁/N₂ = D₂/D₁. Power = T×ω.',
              'examPoint': '⭐ Belt length calculation, tension ratio, power transmission capacity. Slip reduces efficiency.',
              'application': 'Industrial machinery, automotive systems, conveyor systems, and variable speed drives.'
            },
            {
              'name': 'Chain Drives',
              'content': 'Positive drive using chain and sprockets. No slip, constant velocity ratio. Higher power capacity than belts. Requires lubrication.',
              'examPoint': '⭐ Velocity ratio = N₁/N₂ = T₂/T₁ (teeth). Chain pitch, roller chain construction. Maintenance requirements.',
              'application': 'Motorcycles, bicycles, industrial machinery, and heavy-duty power transmission.'
            },
            {
              'name': 'Gear Drives',
              'content': 'Positive drive using toothed wheels. Velocity ratio = N₁/N₂ = T₂/T₁. Torque ratio = T₂/T₁ = T₂/T₁. High efficiency, compact.',
              'examPoint': '⭐ Gear ratio calculations, mechanical advantage. Module, pitch circle diameter. Speed and torque relationships.',
              'application': 'Automotive transmissions, machine tools, robotics, and precision machinery.'
            },
            {
              'name': 'Types of Gears',
              'content': 'Spur: Parallel axes. Helical: Inclined teeth, smoother. Bevel: Intersecting axes. Worm: High reduction ratio. Planetary: Compact, high ratio.',
              'examPoint': '⭐ Applications of each type. Advantages and disadvantages. Gear terminology: pitch, module, addendum, dedendum.',
              'application': 'Different applications based on space, ratio, and load requirements in mechanical systems.'
            },
            {
              'name': 'Gear Trains',
              'content': 'Series of gears for large speed reduction. Simple: Single stage. Compound: Multiple stages. Epicyclic: Planetary arrangement.',
              'examPoint': '⭐ Overall ratio = Product of individual ratios. Compound trains for high ratios. Direction of rotation.',
              'application': 'Automotive transmissions, clock mechanisms, heavy machinery, and precision instruments.'
            },
            {
              'name': 'Clutches & Brakes',
              'content': 'Clutch: Engages/disengages power transmission. Brake: Absorbs kinetic energy. Types: Friction, electromagnetic, hydraulic.',
              'examPoint': '⭐ Friction clutch torque capacity. Brake torque and stopping time calculations. Heat dissipation considerations.',
              'application': 'Automotive systems, industrial machinery, safety systems, and motion control applications.'
            },
          ],
        },
      ],
    },
    'BCE': {
      'fullName': 'Basic Civil Engineering',
      'icon': Icons.construction,
      'color': Colors.teal,
      'description': 'Building the world around us - Master construction, materials, surveying, and infrastructure systems!',
      'examTips': 'Focus on practical applications, understand construction processes, memorize material properties and standards.',
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Introduction to Civil Engineering',
          'importance': 'Foundation unit - 15-20% weightage in exams',
          'studyTips': 'Understand civil engineering scope, memorize building components, know foundation types',
          'topics': [
            {
              'name': 'Scope of Civil Engineering',
              'content': 'Branches: Structural, Geotechnical, Transportation, Water resources, Environmental, Construction management. Oldest engineering discipline.',
              'examPoint': '⭐ Major branches and their applications. Infrastructure development role. Public vs private sector projects.',
              'application': 'Urban planning, infrastructure development, disaster management, and sustainable construction practices.'
            },
            {
              'name': 'Role of Civil Engineers',
              'content': 'Design, construct, maintain infrastructure. Responsibilities: Planning, analysis, design, construction supervision, maintenance, project management.',
              'examPoint': '⭐ Professional ethics, safety considerations, environmental impact assessment. Licensing and certification requirements.',
              'application': 'Smart cities, green buildings, disaster-resistant structures, and sustainable infrastructure development.'
            },
            {
              'name': 'Building Components',
              'content': 'Foundation: Transfers loads to soil. Superstructure: Above ground portion. Components: Plinth, walls, floors, roof, doors, windows.',
              'examPoint': '⭐ Load path from roof to foundation. Structural vs non-structural elements. Building services integration.',
              'application': 'Residential buildings, commercial complexes, industrial structures, and high-rise construction.'
            },
            {
              'name': 'Foundation Types',
              'content': 'Shallow: Spread footings, mat foundation (depth < width). Deep: Piles, caissons (depth > width). Selection based on soil conditions and loads.',
              'examPoint': '⭐ Bearing capacity, settlement considerations. Foundation depth factors. Soil investigation importance.',
              'application': 'Skyscrapers, bridges, offshore structures, and earthquake-resistant construction.'
            },
            {
              'name': 'Superstructure',
              'content': 'Above-ground building portion. Systems: Frame (beams, columns), Load-bearing walls, Composite. Materials: RCC, steel, masonry.',
              'examPoint': '⭐ Structural systems comparison. Load transfer mechanisms. Lateral load resistance (wind, earthquake).',
              'application': 'Multi-story buildings, industrial structures, sports complexes, and architectural landmarks.'
            },
            {
              'name': 'Building Materials Overview',
              'content': 'Traditional: Stone, brick, timber, steel, concrete. Modern: Composites, smart materials, recycled materials. Properties: Strength, durability, sustainability.',
              'examPoint': '⭐ Material selection criteria. Cost-effectiveness, availability, environmental impact. Quality control standards.',
              'application': 'Green construction, prefabricated buildings, disaster-resistant structures, and sustainable architecture.'
            },
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Building Materials',
          'importance': 'Core materials knowledge - 25-30% weightage',
          'studyTips': 'Memorize material properties, understand testing methods, practice numerical problems',
          'topics': [
            {
              'name': 'Stones (Types & Properties)',
              'content': 'Types: Igneous (granite, basalt), Sedimentary (limestone, sandstone), Metamorphic (marble, slate). Properties: Strength, durability, workability, appearance.',
              'examPoint': '⭐ Compressive strength values, specific gravity, water absorption. Quarrying and dressing processes.',
              'application': 'Building facades, flooring, monuments, road construction, and decorative elements.'
            },
            {
              'name': 'Bricks (Manufacturing & Testing)',
              'content': 'Clay bricks: Molding, drying, burning. Types: Common, facing, engineering bricks. Tests: Compressive strength, water absorption, efflorescence.',
              'examPoint': '⭐ Standard brick size (190×90×90 mm), strength classes. Manufacturing defects and quality control.',
              'application': 'Masonry construction, partition walls, pavement, and architectural features.'
            },
            {
              'name': 'Cement (Types & Properties)',
              'content': 'Portland cement types: OPC 33, 43, 53 grade. Special cements: PPC, PSC, HAC. Properties: Setting time, soundness, strength development.',
              'examPoint': '⭐ Cement composition (C₃S, C₂S, C₃A, C₄AF), hydration process. Standard consistency, setting times.',
              'application': 'Concrete production, mortar preparation, grouting, and specialized construction applications.'
            },
            {
              'name': 'Concrete (Ingredients & Mix Design)',
              'content': 'Ingredients: Cement, fine aggregate, coarse aggregate, water. Mix design: Proportioning for required strength and workability. W/C ratio critical.',
              'examPoint': '⭐ Concrete grades (M15, M20, M25), mix proportions. Workability, segregation, bleeding. Curing importance.',
              'application': 'Structural elements, pavements, dams, bridges, and precast construction.'
            },
            {
              'name': 'Steel (Properties & Uses)',
              'content': 'Types: Mild steel, high-strength steel, stainless steel. Properties: High tensile strength, ductility, weldability. Reinforcement: TMT bars, HYSD bars.',
              'examPoint': '⭐ Yield strength, ultimate strength, elongation. Corrosion protection methods. Steel grades (Fe 415, Fe 500).',
              'application': 'Reinforced concrete, structural steelwork, bridges, and industrial construction.'
            },
            {
              'name': 'Timber (Types & Applications)',
              'content': 'Types: Hardwood (teak, sal), Softwood (pine, fir). Properties: Strength along grain, moisture content effects, durability. Seasoning: Natural, artificial.',
              'examPoint': '⭐ Moisture content limits, strength properties, defects (knots, shakes). Preservation treatments.',
              'application': 'Formwork, doors, windows, flooring, and temporary structures.'
            },
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Surveying',
          'importance': 'Measurement and mapping - 20-25% weightage',
          'studyTips': 'Practice calculations, understand instrument operations, memorize formulas and corrections',
          'topics': [
            {
              'name': 'Introduction to Surveying',
              'content': 'Art of measuring horizontal and vertical distances, angles, and elevations. Types: Plane surveying (small areas), Geodetic surveying (large areas).',
              'examPoint': '⭐ Surveying principles, classification, applications. Accuracy vs precision. Error types and sources.',
              'application': 'Land mapping, construction layout, property boundaries, and infrastructure planning.'
            },
            {
              'name': 'Chain Surveying',
              'content': 'Linear measurement using chain/tape. Principle: Triangulation. Equipment: Chain, arrows, ranging rods. Corrections: Slope, temperature, sag, tension.',
              'examPoint': '⭐ Chain length (20m, 30m), corrections formulas. Triangulation vs trilateration. Obstacles crossing methods.',
              'application': 'Small area surveys, property mapping, and preliminary site investigations.'
            },
            {
              'name': 'Compass Surveying',
              'content': 'Angular measurement using magnetic compass. Types: Prismatic, surveyor\'s compass. Bearings: Magnetic, true, grid. Declination correction.',
              'examPoint': '⭐ Bearing calculations, local attraction detection and correction. Traverse computations and adjustments.',
              'application': 'Route surveys, forest mapping, and areas where GPS is not available.'
            },
            {
              'name': 'Levelling',
              'content': 'Vertical distance measurement. Types: Simple, differential, profile, cross-section levelling. Equipment: Level, staff. Principle: Line of sight.',
              'examPoint': '⭐ Reduced level calculations, arithmetic check. Curvature and refraction corrections. Temporary and permanent adjustments.',
              'application': 'Road design, drainage systems, building construction, and topographic mapping.'
            },
            {
              'name': 'Theodolite Surveying',
              'content': 'Precise angular measurement instrument. Measures horizontal and vertical angles. Types: Transit, non-transit. Operations: Centering, leveling, focusing.',
              'examPoint': '⭐ Angle measurement procedures, temporary adjustments. Traversing methods and computations. Error elimination techniques.',
              'application': 'Triangulation surveys, construction layout, tunnel alignment, and precise engineering surveys.'
            },
            {
              'name': 'Contouring',
              'content': 'Representation of ground surface using contour lines. Methods: Direct, indirect. Characteristics: Contours never cross, closer spacing indicates steeper slope.',
              'examPoint': '⭐ Contour interval, interpolation methods. Uses of contour maps. Watershed and ridge line identification.',
              'application': 'Topographic mapping, site planning, drainage design, and earthwork calculations.'
            },
            {
              'name': 'Total Station',
              'content': 'Electronic instrument combining theodolite and EDM. Measures angles and distances simultaneously. Features: Data storage, coordinate calculation, remote operation.',
              'examPoint': '⭐ Advantages over conventional instruments. Coordinate geometry applications. Setting up and operation procedures.',
              'application': 'Modern surveying, construction stakeout, monitoring, and GIS data collection.'
            },
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Transportation Engineering',
          'importance': 'Infrastructure systems - 20-25% weightage',
          'studyTips': 'Understand design principles, memorize standards and specifications, practice geometric calculations',
          'topics': [
            {
              'name': 'Highway Engineering',
              'content': 'Planning, design, construction, and maintenance of roads. Components: Roadway, shoulders, medians, drainage. Design factors: Traffic, terrain, climate.',
              'examPoint': '⭐ Highway development process, feasibility studies. Traffic volume studies, capacity analysis. Design standards (IRC codes).',
              'application': 'National highways, expressways, urban roads, and intelligent transportation systems.'
            },
            {
              'name': 'Road Classification',
              'content': 'By function: Arterial, collector, local roads. By surface: Paved, unpaved. By location: Urban, rural. By administration: National, state, district roads.',
              'examPoint': '⭐ IRC classification system. Design standards for each category. Right of way requirements.',
              'application': 'Transportation planning, traffic management, and infrastructure development prioritization.'
            },
            {
              'name': 'Geometric Design of Roads',
              'content': 'Horizontal alignment: Curves, superelevation. Vertical alignment: Grades, vertical curves. Cross-section: Carriageway, shoulders, side slopes.',
              'examPoint': '⭐ Design speed, stopping sight distance, overtaking sight distance. Curve design formulas and standards.',
              'application': 'Safe and efficient road design, accident reduction, and traffic flow optimization.'
            },
            {
              'name': 'Pavement Types',
              'content': 'Flexible: Bituminous layers over granular base. Rigid: Concrete slab on base. Composite: Combination. Selection based on traffic and soil conditions.',
              'examPoint': '⭐ Pavement structure layers, load distribution mechanism. Design methods and thickness calculations.',
              'application': 'Highway construction, airport runways, industrial pavements, and urban road networks.'
            },
            {
              'name': 'Railway Engineering',
              'content': 'Track components: Rails, sleepers, ballast, formation. Gauge types: Broad (1676mm), meter (1000mm), narrow. Signaling and safety systems.',
              'examPoint': '⭐ Track geometry, curves and gradients. Station and yard design. Electrification systems.',
              'application': 'High-speed rail, metro systems, freight transportation, and urban transit.'
            },
            {
              'name': 'Airport Engineering',
              'content': 'Components: Runways, taxiways, aprons, terminals. Design factors: Aircraft characteristics, wind patterns, soil conditions. Lighting and navigation aids.',
              'examPoint': '⭐ Runway length calculations, pavement design for aircraft loads. Airport planning and layout principles.',
              'application': 'Commercial airports, military airfields, and general aviation facilities.'
            },
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Environmental Engineering',
          'importance': 'Sustainability focus - 15-20% weightage',
          'studyTips': 'Understand treatment processes, memorize quality standards, focus on environmental protection',
          'topics': [
            {
              'name': 'Water Supply Systems',
              'content': 'Sources: Surface (rivers, lakes), groundwater (wells, springs). Treatment: Screening, sedimentation, filtration, disinfection. Distribution: Gravity, pumping.',
              'examPoint': '⭐ Water demand estimation, distribution system design. Pipe materials and sizing. Quality standards (IS 10500).',
              'application': 'Municipal water supply, industrial water systems, and rural water schemes.'
            },
            {
              'name': 'Water Treatment',
              'content': 'Physical: Screening, sedimentation, filtration. Chemical: Coagulation, disinfection. Biological: Slow sand filters. Advanced: Membrane processes.',
              'examPoint': '⭐ Treatment unit design, detention times, loading rates. Chlorination process and residual chlorine.',
              'application': 'Water treatment plants, package treatment units, and point-of-use systems.'
            },
            {
              'name': 'Sewage & Sewerage',
              'content': 'Sewage: Liquid waste from communities. Sewerage: Collection and conveyance system. Types: Separate, combined, partially separate systems.',
              'examPoint': '⭐ Sewage quantity estimation, sewer design (Manning\'s formula). Manholes, pumping stations, and appurtenances.',
              'application': 'Urban drainage systems, industrial wastewater collection, and stormwater management.'
            },
            {
              'name': 'Wastewater Treatment',
              'content': 'Primary: Physical removal (screening, sedimentation). Secondary: Biological treatment (activated sludge, trickling filters). Tertiary: Advanced treatment.',
              'examPoint': '⭐ BOD, COD concepts. Treatment efficiency calculations. Sludge handling and disposal methods.',
              'application': 'Sewage treatment plants, industrial effluent treatment, and water recycling systems.'
            },
            {
              'name': 'Solid Waste Management',
              'content': 'Collection, transportation, processing, disposal of solid waste. Methods: Landfilling, incineration, composting, recycling. Waste characterization and quantification.',
              'examPoint': '⭐ Waste generation rates, collection systems design. Sanitary landfill design and operation.',
              'application': 'Municipal solid waste management, industrial waste handling, and waste-to-energy systems.'
            },
            {
              'name': 'Air Pollution Control',
              'content': 'Sources: Mobile, stationary, area sources. Pollutants: Particulates, gases. Control: Source control, dispersion, treatment. Monitoring and standards.',
              'examPoint': '⭐ Air quality standards, pollution control devices. Dispersion modelasics. Environmental impact assessment.',
              'application': 'Industrial emission control, urban air quality management, and climate change mitigation.'
            },
          ],
        },
      ],
    },
    'MATH': {
      'fullName': 'Mathematics',
      'icon': Icons.calculate,
      'color': Colors.blue,
      'description': 'Master essential mathematical concepts with formulas, theorems, and problem-solving techniques!',
      'examTips': 'Practice formula derivations, memorize key identities, solve previous year questions extensively.',
      'units': [
        {
          'number': 'Unit 1',
          'title': 'Calculus - Differentiation',
          'importance': 'Core unit - 25-30% weightage in exams',
          'studyTips': 'Practice chain rule, product rule extensively. Memorize standard derivatives.',
          'topics': [
            {
              'name': 'Basic Derivatives',
              'content': 'Fundamental differentiation rules and standard derivatives of common functions.',
              'examPoint': '⭐ Memorize: d/dx(xⁿ) = nxⁿ⁻¹, d/dx(eˣ) = eˣ, d/dx(ln x) = 1/x',
              'application': 'Rate of change problems, optimization, physics (velocity, acceleration).',
              'shortcuts': [
                {'title': '📐 Power Rule', 'content': r'\frac{d}{dx}(x^n) = nx^{n-1}', 'isFormula': true},
                {'title': '📐 Exponential', 'content': r'\frac{d}{dx}(e^x) = e^x', 'isFormula': true},
                {'title': '📐 Logarithm', 'content': r'\frac{d}{dx}(\ln x) = \frac{1}{x}', 'isFormula': true},
                {'title': '📐 Constant', 'content': r'\frac{d}{dx}(c) = 0', 'isFormula': true},
              ],
            },
            {
              'name': 'Trigonometric Derivatives',
              'content': 'Derivatives of sine, cosine, tangent and their inverses.',
              'examPoint': '⭐ sin→cos, cos→-sin, tan→sec². Remember signs!',
              'application': 'Wave motion, oscillations, signal processing.',
              'shortcuts': [
                {'title': '📐 Sine', 'content': r'\frac{d}{dx}(\sin x) = \cos x', 'isFormula': true},
                {'title': '📐 Cosine', 'content': r'\frac{d}{dx}(\cos x) = -\sin x', 'isFormula': true},
                {'title': '📐 Tangent', 'content': r'\frac{d}{dx}(\tan x) = \sec^2 x', 'isFormula': true},
                {'title': '📐 Cotangent', 'content': r'\frac{d}{dx}(\cot x) = -\csc^2 x', 'isFormula': true},
              ],
            },
            {
              'name': 'Chain Rule & Product Rule',
              'content': 'Composite function differentiation and product of functions.',
              'examPoint': '⭐ Chain: dy/dx = dy/du × du/dx. Product: (uv)\' = u\'v + uv\'',
              'application': 'Complex function analysis, related rates problems.',
              'shortcuts': [
                {'title': '📐 Chain Rule', 'content': r'\frac{d}{dx}f(g(x)) = f^{\prime}(g(x)) \cdot g^{\prime}(x)', 'isFormula': true},
                {'title': '📐 Product Rule', 'content': r'\frac{d}{dx}(uv) = u^{\prime}v + uv^{\prime}', 'isFormula': true},
                {'title': '📐 Quotient Rule', 'content': r'\frac{d}{dx}\left(\frac{u}{v}\right) = \frac{u^{\prime}v - uv^{\prime}}{v^2}', 'isFormula': true},
              ],
            },
          ],
        },
        {
          'number': 'Unit 2',
          'title': 'Calculus - Integration',
          'importance': 'High weightage - 25-30% in exams',
          'studyTips': 'Practice integration by parts, substitution method. Know standard integrals.',
          'topics': [
            {
              'name': 'Basic Integrals',
              'content': 'Fundamental integration formulas and techniques.',
              'examPoint': '⭐ Integration is reverse of differentiation. Don\'t forget +C constant!',
              'application': 'Area under curves, volume calculations, physics (displacement from velocity).',
              'shortcuts': [
                {'title': '📐 Power Rule', 'content': r'\int x^n dx = \frac{x^{n+1}}{n+1} + C \quad (n \neq -1)', 'isFormula': true},
                {'title': '📐 Exponential', 'content': r'\int e^x dx = e^x + C', 'isFormula': true},
                {'title': '📐 Reciprocal', 'content': r'\int \frac{1}{x} dx = \ln|x| + C', 'isFormula': true},
                {'title': '📐 Sine', 'content': r'\int \sin x dx = -\cos x + C', 'isFormula': true},
                {'title': '📐 Cosine', 'content': r'\int \cos x dx = \sin x + C', 'isFormula': true},
              ],
            },
            {
              'name': 'Definite Integrals',
              'content': 'Integration with limits, area calculation.',
              'examPoint': '⭐ Fundamental theorem: ∫ₐᵇ f(x)dx = F(b) - F(a)',
              'application': 'Area between curves, work done, probability distributions.',
              'shortcuts': [
                {'title': '📐 Fundamental Theorem', 'content': r'\int_a^b f(x) dx = F(b) - F(a)', 'isFormula': true},
                {'title': '📐 Area Formula', 'content': r'A = \int_a^b |f(x)| dx', 'isFormula': true},
                {'title': '⚡ Property', 'content': r'\int_a^b f(x) dx = -\int_b^a f(x) dx', 'isFormula': true},
              ],
            },
          ],
        },
        {
          'number': 'Unit 3',
          'title': 'Linear Algebra',
          'importance': 'Matrix operations - 20-25% weightage',
          'studyTips': 'Practice matrix multiplication, determinants, eigenvalue problems.',
          'topics': [
            {
              'name': 'Matrix Operations',
              'content': 'Addition, multiplication, transpose, inverse of matrices.',
              'examPoint': '⭐ AB ≠ BA (not commutative). (AB)ᵀ = BᵀAᵀ',
              'application': 'Linear transformations, computer graphics, data science.',
              'shortcuts': [
                {'title': '📐 Transpose', 'content': r'(AB)^T = B^T A^T', 'isFormula': true},
                {'title': '📐 Inverse', 'content': r'AA^{-1} = A^{-1}A = I', 'isFormula': true},
                {'title': '📐 Determinant', 'content': r'\det(AB) = \det(A) \cdot \det(B)', 'isFormula': true},
              ],
            },
            {
              'name': 'Eigenvalues & Eigenvectors',
              'content': 'Characteristic equation, eigenvalue decomposition.',
              'examPoint': '⭐ Av = λv. Characteristic equation: det(A - λI) = 0',
              'application': 'Principal component analysis, stability analysis, quantum mechanics.',
              'shortcuts': [
                {'title': '📐 Eigenvalue Equation', 'content': r'Av = \lambda v', 'isFormula': true},
                {'title': '📐 Characteristic Eq', 'content': r'\det(A - \lambda I) = 0', 'isFormula': true},
                {'title': '📐 Trace', 'content': r'\sum \lambda_i = \text{tr}(A)', 'isFormula': true},
              ],
            },
          ],
        },
        {
          'number': 'Unit 4',
          'title': 'Trigonometry',
          'importance': 'Identities & equations - 15-20% weightage',
          'studyTips': 'Memorize fundamental identities, practice angle transformations.',
          'topics': [
            {
              'name': 'Fundamental Identities',
              'content': 'Pythagorean, reciprocal, and quotient identities.',
              'examPoint': '⭐ sin²θ + cos²θ = 1, tan θ = sin θ/cos θ',
              'application': 'Wave analysis, signal processing, navigation.',
              'shortcuts': [
                {'title': '📐 Pythagorean', 'content': r'\sin^2\theta + \cos^2\theta = 1', 'isFormula': true},
                {'title': '📐 Tangent', 'content': r'\tan\theta = \frac{\sin\theta}{\cos\theta}', 'isFormula': true},
                {'title': '📐 Secant', 'content': r'1 + \tan^2\theta = \sec^2\theta', 'isFormula': true},
                {'title': '📐 Cosecant', 'content': r'1 + \cot^2\theta = \csc^2\theta', 'isFormula': true},
              ],
            },
            {
              'name': 'Sum & Difference Formulas',
              'content': 'Addition and subtraction angle formulas.',
              'examPoint': '⭐ sin(A±B) = sinA cosB ± cosA sinB',
              'application': 'Fourier analysis, AC circuit analysis.',
              'shortcuts': [
                {'title': '📐 Sin Sum', 'content': r'\sin(A+B) = \sin A \cos B + \cos A \sin B', 'isFormula': true},
                {'title': '📐 Cos Sum', 'content': r'\cos(A+B) = \cos A \cos B - \sin A \sin B', 'isFormula': true},
                {'title': '📐 Tan Sum', 'content': r'\tan(A+B) = \frac{\tan A + \tan B}{1 - \tan A \tan B}', 'isFormula': true},
              ],
            },
            {
              'name': 'Double & Half Angle Formulas',
              'content': 'Formulas for 2θ and θ/2 angles.',
              'examPoint': '⭐ sin 2θ = 2 sin θ cos θ, cos 2θ = cos²θ - sin²θ',
              'application': 'Power calculations in AC circuits, wave superposition.',
              'shortcuts': [
                {'title': '📐 Sin Double', 'content': r'\sin 2\theta = 2\sin\theta \cos\theta', 'isFormula': true},
                {'title': '📐 Cos Double', 'content': r'\cos 2\theta = \cos^2\theta - \sin^2\theta', 'isFormula': true},
                {'title': '📐 Cos Double Alt', 'content': r'\cos 2\theta = 2\cos^2\theta - 1 = 1 - 2\sin^2\theta', 'isFormula': true},
                {'title': '📐 Tan Double', 'content': r'\tan 2\theta = \frac{2\tan\theta}{1-\tan^2\theta}', 'isFormula': true},
              ],
            },
          ],
        },
        {
          'number': 'Unit 5',
          'title': 'Statistics & Probability',
          'importance': 'Data analysis - 15-20% weightage',
          'studyTips': 'Understand mean, median, mode. Practice probability problems.',
          'topics': [
            {
              'name': 'Measures of Central Tendency',
              'content': 'Mean, median, mode - central value representations.',
              'examPoint': '⭐ Mean = Σx/n, Median = middle value, Mode = most frequent',
              'application': 'Data analysis, machine learning, quality control.',
              'shortcuts': [
                {'title': '📐 Mean', 'content': r'\bar{x} = \frac{1}{n}\sum_{i=1}^n x_i', 'isFormula': true},
                {'title': '📐 Variance', 'content': r'\sigma^2 = \frac{1}{n}\sum_{i=1}^n (x_i - \bar{x})^2', 'isFormula': true},
                {'title': '📐 Std Deviation', 'content': r'\sigma = \sqrt{\frac{1}{n}\sum_{i=1}^n (x_i - \bar{x})^2}', 'isFormula': true},
              ],
            },
            {
              'name': 'Probability Basics',
              'content': 'Fundamental probability rules and theorems.',
              'examPoint': '⭐ P(A∪B) = P(A) + P(B) - P(A∩B), 0 ≤ P(E) ≤ 1',
              'application': 'Risk analysis, machine learning, game theory.',
              'shortcuts': [
                {'title': '📐 Addition Rule', 'content': r'P(A \cup B) = P(A) + P(B) - P(A \cap B)', 'isFormula': true},
                {'title': '📐 Multiplication', 'content': r'P(A \cap B) = P(A) \cdot P(B|A)', 'isFormula': true},
                {'title': '📐 Complement', 'content': r'P(A^c) = 1 - P(A)', 'isFormula': true},
                {'title': '📐 Bayes Theorem', 'content': r'P(A|B) = \frac{P(B|A) \cdot P(A)}{P(B)}', 'isFormula': true},
              ],
            },
          ],
        },
        {
          'number': 'Unit 6',
          'title': 'Differential Equations',
          'importance': 'Applied mathematics - 15-20% weightage',
          'studyTips': 'Learn separation of variables, integrating factor method.',
          'topics': [
            {
              'name': 'First Order Differential Equations',
              'content': 'Separable equations, linear equations, exact equations.',
              'examPoint': '⭐ dy/dx + P(x)y = Q(x). Integrating factor: e^(∫P dx)',
              'application': 'Population growth, radioactive decay, circuit analysis.',
              'shortcuts': [
                {'title': '📐 Separable', 'content': r'\frac{dy}{dx} = f(x)g(y) \Rightarrow \int\frac{dy}{g(y)} = \int f(x)dx', 'isFormula': true},
                {'title': '📐 Linear Form', 'content': r'\frac{dy}{dx} + P(x)y = Q(x)', 'isFormula': true},
                {'title': '📐 Integrating Factor', 'content': r'I.F. = e^{\int P(x)dx}', 'isFormula': true},
                {'title': '📐 Solution', 'content': r'y \cdot I.F. = \int Q(x) \cdot I.F. \, dx + C', 'isFormula': true},
              ],
            },
            {
              'name': 'Second Order Differential Equations',
              'content': 'Homogeneous and non-homogeneous linear equations.',
              'examPoint': '⭐ ay\'\' + by\' + cy = 0. Characteristic equation: am² + bm + c = 0',
              'application': 'Mechanical vibrations, electrical circuits, control systems.',
              'shortcuts': [
                {'title': '📐 Standard Form', 'content': r'a\frac{d^2y}{dx^2} + b\frac{dy}{dx} + cy = 0', 'isFormula': true},
                {'title': '📐 Characteristic Eq', 'content': r'am^2 + bm + c = 0', 'isFormula': true},
                {'title': '📐 General Solution', 'content': r'y = C_1e^{m_1x} + C_2e^{m_2x}', 'isFormula': true},
              ],
            },
          ],
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentSubject = syllabusData[_selectedSubject]!;
    final units = currentSubject['units'] as List<Map<String, dynamic>>;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Subject Syllabus',
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
        child: Column(
          children: [
            // Subject Dropdown
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSubject,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade900,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  items: syllabusData.keys.map((String key) {
                    final subject = syllabusData[key]!;
                    return DropdownMenuItem<String>(
                      value: key,
                      child: Row(
                        children: [
                          Icon(
                            subject['icon'] as IconData,
                            color: subject['color'] as Color,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$key - ${subject['fullName']}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSubject = newValue;
                      });
                    }
                  },
                ),
              ),
            ),

            // Syllabus Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Enhanced Header with Animations
                  AnimatedBuilder(
                    animation: _headerAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _headerAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (currentSubject['color'] as Color).withOpacity(0.8),
                                (currentSubject['color'] as Color).withOpacity(0.4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (currentSubject['color'] as Color).withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _pulseAnimation.value,
                                    child: Icon(
                                      currentSubject['icon'] as IconData,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              Text(
                                currentSubject['fullName'] as String,
                                style: GoogleFonts.orbitron(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(delay: 500.milliseconds).slideY(begin: 0.3),
                              const SizedBox(height: 5),
                              Text(
                                'Complete Syllabus - $_selectedSubject',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade200,
                                ),
                              ).animate().fadeIn(delay: 700.milliseconds).slideY(begin: 0.3),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Subject Description & Exam Tips
                  if (currentSubject['description'] != null || currentSubject['examTips'] != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.withOpacity(0.3),
                            Colors.purple.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.indigo.withOpacity(0.4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (currentSubject['description'] != null) ...[
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.lightBlue, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'About This Subject',
                                  style: GoogleFonts.orbitron(
                                    color: Colors.lightBlue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              currentSubject['description'] as String,
                              style: TextStyle(
                                color: Colors.lightBlue.shade100,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            if (currentSubject['examTips'] != null)
                              const SizedBox(height: 16),
                          ],
                          if (currentSubject['examTips'] != null) ...[
                            Row(
                              children: [
                                Icon(Icons.school, color: Colors.amber, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  'Exam Strategy',
                                  style: GoogleFonts.orbitron(
                                    color: Colors.amber,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.amber.withOpacity(0.3)),
                              ),
                              child: Text(
                                currentSubject['examTips'] as String,
                                style: TextStyle(
                                  color: Colors.amber.shade100,
                                  fontSize: 14,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ).animate().fadeIn(delay: 900.milliseconds).slideY(begin: 0.2),

                  // Units with staggered animations
                  ...units.map((unit) {
                    final index = units.indexOf(unit);
                    return _buildUnitCard(
                      unitNumber: unit['number'] as String,
                      unitTitle: unit['title'] as String,
                      topics: unit['topics'], // Can be List<String> or List<Map<String, dynamic>>
                      color: currentSubject['color'] as Color,
                      icon: currentSubject['icon'] as IconData,
                      importance: unit['importance'] as String?,
                      studyTips: unit['studyTips'] as String?,
                    ).animate().fadeIn(delay: Duration(milliseconds: 1000 + index * 200)).slideX(begin: index.isEven ? -0.3 : 0.3);
                  }).toList(),

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
                          'Study regularly and practice problems',
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Access resources from Home → Drawer Menu',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Bottom padding for nav bar
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
    required dynamic topics, // Changed to dynamic to handle both old and new format
    required Color color,
    required IconData icon,
    String? importance,
    String? studyTips,
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
          title: Row(
            children: [
              Expanded(
                child: Text(
                  unitNumber,
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (importance != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Text(
                    'HIGH PRIORITY',
                    style: TextStyle(
                      color: Colors.orange.shade200,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                unitTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (importance != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    importance,
                    style: TextStyle(
                      color: Colors.orange.shade300,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
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
                children: [
                  // Study Tips Section
                  if (studyTips != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0.2),
                            Colors.purple.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: Colors.amber, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Study Tips',
                                style: TextStyle(
                                  color: Colors.amber.shade200,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            studyTips,
                            style: TextStyle(
                              color: Colors.blue.shade100,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Topics Section
                  if (topics is List<Map<String, dynamic>>)
                    // Enhanced format with detailed content
                    ...topics.map<Widget>((topic) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: color.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Topic Name
                            Row(
                              children: [
                                Icon(Icons.star, color: color, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    topic['name'] ?? '',
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            
                            // Content
                            if (topic['content'] != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  topic['content'],
                                  style: TextStyle(
                                    color: Colors.grey.shade200,
                                    fontSize: 13,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            
                            // Exam Point
                            if (topic['examPoint'] != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                ),
                                child: Text(
                                  topic['examPoint'],
                                  style: TextStyle(
                                    color: Colors.red.shade200,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            
                            // Application
                            if (topic['application'] != null)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.engineering, color: Colors.green, size: 14),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Real-world Application:',
                                          style: TextStyle(
                                            color: Colors.green.shade300,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      topic['application'],
                                      style: TextStyle(
                                        color: Colors.green.shade100,
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // NEW: Limitations Section
                            if (topic['limitations'] != null)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange.withOpacity(0.15),
                                      Colors.red.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.orange.withOpacity(0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                                        const SizedBox(width: 6),
                                        Text(
                                          'Limitations:',
                                          style: TextStyle(
                                            color: Colors.orange.shade300,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      topic['limitations'],
                                      style: TextStyle(
                                        color: Colors.orange.shade100,
                                        fontSize: 11,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // NEW: Flowcharts Section
                            if (topic['flowcharts'] != null && (topic['flowcharts'] as List).isNotEmpty)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.cyan.withOpacity(0.15),
                                      Colors.blue.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.cyan.withOpacity(0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.account_tree, color: Colors.cyan, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          '📊 Flowcharts',
                                          style: TextStyle(
                                            color: Colors.cyan.shade200,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 200,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: (topic['flowcharts'] as List).length,
                                        itemBuilder: (context, index) {
                                          final flowchart = (topic['flowcharts'] as List)[index];
                                          return GestureDetector(
                                            onTap: () {
                                              // Show fullscreen zoom dialog
                                              showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                  backgroundColor: Colors.transparent,
                                                  insetPadding: const EdgeInsets.all(10),
                                                  child: Stack(
                                                    children: [
                                                      // Zoomable image
                                                      Center(
                                                        child: InteractiveViewer(
                                                          minScale: 0.5,
                                                          maxScale: 4.0,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: Colors.black,
                                                              borderRadius: BorderRadius.circular(12),
                                                              border: Border.all(color: Colors.cyan, width: 2),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(10),
                                                              child: Image.asset(
                                                                flowchart['path'],
                                                                fit: BoxFit.contain,
                                                                errorBuilder: (context, error, stackTrace) => Container(
                                                                  padding: const EdgeInsets.all(40),
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Icon(Icons.account_tree, color: Colors.cyan, size: 80),
                                                                      const SizedBox(height: 16),
                                                                      Text(flowchart['name'], style: TextStyle(color: Colors.white, fontSize: 18)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Close button
                                                      Positioned(
                                                        top: 20,
                                                        right: 20,
                                                        child: GestureDetector(
                                                          onTap: () => Navigator.pop(context),
                                                          child: Container(
                                                            padding: const EdgeInsets.all(8),
                                                            decoration: BoxDecoration(
                                                              color: Colors.red.withOpacity(0.8),
                                                              shape: BoxShape.circle,
                                                            ),
                                                            child: const Icon(Icons.close, color: Colors.white, size: 24),
                                                          ),
                                                        ),
                                                      ),
                                                      // Title
                                                      Positioned(
                                                        bottom: 20,
                                                        left: 20,
                                                        right: 20,
                                                        child: Container(
                                                          padding: const EdgeInsets.all(12),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.8),
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            flowchart['name'],
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                      // Zoom hint
                                                      Positioned(
                                                        top: 20,
                                                        left: 20,
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.6),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          child: const Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Icon(Icons.pinch, color: Colors.white70, size: 16),
                                                              SizedBox(width: 6),
                                                              Text('Pinch to zoom', style: TextStyle(color: Colors.white70, fontSize: 12)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                            width: 200,
                                            margin: const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                                        child: Image.asset(
                                                          flowchart['path'],
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (context, error, stackTrace) => Center(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.account_tree, color: Colors.cyan.withOpacity(0.5), size: 50),
                                                                const SizedBox(height: 8),
                                                                Text(flowchart['name'], style: TextStyle(color: Colors.cyan.shade300, fontSize: 12)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      // Tap to zoom indicator
                                                      Positioned(
                                                        top: 8,
                                                        right: 8,
                                                        child: Container(
                                                          padding: const EdgeInsets.all(4),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.6),
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child: Icon(Icons.zoom_in, color: Colors.cyan, size: 16),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.cyan.withOpacity(0.2),
                                                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                                                  ),
                                                  child: Text(
                                                    flowchart['name'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.cyan.shade100,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // NEW: Syntax Code Block Section
                            if (topic['syntax'] != null)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade700),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.code, color: Colors.amber, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          '💻 Syntax',
                                          style: TextStyle(
                                            color: Colors.amber.shade200,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'C',
                                            style: TextStyle(
                                              color: Colors.lightBlueAccent,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0D0D0D),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: SelectableText(
                                        topic['syntax'],
                                        style: GoogleFonts.firaCode(
                                          color: Colors.greenAccent.shade400,
                                          fontSize: 12,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            // NEW: Shortcuts & Quick Tips Section
                            if (topic['shortcuts'] != null && (topic['shortcuts'] as List).isNotEmpty)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.purple.withOpacity(0.15),
                                      Colors.pink.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.purple.withOpacity(0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.bolt, color: Colors.yellow, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          '⚡ Quick Shortcuts',
                                          style: TextStyle(
                                            color: Colors.purple.shade200,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: (topic['shortcuts'] as List).map<Widget>((shortcut) {
                                        final isFormula = shortcut['isFormula'] == true;
                                        return Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: isFormula 
                                                ? Colors.orange.withOpacity(0.5)
                                                : Colors.purple.withOpacity(0.3),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                shortcut['title'] ?? '',
                                                style: TextStyle(
                                                  color: isFormula ? Colors.orange.shade300 : Colors.purple.shade200,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              if (isFormula)
                                                Math.tex(
                                                  shortcut['content']?.replaceAll('...', '\\cdots') ?? '',
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                )
                                              else
                                                Text(
                                                  shortcut['content'] ?? '',
                                                  style: TextStyle(
                                                    color: Colors.grey.shade200,
                                                    fontSize: 12,
                                                    fontFamily: 'monospace',
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList()
                  else
                    // Fallback for old format (simple list)
                    ...(topics as List<String>).map((topic) {
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
