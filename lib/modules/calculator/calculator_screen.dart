import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 12,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F0F0F),
                const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
              ],
            ),
          ),
          child: Column(
            children: [
              // Custom Glass AppBar
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            'Quantum Calc',
                            style: GoogleFonts.orbitron(
                              color: Colors.cyanAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [Shadow(color: Colors.cyanAccent.withOpacity(0.5), blurRadius: 10)],
                            ),
                          ),
                        ],
                      ),
                    ),
                    TabBar(
                      isScrollable: true,
                      indicatorColor: Colors.cyanAccent,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 3,
                      labelColor: Colors.cyanAccent,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
                      unselectedLabelStyle: GoogleFonts.montserrat(),
                      tabs: const [
                        Tab(icon: Icon(Icons.access_time), text: 'Clock'),
                        Tab(icon: Icon(Icons.calculate), text: 'Calc'),
                        Tab(icon: Icon(Icons.swap_horiz), text: 'Convert'),
                        Tab(icon: Icon(Icons.currency_exchange), text: 'Currency'),
                        Tab(icon: Icon(Icons.school), text: 'CGPA'),
                        Tab(icon: Icon(Icons.monitor_weight), text: 'BMI'),
                        Tab(icon: Icon(Icons.cake), text: 'Age'),
                        Tab(icon: Icon(Icons.functions), text: 'Equation'),
                        Tab(icon: Icon(Icons.percent), text: 'Percent'),
                        Tab(icon: Icon(Icons.local_offer), text: 'Discount'),
                        Tab(icon: Icon(Icons.restaurant), text: 'Tip'),
                        Tab(icon: Icon(Icons.account_balance), text: 'Loan'),
                      ],
                    ),
                  ],
                ),
              ),
              // Body
              const Expanded(
                child: TabBarView(
                  children: [
                    _RealTimeClockTab(),
                    _ScientificCalculatorTab(),
                    _ConverterTab(),
                    _CurrencyConverterTab(),
                    _CGPATab(),
                    _BMITab(),
                    _AgeCalculatorTab(),
                    _EquationSolverTab(),
                    _PercentageTab(),
                    _DiscountCalculatorTab(),
                    _TipCalculatorTab(),
                    _LoanCalculatorTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================
// TAB 1: Real-Time Clock
// ============================================
class _RealTimeClockTab extends StatefulWidget {
  const _RealTimeClockTab();

  @override
  State<_RealTimeClockTab> createState() => _RealTimeClockTabState();
}

class _RealTimeClockTabState extends State<_RealTimeClockTab> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: _timeStream,
      builder: (context, snapshot) {
        final now = snapshot.data ?? DateTime.now();
        final hour = now.hour;
        final minute = now.minute;
        final second = now.second;
        final day = now.day;
        final month = _getMonthName(now.month);
        final year = now.year;
        final weekday = _getWeekdayName(now.weekday);
        
        // 12-hour format
        final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
        final period = hour >= 12 ? 'PM' : 'AM';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              
              // Holographic Clock Container
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.cyanAccent.withOpacity(0.1),
                      Colors.purpleAccent.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${hour12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
                          style: GoogleFonts.orbitron(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                            shadows: [
                              Shadow(color: Colors.cyanAccent, blurRadius: 20),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                         Text(
                           period,
                           style: GoogleFonts.orbitron(
                             fontSize: 24,
                             fontWeight: FontWeight.bold,
                             color: Colors.cyanAccent,
                           ),
                         ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                       '${second.toString().padLeft(2, '0')} seconds',
                       style: GoogleFonts.montserrat(
                         fontSize: 16,
                         color: Colors.white54,
                         fontWeight: FontWeight.w500,
                         letterSpacing: 2,
                       ),
                     ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Date Display
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Text(
                      weekday.toUpperCase(),
                      style: GoogleFonts.orbitron(
                        fontSize: 28,
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '$day $month $year',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Time Info Cards
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Hour',
                      hour.toString(),
                      Icons.access_time,
                      Colors.purpleAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      'Minute',
                      minute.toString(),
                      Icons.timer,
                      Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildInfoCard(
                      'Second',
                      second.toString(),
                      Icons.timelapse,
                      Colors.greenAccent,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Additional Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Day of Year', _getDayOfYear(now).toString()),
                    Divider(color: Colors.white.withOpacity(0.1)),
                    _buildDetailRow('Week of Year', _getWeekOfYear(now).toString()),
                    Divider(color: Colors.white.withOpacity(0.1)),
                    _buildDetailRow('Days in Month', _getDaysInMonth(now).toString()),
                    Divider(color: Colors.white.withOpacity(0.1)),
                    _buildDetailRow('Timezone', now.timeZoneName),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  int _getDayOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    return date.difference(firstDayOfYear).inDays + 1;
  }

  int _getWeekOfYear(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  int _getDaysInMonth(DateTime date) {
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    final lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }
}

// ============================================
// TAB 2: Scientific Calculator
// ============================================
class _ScientificCalculatorTab extends StatefulWidget {
  const _ScientificCalculatorTab();

  @override
  State<_ScientificCalculatorTab> createState() => _ScientificCalculatorTabState();
}

class _ScientificCalculatorTabState extends State<_ScientificCalculatorTab> {
  String _expression = '';
  String _result = '0';
  bool _isDegrees = true;
  List<String> _history = [];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '0';
      } else if (value == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        _evaluateExpression();
      } else if (value == 'DEG/RAD') {
        _isDegrees = !_isDegrees;
      } else if (value == '√') {
        _expression += 'sqrt(';
      } else if (value == 'sin') {
        _expression += 'sin(';
      } else if (value == 'cos') {
        _expression += 'cos(';
      } else if (value == 'tan') {
        _expression += 'tan(';
      } else if (value == 'log') {
        _expression += 'log(';
      } else if (value == 'ln') {
        _expression += 'ln(';
      } else if (value == '^') {
        _expression += '^';
      } else if (value == 'π') {
        _expression += 'π';
      } else if (value == 'e') {
        _expression += 'e';
      } else {
        _expression += value;
      }
    });
  }

  void _evaluateExpression() {
    try {
      String expr = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString());
      
      if (_isDegrees) {
        expr = _convertDegreesToRadians(expr);
      }
      
      Parser parser = Parser();
      Expression exp = parser.parse(expr);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      
      if (eval % 1 == 0) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
      
      _history.insert(0, '$_expression = $_result');
      if (_history.length > 10) _history.removeLast();
    } catch (e) {
      _result = 'Error';
    }
  }

  String _convertDegreesToRadians(String expr) {
    final degToRad = math.pi / 180;
    expr = expr.replaceAllMapped(
      RegExp(r'sin\(([^)]+)\)'),
      (match) => 'sin((${match.group(1)})*$degToRad)',
    );
    expr = expr.replaceAllMapped(
      RegExp(r'cos\(([^)]+)\)'),
      (match) => 'cos((${match.group(1)})*$degToRad)',
    );
    expr = expr.replaceAllMapped(
      RegExp(r'tan\(([^)]+)\)'),
      (match) => 'tan((${match.group(1)})*$degToRad)',
    );
    return expr;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // LCD Screen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F0F).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'QUANTUM MATH OS',
                      style: GoogleFonts.orbitron(
                        fontSize: 10,
                        color: Colors.cyanAccent.withOpacity(0.5),
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _isDegrees ? 'DEG' : 'RAD',
                        style: GoogleFonts.orbitron(
                          fontSize: 10,
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  _expression.isEmpty ? '0' : _expression,
                  style: GoogleFonts.orbitron(
                    fontSize: 20,
                    color: Colors.white54,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _result,
                    style: GoogleFonts.orbitron(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        // Keypad
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Column(
            children: [
              _buildRow(['sin', 'cos', 'tan', 'DEG/RAD'], isScientific: true),
              const SizedBox(height: 12),
              _buildRow(['log', 'ln', '√', '^'], isScientific: true),
              const SizedBox(height: 12),
              _buildRow(['π', 'e', '(', ')'], isScientific: true),
              const SizedBox(height: 12),
              _buildRow(['AC', 'DEL', '%', '÷'], isFunction: true),
              const SizedBox(height: 12),
              _buildRow(['7', '8', '9', '×']),
              const SizedBox(height: 12),
              _buildRow(['4', '5', '6', '-']),
              const SizedBox(height: 12),
              _buildRow(['1', '2', '3', '+']),
              const SizedBox(height: 12),
              _buildRow(['0', '.', '=', '=']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(List<String> labels, {bool isScientific = false, bool isFunction = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        return _buildButton(label, isScientific: isScientific, isFunction: isFunction);
      }).toList(),
    );
  }

  Widget _buildButton(String label, {bool isScientific = false, bool isFunction = false}) {
    bool isOperator = ['÷', '×', '-', '+', '%'].contains(label);
    bool isEquals = label == '=';
    bool isSpecialFunction = ['AC', 'DEL'].contains(label);
    
    Color textColor;
    if (isEquals) {
      textColor = Colors.black;
    } else if (isScientific) {
      textColor = Colors.cyanAccent;
    } else if (isSpecialFunction) {
      textColor = Colors.redAccent;
    } else if (isFunction || isOperator) {
      textColor = Colors.orangeAccent;
    } else {
      textColor = Colors.white;
    }

    // Double width for equals if needed, roughly
    double width = (MediaQuery.of(context).size.width - 70) / 4;
    // For the last row with double =, we handle it blindly or intelligently? 
    // The previous code had two '=' in the list to fake it? 
    // Ah, line 560: `['0', '.', '=', '=']`. Let's assume standard grid.
    if (label == '=' && labelsContainTwoEquals()) { width = width * 2 + 12; } 
    // Actually simpler: just follow standard grid. 
    
    return InkWell(
      onTap: () {
        // Haptic feedback
        // HapticFeedback.lightImpact(); // Needs flutter/services.dart
        _onButtonPressed(label);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: width,
        height: 60,
        decoration: BoxDecoration(
          color: isEquals ? Colors.cyanAccent : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEquals ? Colors.cyanAccent : Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: isEquals ? [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.orbitron(
              fontSize: label.length > 3 ? 12 : 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  // Helper just for this context
  bool labelsContainTwoEquals() => false; // Dummy, logic handled by list structure from previous code
}

// ============================================
// TAB 2: Unit Converter
// ============================================
class _ConverterTab extends StatefulWidget {
  const _ConverterTab();

  @override
  State<_ConverterTab> createState() => _ConverterTabState();
}

class _ConverterTabState extends State<_ConverterTab> {
  String _category = 'Length';
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  final TextEditingController _inputController = TextEditingController();
  String _output = '0';

  final Map<String, Map<String, double>> _conversions = {
    'Length': {
      'Meter': 1.0,
      'Kilometer': 0.001,
      'Centimeter': 100.0,
      'Mile': 0.000621371,
      'Foot': 3.28084,
      'Inch': 39.3701,
    },
    'Mass': {
      'Kilogram': 1.0,
      'Gram': 1000.0,
      'Pound': 2.20462,
      'Ounce': 35.274,
      'Ton': 0.001,
    },
    'Temperature': {
      'Celsius': 1.0,
      'Fahrenheit': 1.0,
      'Kelvin': 1.0,
    },
    'Speed': {
      'Meter/Second': 1.0,
      'Kilometer/Hour': 3.6,
      'Mile/Hour': 2.23694,
      'Knot': 1.94384,
    },
    'Area': {
      'Square Meter': 1.0,
      'Square Kilometer': 0.000001,
      'Square Foot': 10.7639,
      'Acre': 0.000247105,
    },
  };

  void _convert() {
    final input = double.tryParse(_inputController.text) ?? 0;
    double result = 0;

    if (_category == 'Temperature') {
      result = _convertTemperature(input, _fromUnit, _toUnit);
    } else {
      final baseValue = input / _conversions[_category]![_fromUnit]!;
      result = baseValue * _conversions[_category]![_toUnit]!;
    }

    setState(() {
      _output = result.toStringAsFixed(4).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    });
  }

  double _convertTemperature(double value, String from, String to) {
    double celsius = value;
    if (from == 'Fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (from == 'Kelvin') {
      celsius = value - 273.15;
    }

    if (to == 'Fahrenheit') {
      return celsius * 9 / 5 + 32;
    } else if (to == 'Kelvin') {
      return celsius + 273.15;
    }
    return celsius;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: DropdownButton<String>(
              value: _category,
              isExpanded: true,
              dropdownColor: Colors.grey.shade900,
              underline: const SizedBox(),
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
              items: _conversions.keys
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _category = val!;
                  _fromUnit = _conversions[_category]!.keys.first;
                  _toUnit = _conversions[_category]!.keys.toList()[1];
                  _output = '0';
                });
              },
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From:', style: GoogleFonts.montserrat(color: Colors.grey)),
                const SizedBox(height: 8),
                TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (_) => _convert(),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _fromUnit,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  underline: const SizedBox(),
                  style: GoogleFonts.montserrat(color: Colors.cyanAccent),
                  items: _conversions[_category]!
                      .keys
                      .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _fromUnit = val!;
                      _convert();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.arrow_downward, color: Colors.cyanAccent, size: 30),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF9EA792),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To:', style: GoogleFonts.montserrat(color: Colors.black54)),
                const SizedBox(height: 8),
                Text(
                  _output,
                  style: GoogleFonts.orbitron(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _toUnit,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  underline: const SizedBox(),
                  style: GoogleFonts.montserrat(color: Colors.black87, fontWeight: FontWeight.bold),
                  items: _conversions[_category]!
                      .keys
                      .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _toUnit = val!;
                      _convert();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 3: Currency Converter
// ============================================
class _CurrencyConverterTab extends StatefulWidget {
  const _CurrencyConverterTab();

  @override
  State<_CurrencyConverterTab> createState() => _CurrencyConverterTabState();
}

class _CurrencyConverterTabState extends State<_CurrencyConverterTab> {
  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  final TextEditingController _inputController = TextEditingController(text: '1');
  String _output = '83.12';

  final Map<String, Map<String, dynamic>> _currencies = {
    'USD': {'name': 'US Dollar', 'rate': 1.0, 'symbol': '\$'},
    'EUR': {'name': 'Euro', 'rate': 0.92, 'symbol': '€'},
    'GBP': {'name': 'British Pound', 'rate': 0.79, 'symbol': '£'},
    'INR': {'name': 'Indian Rupee', 'rate': 83.12, 'symbol': '₹'},
    'JPY': {'name': 'Japanese Yen', 'rate': 149.50, 'symbol': '¥'},
    'AUD': {'name': 'Australian Dollar', 'rate': 1.52, 'symbol': 'A\$'},
    'CAD': {'name': 'Canadian Dollar', 'rate': 1.36, 'symbol': 'C\$'},
  };

  void _convert() {
    final input = double.tryParse(_inputController.text) ?? 0;
    final fromRate = _currencies[_fromCurrency]!['rate'] as double;
    final toRate = _currencies[_toCurrency]!['rate'] as double;
    final usdAmount = input / fromRate;
    final result = usdAmount * toRate;
    setState(() {
      _output = result.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _convert(),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: _fromCurrency,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  items: _currencies.keys.map((code) {
                    return DropdownMenuItem(
                      value: code,
                      child: Text('$code - ${_currencies[code]!['name']}'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _fromCurrency = val!;
                      _convert();
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.arrow_downward, color: Colors.cyanAccent, size: 30),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent),
            ),
            child: Column(
              children: [
                Text(
                  _output,
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: _toCurrency,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  items: _currencies.keys.map((code) {
                    return DropdownMenuItem(
                      value: code,
                      child: Text('$code - ${_currencies[code]!['name']}'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _toCurrency = val!;
                      _convert();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 4: CGPA Calculator
// ============================================
class _CGPATab extends StatefulWidget {
  const _CGPATab();

  @override
  State<_CGPATab> createState() => _CGPATabState();
}

class _CGPATabState extends State<_CGPATab> {
  final List<Map<String, dynamic>> _subjects = [];

  final Map<String, int> _gradePoints = {
    'O': 10,
    'A+': 9,
    'A': 8,
    'B+': 7,
    'B': 6,
    'C': 5,
    'F': 0,
  };

  void _addSubject() {
    setState(() {
      _subjects.add({
        'name': 'Subject ${_subjects.length + 1}',
        'credits': 3,
        'grade': 'A',
      });
    });
  }

  double _calculateSGPA() {
    if (_subjects.isEmpty) return 0.0;
    
    double totalPoints = 0;
    int totalCredits = 0;

    for (var subject in _subjects) {
      final credits = subject['credits'] as int;
      final grade = subject['grade'] as String;
      final points = _gradePoints[grade] ?? 0;
      
      totalPoints += credits * points;
      totalCredits += credits;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final sgpa = _calculateSGPA();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyanAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.3)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Column(
            children: [
              Text(
                'Your SGPA',
                style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                sgpa.toStringAsFixed(2),
                style: GoogleFonts.orbitron(
                  color: Colors.cyanAccent,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _subjects.isEmpty
              ? Center(
                  child: Text(
                    'Add subjects to calculate SGPA',
                    style: GoogleFonts.montserrat(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    return Card(
                      color: Colors.grey.shade900,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Subject Name',
                                  hintStyle: TextStyle(color: Colors.grey.shade600),
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    subject['name'] = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<int>(
                              value: subject['credits'],
                              dropdownColor: Colors.grey.shade800,
                              underline: const SizedBox(),
                              items: [1, 2, 3, 4, 5]
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text('$c', style: const TextStyle(color: Colors.white)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  subject['credits'] = val!;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: subject['grade'],
                              dropdownColor: Colors.grey.shade800,
                              underline: const SizedBox(),
                              items: _gradePoints.keys
                                  .map((g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g, style: const TextStyle(color: Colors.cyanAccent)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  subject['grade'] = val!;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _subjects.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: _addSubject,
            icon: const Icon(Icons.add),
            label: const Text('Add Subject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}


// ============================================
// TAB 4: BMI Calculator
// ============================================
class _BMITab extends StatefulWidget {
  const _BMITab();

  @override
  State<_BMITab> createState() => _BMITabState();
}

class _BMITabState extends State<_BMITab> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  String _category = '';
  String _unit = 'Metric';

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double bmi;
      if (_unit == 'Metric') {
        bmi = weight / ((height / 100) * (height / 100));
      } else {
        bmi = (weight / (height * height)) * 703;
      }

      setState(() {
        _bmi = bmi;
        if (bmi < 18.5) {
          _category = 'Underweight';
        } else if (bmi < 25) {
          _category = 'Normal';
        } else if (bmi < 30) {
          _category = 'Overweight';
        } else {
          _category = 'Obese';
        }
      });
    }
  }

  Color _getCategoryColor() {
    switch (_category) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Metric', label: Text('Metric (kg/cm)')),
              ButtonSegment(value: 'Imperial', label: Text('Imperial (lb/in)')),
            ],
            selected: {_unit},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.cyanAccent.withOpacity(0.2);
                  }
                  return Colors.transparent;
                },
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.cyanAccent;
                  }
                  return Colors.grey;
                },
              ),
            ),
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _unit = newSelection.first;
                _heightController.clear();
                _weightController.clear();
                _bmi = 0;
                _category = '';
              });
            },
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildBMIInput(_heightController, _unit == 'Metric' ? 'Height (cm)' : 'Height (inches)'),
                const SizedBox(height: 20),
                _buildBMIInput(_weightController, _unit == 'Metric' ? 'Weight (kg)' : 'Weight (lbs)'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (_bmi > 0)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_getCategoryColor().withOpacity(0.3), _getCategoryColor().withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _getCategoryColor(), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _getCategoryColor().withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'YOUR BMI',
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 16, letterSpacing: 2),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: GoogleFonts.orbitron(
                      color: _getCategoryColor(),
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: _getCategoryColor(), blurRadius: 10)],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _category.toUpperCase(),
                      style: GoogleFonts.orbitron(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMI CATEGORIES:',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 15),
                _buildBMICategory('Underweight', '< 18.5', Colors.blue),
                _buildBMICategory('Normal', '18.5 - 24.9', Colors.green),
                _buildBMICategory('Overweight', '25 - 29.9', Colors.orange),
                _buildBMICategory('Obese', '≥ 30', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMIInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.cyanAccent),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
      ),
      onChanged: (_) => _calculateBMI(),
    );
  }

  Widget _buildBMICategory(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 5)],
            ),
          ),
          const SizedBox(width: 15),
          Text(
            '$label: ',
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            range,
            style: GoogleFonts.orbitron(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 5: Age Calculator
// ============================================
class _AgeCalculatorTab extends StatefulWidget {
  const _AgeCalculatorTab();

  @override
  State<_AgeCalculatorTab> createState() => _AgeCalculatorTabState();
}

class _AgeCalculatorTabState extends State<_AgeCalculatorTab> {
  DateTime? _birthDate;
  DateTime _currentDate = DateTime.now();
  Map<String, int> _age = {};

  void _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF2A2A2A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    if (_birthDate == null) return;

    int years = _currentDate.year - _birthDate!.year;
    int months = _currentDate.month - _birthDate!.month;
    int days = _currentDate.day - _birthDate!.day;

    if (days < 0) {
      months--;
      days += DateTime(_currentDate.year, _currentDate.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDays = _currentDate.difference(_birthDate!).inDays;
    final totalWeeks = (totalDays / 7).floor();
    final totalMonths = years * 12 + months;

    setState(() {
      _age = {
        'years': years,
        'months': months,
        'days': days,
        'totalDays': totalDays,
        'totalWeeks': totalWeeks,
        'totalMonths': totalMonths,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Birth Date',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  _birthDate == null
                      ? 'Not Selected'
                      : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _selectBirthDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Select Birth Date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          if (_age.isNotEmpty) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.cyanAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent),
              ),
              child: Column(
                children: [
                  Text(
                    'Your Age',
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAgeBox('${_age['years']}', 'Years'),
                      _buildAgeBox('${_age['months']}', 'Months'),
                      _buildAgeBox('${_age['days']}', 'Days'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Total Months', '${_age['totalMonths']}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Weeks', '${_age['totalWeeks']}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Days', '${_age['totalDays']}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Hours', '${_age['totalDays']! * 24}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Minutes', '${_age['totalDays']! * 24 * 60}'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgeBox(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 6: Equation Solver (Quadratic)
// ============================================
class _EquationSolverTab extends StatefulWidget {
  const _EquationSolverTab();

  @override
  State<_EquationSolverTab> createState() => _EquationSolverTabState();
}

class _EquationSolverTabState extends State<_EquationSolverTab> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  
  String _solution = '';
  String _steps = '';

  void _solveEquation() {
    final a = double.tryParse(_aController.text) ?? 0;
    final b = double.tryParse(_bController.text) ?? 0;
    final c = double.tryParse(_cController.text) ?? 0;

    if (a == 0) {
      setState(() {
        _solution = 'Error: a cannot be 0';
        _steps = '';
      });
      return;
    }

    final discriminant = b * b - 4 * a * c;
    
    String solution;
    String steps = 'Equation: ${a}x² + ${b}x + $c = 0\n\n';
    steps += 'Discriminant (Δ) = b² - 4ac\n';
    steps += 'Δ = (${b})² - 4(${a})(${c})\n';
    steps += 'Δ = ${discriminant.toStringAsFixed(2)}\n\n';

    if (discriminant > 0) {
      final x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      final x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      solution = 'Two Real Solutions:\nx₁ = ${x1.toStringAsFixed(4)}\nx₂ = ${x2.toStringAsFixed(4)}';
      steps += 'Since Δ > 0, two real solutions exist.\n\n';
      steps += 'x = (-b ± √Δ) / 2a\n';
      steps += 'x₁ = (${-b} + ${math.sqrt(discriminant).toStringAsFixed(2)}) / ${2 * a}\n';
      steps += 'x₂ = (${-b} - ${math.sqrt(discriminant).toStringAsFixed(2)}) / ${2 * a}';
    } else if (discriminant == 0) {
      final x = -b / (2 * a);
      solution = 'One Real Solution:\nx = ${x.toStringAsFixed(4)}';
      steps += 'Since Δ = 0, one real solution exists.\n\n';
      steps += 'x = -b / 2a\n';
      steps += 'x = ${-b} / ${2 * a}';
    } else {
      final realPart = -b / (2 * a);
      final imagPart = math.sqrt(-discriminant) / (2 * a);
      solution = 'Two Complex Solutions:\nx₁ = ${realPart.toStringAsFixed(4)} + ${imagPart.toStringAsFixed(4)}i\nx₂ = ${realPart.toStringAsFixed(4)} - ${imagPart.toStringAsFixed(4)}i';
      steps += 'Since Δ < 0, two complex solutions exist.\n\n';
      steps += 'x = (-b ± i√|Δ|) / 2a';
    }

    setState(() {
      _solution = solution;
      _steps = steps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quadratic Equation Solver',
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ax² + bx + c = 0',
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _aController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          labelText: 'a',
                          labelStyle: TextStyle(color: Colors.cyanAccent, fontSize: 24),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _bController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          labelText: 'b',
                          labelStyle: TextStyle(color: Colors.cyanAccent, fontSize: 24),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _cController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          labelText: 'c',
                          labelStyle: TextStyle(color: Colors.cyanAccent, fontSize: 24),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _solveEquation,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Solve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
          if (_solution.isNotEmpty) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.3), Colors.teal.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solution:',
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _solution,
                    style: GoogleFonts.orbitron(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steps:',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _steps,
                    style: GoogleFonts.robotoMono(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================
// TAB 7: Percentage Calculator
// ============================================
class _PercentageTab extends StatefulWidget {
  const _PercentageTab();

  @override
  State<_PercentageTab> createState() => _PercentageTabState();
}

class _PercentageTabState extends State<_PercentageTab> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  
  double _percentOfValue = 0;
  double _percentageResult = 0;
  double _increaseResult = 0;
  double _decreaseResult = 0;

  void _calculate() {
    final value = double.tryParse(_valueController.text) ?? 0;
    final percent = double.tryParse(_percentController.text) ?? 0;
    final total = double.tryParse(_totalController.text) ?? 0;

    setState(() {
      _percentOfValue = (percent / 100) * value;
      _percentageResult = total > 0 ? (value / total) * 100 : 0;
      _increaseResult = value + (value * percent / 100);
      _decreaseResult = value - (value * percent / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // What is X% of Y?
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is X% of Y?',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _percentController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Percent (%)',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('of', style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _valueController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9EA792),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Result:',
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _percentOfValue.toStringAsFixed(2),
                        style: GoogleFonts.orbitron(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // X is what % of Y?
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'X is what % of Y?',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _valueController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('of', style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _totalController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Total',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9EA792),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Result:',
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_percentageResult.toStringAsFixed(2)}%',
                        style: GoogleFonts.orbitron(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Increase/Decrease by %
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Increase/Decrease by %',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.arrow_upward, color: Colors.green),
                            const SizedBox(height: 8),
                            Text(
                              'Increase',
                              style: GoogleFonts.montserrat(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _increaseResult.toStringAsFixed(2),
                              style: GoogleFonts.orbitron(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.arrow_downward, color: Colors.red),
                            const SizedBox(height: 8),
                            Text(
                              'Decrease',
                              style: GoogleFonts.montserrat(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _decreaseResult.toStringAsFixed(2),
                              style: GoogleFonts.orbitron(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 9: Discount Calculator
// ============================================
class _DiscountCalculatorTab extends StatefulWidget {
  const _DiscountCalculatorTab();

  @override
  State<_DiscountCalculatorTab> createState() => _DiscountCalculatorTabState();
}

class _DiscountCalculatorTabState extends State<_DiscountCalculatorTab> {
  final TextEditingController _originalPriceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  
  double _discountAmount = 0;
  double _finalPrice = 0;

  void _calculate() {
    final originalPrice = double.tryParse(_originalPriceController.text) ?? 0;
    final discountPercent = double.tryParse(_discountController.text) ?? 0;

    setState(() {
      _discountAmount = originalPrice * (discountPercent / 100);
      _finalPrice = originalPrice - _discountAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _originalPriceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  decoration: const InputDecoration(
                    labelText: 'Original Price (\$)',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _calculate(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  decoration: const InputDecoration(
                    labelText: 'Discount (%)',
                    labelStyle: TextStyle(color: Colors.red),
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (_finalPrice > 0) ...[
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Final Price',
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${_finalPrice.toStringAsFixed(2)}',
                    style: GoogleFonts.orbitron(
                      color: Colors.greenAccent,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Original Price',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      Text(
                        '\$${_originalPriceController.text}',
                        style: GoogleFonts.orbitron(color: Colors.white),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      Text(
                        '- \$${_discountAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.orbitron(color: Colors.red),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You Save',
                        style: GoogleFonts.montserrat(color: Colors.white70),
                      ),
                      Text(
                        '\$${_discountAmount.toStringAsFixed(2)}',
                        style: GoogleFonts.orbitron(color: Colors.greenAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================
// TAB 10: Tip Calculator
// ============================================
class _TipCalculatorTab extends StatefulWidget {
  const _TipCalculatorTab();

  @override
  State<_TipCalculatorTab> createState() => _TipCalculatorTabState();
}

class _TipCalculatorTabState extends State<_TipCalculatorTab> {
  final TextEditingController _billController = TextEditingController();
  double _tipPercent = 15;
  int _splitCount = 1;
  
  double _tipAmount = 0;
  double _totalAmount = 0;
  double _perPerson = 0;

  void _calculate() {
    final bill = double.tryParse(_billController.text) ?? 0;
    
    setState(() {
      _tipAmount = bill * (_tipPercent / 100);
      _totalAmount = bill + _tipAmount;
      _perPerson = _splitCount > 0 ? _totalAmount / _splitCount : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bill Amount',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _billController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(color: Colors.cyanAccent, fontSize: 32),
                    border: InputBorder.none,
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tip Percentage',
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '${_tipPercent.toInt()}%',
                      style: GoogleFonts.orbitron(
                        color: Colors.cyanAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _tipPercent,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  activeColor: Colors.cyanAccent,
                  inactiveColor: Colors.grey,
                  onChanged: (val) {
                    setState(() {
                      _tipPercent = val;
                      _calculate();
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [10, 15, 18, 20, 25].map((percent) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _tipPercent = percent.toDouble();
                          _calculate();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _tipPercent == percent 
                              ? Colors.cyanAccent 
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$percent%',
                          style: TextStyle(
                            color: _tipPercent == percent 
                                ? Colors.black 
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Split Between',
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_splitCount > 1) {
                              setState(() {
                                _splitCount--;
                                _calculate();
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                        ),
                        Text(
                          '$_splitCount',
                          style: GoogleFonts.orbitron(
                            color: Colors.cyanAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _splitCount++;
                              _calculate();
                            });
                          },
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyanAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent),
            ),
            child: Column(
              children: [
                _buildResultRow('Tip Amount', '\$${_tipAmount.toStringAsFixed(2)}'),
                const Divider(color: Colors.white30, height: 32),
                _buildResultRow('Total Amount', '\$${_totalAmount.toStringAsFixed(2)}'),
                const Divider(color: Colors.white30, height: 32),
                _buildResultRow('Per Person', '\$${_perPerson.toStringAsFixed(2)}', isLarge: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.white70,
            fontSize: isLarge ? 18 : 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontSize: isLarge ? 32 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================
// TAB 9: Loan Calculator
// ============================================
class _LoanCalculatorTab extends StatefulWidget {
  const _LoanCalculatorTab();

  @override
  State<_LoanCalculatorTab> createState() => _LoanCalculatorTabState();
}

class _LoanCalculatorTabState extends State<_LoanCalculatorTab> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  
  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;

  void _calculate() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final annualRate = double.tryParse(_rateController.text) ?? 0;
    final years = double.tryParse(_yearsController.text) ?? 0;

    if (principal > 0 && annualRate > 0 && years > 0) {
      final monthlyRate = annualRate / 100 / 12;
      final numPayments = years * 12;
      
      final monthly = principal * 
          (monthlyRate * math.pow(1 + monthlyRate, numPayments)) / 
          (math.pow(1 + monthlyRate, numPayments) - 1);
      
      final total = monthly * numPayments;
      final interest = total - principal;

      setState(() {
        _monthlyPayment = monthly;
        _totalPayment = total;
        _totalInterest = interest;
      });
    } else {
      setState(() {
        _monthlyPayment = 0;
        _totalPayment = 0;
        _totalInterest = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _principalController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount (\$)',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _calculate(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Annual Interest Rate (%)',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.percent, color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _calculate(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _yearsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Loan Term (Years)',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          if (_monthlyPayment > 0) ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.3), Colors.teal.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Monthly Payment',
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${_monthlyPayment.toStringAsFixed(2)}',
                    style: GoogleFonts.orbitron(
                      color: Colors.greenAccent,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildLoanDetailRow('Total Payment', '\$${_totalPayment.toStringAsFixed(2)}'),
                  const Divider(color: Colors.grey, height: 32),
                  _buildLoanDetailRow('Total Interest', '\$${_totalInterest.toStringAsFixed(2)}'),
                  const Divider(color: Colors.grey, height: 32),
                  _buildLoanDetailRow('Principal', '\$${_principalController.text}'),
                  const Divider(color: Colors.grey, height: 32),
                  _buildLoanDetailRow('Number of Payments', '${(double.tryParse(_yearsController.text) ?? 0) * 12}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Breakdown',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: (_principalController.text.isNotEmpty 
                            ? double.parse(_principalController.text) 
                            : 0).toInt(),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Principal',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: _totalInterest.toInt(),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Interest',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
