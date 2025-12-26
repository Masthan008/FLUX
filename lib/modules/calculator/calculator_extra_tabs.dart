import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

// ============================================
// TAB 6: Equation Solver
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

  void _solveQuadratic() {
    final a = double.tryParse(_aController.text) ?? 0;
    final b = double.tryParse(_bController.text) ?? 0;
    final c = double.tryParse(_cController.text) ?? 0;

    if (a == 0) {
      setState(() {
        _solution = 'Not a quadratic equation (a cannot be 0)';
      });
      return;
    }

    final discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
      final x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      final x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      setState(() {
        _solution = 'Two real solutions:\nx₁ = ${x1.toStringAsFixed(4)}\nx₂ = ${x2.toStringAsFixed(4)}';
      });
    } else if (discriminant == 0) {
      final x = -b / (2 * a);
      setState(() {
        _solution = 'One real solution:\nx = ${x.toStringAsFixed(4)}';
      });
    } else {
      final realPart = -b / (2 * a);
      final imaginaryPart = math.sqrt(-discriminant) / (2 * a);
      setState(() {
        _solution = 'Two complex solutions:\nx₁ = ${realPart.toStringAsFixed(4)} + ${imaginaryPart.toStringAsFixed(4)}i\nx₂ = ${realPart.toStringAsFixed(4)} - ${imaginaryPart.toStringAsFixed(4)}i';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(
                  'Quadratic Solver',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'ax² + bx + c = 0',
                  style: GoogleFonts.montserrat(color: Colors.white54, fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          // Coefficient inputs
          _buildCoefficientField('a', _aController),
          const SizedBox(height: 16),
          _buildCoefficientField('b', _bController),
          const SizedBox(height: 16),
          _buildCoefficientField('c', _cController),
          const SizedBox(height: 30),

          // Solve button
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _solveQuadratic,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Text('SOLVE', style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Solution display
          if (_solution.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F).withOpacity(0.8),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                boxShadow: [
                   BoxShadow(color: Colors.cyanAccent.withOpacity(0.1), blurRadius: 20),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ROOTS:',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _solution,
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCoefficientField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(
            '$label = ',
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'monospace'),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '0',
                hintStyle: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 7: Matrix Calculator
// ============================================
class _MatrixCalculatorTab extends StatefulWidget {
  const _MatrixCalculatorTab();

  @override
  State<_MatrixCalculatorTab> createState() => _MatrixCalculatorTabState();
}

class _MatrixCalculatorTabState extends State<_MatrixCalculatorTab> {
  int _rows = 2;
  int _cols = 2;
  List<List<TextEditingController>> _matrixA = [];
  List<List<TextEditingController>> _matrixB = [];
  String _result = '';
  String _operation = 'Add';

  @override
  void initState() {
    super.initState();
    _initializeMatrices();
  }

  void _initializeMatrices() {
    _matrixA = List.generate(
      _rows,
      (i) => List.generate(_cols, (j) => TextEditingController(text: '0')),
    );
    _matrixB = List.generate(
      _rows,
      (i) => List.generate(_cols, (j) => TextEditingController(text: '0')),
    );
  }

  void _resizeMatrices(int rows, int cols) {
    setState(() {
      _rows = rows;
      _cols = cols;
      _initializeMatrices();
      _result = '';
    });
  }

  void _calculate() {
    try {
      final matA = _matrixA.map((row) => 
        row.map((controller) => double.tryParse(controller.text) ?? 0).toList()
      ).toList();
      
      final matB = _matrixB.map((row) => 
        row.map((controller) => double.tryParse(controller.text) ?? 0).toList()
      ).toList();

      List<List<double>> resultMatrix = [];

      if (_operation == 'Add') {
        resultMatrix = List.generate(_rows, (i) => 
          List.generate(_cols, (j) => matA[i][j] + matB[i][j])
        );
      } else if (_operation == 'Subtract') {
        resultMatrix = List.generate(_rows, (i) => 
          List.generate(_cols, (j) => matA[i][j] - matB[i][j])
        );
      } else if (_operation == 'Multiply') {
        if (_cols != _rows) {
          setState(() {
            _result = 'For multiplication, matrix must be square or compatible';
          });
          return;
        }
        resultMatrix = List.generate(_rows, (i) => 
          List.generate(_cols, (j) {
            double sum = 0;
            for (int k = 0; k < _cols; k++) {
              sum += matA[i][k] * matB[k][j];
            }
            return sum;
          })
        );
      }

      String resultStr = '';
      for (var row in resultMatrix) {
        resultStr += row.map((val) => val.toStringAsFixed(2)).join('  ') + '\n';
      }

      setState(() {
        _result = resultStr;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
             child: Text(
              'MATRIX OPERATIONS',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Size selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('Size:', style: GoogleFonts.montserrat(color: Colors.white)),
                    const SizedBox(width: 16),
                    DropdownButton<int>(
                      value: _rows,
                      dropdownColor: const Color(0xFF1A1A1A),
                      underline: const SizedBox(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.cyanAccent),
                      items: [2, 3, 4].map((size) => 
                        DropdownMenuItem(value: size, child: Text('${size}x$size', style: const TextStyle(color: Colors.white)))
                      ).toList(),
                      onChanged: (val) => _resizeMatrices(val!, val),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: _operation,
                  dropdownColor: const Color(0xFF1A1A1A),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.calculate, color: Colors.cyanAccent),
                  items: ['Add', 'Subtract', 'Multiply'].map((op) => 
                    DropdownMenuItem(value: op, child: Text(op, style: const TextStyle(color: Colors.cyanAccent)))
                  ).toList(),
                  onChanged: (val) => setState(() => _operation = val!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Matrix A
          Text('Matrix A', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 8),
          _buildMatrix(_matrixA),
          const SizedBox(height: 20),

          // Matrix B
          Text('Matrix B', style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 8),
          _buildMatrix(_matrixB),
          const SizedBox(height: 30),

          // Calculate button
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 20),
                ],
              ),
              child: ElevatedButton(
                onPressed: _calculate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: Text('CALCULATE', style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Result
          if (_result.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F0F).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purpleAccent.withOpacity(0.5)),
                boxShadow: [
                   BoxShadow(color: Colors.purpleAccent.withOpacity(0.1), blurRadius: 20),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESULT MATRIX:',
                    style: GoogleFonts.orbitron(color: Colors.purpleAccent, fontSize: 14, letterSpacing: 2),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _result,
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMatrix(List<List<TextEditingController>> matrix) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: List.generate(_rows, (i) => 
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_cols, (j) => 
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: TextField(
                      controller: matrix[i][j],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var row in _matrixA) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    for (var row in _matrixB) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}
