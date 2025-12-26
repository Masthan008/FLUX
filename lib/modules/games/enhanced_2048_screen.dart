import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/game_time_service.dart';

enum Direction { up, down, left, right }

class Enhanced2048Screen extends StatefulWidget {
  const Enhanced2048Screen({super.key});

  @override
  State<Enhanced2048Screen> createState() => _Enhanced2048ScreenState();
}

class _Enhanced2048ScreenState extends State<Enhanced2048Screen> 
    with TickerProviderStateMixin {
  static const String gameName = 'game_2048';
  late List<List<int>> _grid;
  late List<List<int>> _previousGrid;
  int _score = 0;
  int _bestScore = 0;
  bool _gameOver = false;
  bool _gameWon = false;
  late AnimationController _tileAnimationController;
  late AnimationController _scoreAnimationController;
  late AnimationController _gameOverAnimationController;
  
  // Performance optimization - reduce animation frequency
  bool _isAnimating = false;
  DateTime _lastMoveTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkGameAccess();
  }

  void _initializeAnimations() {
    // Reduced animation durations for better performance
    _tileAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _gameOverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Future<void> _checkGameAccess() async {
    final canPlay = await GameTimeService.canPlayGame(gameName);
    if (!canPlay) {
      final status = await GameTimeService.getGameStatus(gameName);
      if (mounted) {
        _showCooldownDialog(status['cooldownRemainingMinutes']);
      }
    } else {
      await GameTimeService.startGameSession(gameName);
      _initializeGame();
    }
  }

  void _showCooldownDialog(int minutes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.access_time, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            Text(
              'Game Time Limit',
              style: GoogleFonts.poppins(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'You have played for 20 minutes today!\n\nCome back in ${GameTimeService.getTimeRemainingMessage(minutes)} to play again.',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    GameTimeService.endGameSession(gameName);
    _tileAnimationController.dispose();
    _scoreAnimationController.dispose();
    _gameOverAnimationController.dispose();
    super.dispose();
  }

  void _initializeGame() {
    _grid = List.generate(4, (_) => List.filled(4, 0));
    _previousGrid = List.generate(4, (_) => List.filled(4, 0));
    _score = 0;
    _gameOver = false;
    _gameWon = false;
    _addRandomTile();
    _addRandomTile();
    setState(() {});
  }

  void _addRandomTile() {
    final emptyCells = <Point<int>>[];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) {
          emptyCells.add(Point(i, j));
        }
      }
    }

    if (emptyCells.isEmpty) return;

    final random = Random();
    final cell = emptyCells[random.nextInt(emptyCells.length)];
    _grid[cell.x][cell.y] = random.nextDouble() < 0.9 ? 2 : 4;
    
    _tileAnimationController.forward().then((_) {
      _tileAnimationController.reset();
    });
  }

  void _move(Direction direction) {
    if (_gameOver || _isAnimating) return;
    
    // Throttle moves to prevent lag
    final now = DateTime.now();
    if (now.difference(_lastMoveTime).inMilliseconds < 100) return;
    _lastMoveTime = now;

    // Save previous state
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        _previousGrid[i][j] = _grid[i][j];
      }
    }

    bool moved = false;
    int scoreGained = 0;

    switch (direction) {
      case Direction.left:
        for (int i = 0; i < 4; i++) {
          final result = _moveRowLeft(_grid[i]);
          _grid[i] = result['row'];
          if (result['moved']) moved = true;
          scoreGained += (result['score'] as int);
        }
        break;
      case Direction.right:
        for (int i = 0; i < 4; i++) {
          final result = _moveRowRight(_grid[i]);
          _grid[i] = result['row'];
          if (result['moved']) moved = true;
          scoreGained += (result['score'] as int);
        }
        break;
      case Direction.up:
        for (int j = 0; j < 4; j++) {
          final column = [_grid[0][j], _grid[1][j], _grid[2][j], _grid[3][j]];
          final result = _moveRowLeft(column);
          for (int i = 0; i < 4; i++) {
            _grid[i][j] = result['row'][i];
          }
          if (result['moved']) moved = true;
          scoreGained += (result['score'] as int);
        }
        break;
      case Direction.down:
        for (int j = 0; j < 4; j++) {
          final column = [_grid[0][j], _grid[1][j], _grid[2][j], _grid[3][j]];
          final result = _moveRowRight(column);
          for (int i = 0; i < 4; i++) {
            _grid[i][j] = result['row'][i];
          }
          if (result['moved']) moved = true;
          scoreGained += (result['score'] as int);
        }
        break;
    }

    if (moved) {
      _isAnimating = true;
      _score += scoreGained;
      
      if (scoreGained > 0) {
        _scoreAnimationController.forward().then((_) {
          _scoreAnimationController.reset();
        });
      }
      
      _addRandomTile();
      _checkGameState();
      
      // Haptic feedback
      HapticFeedback.lightImpact();
      
      setState(() {});
      
      // Reset animation flag after a short delay
      Future.delayed(const Duration(milliseconds: 150), () {
        _isAnimating = false;
      });
    }
  }

  Map<String, dynamic> _moveRowLeft(List<int> row) {
    final newRow = List<int>.from(row);
    bool moved = false;
    int score = 0;

    // Remove zeros
    newRow.removeWhere((element) => element == 0);
    
    // Merge tiles
    for (int i = 0; i < newRow.length - 1; i++) {
      if (newRow[i] == newRow[i + 1]) {
        newRow[i] *= 2;
        score += newRow[i];
        newRow.removeAt(i + 1);
        if (newRow[i] == 2048 && !_gameWon) {
          _gameWon = true;
          _showWinDialog();
        }
      }
    }
    
    // Add zeros to the end
    while (newRow.length < 4) {
      newRow.add(0);
    }
    
    // Check if moved
    for (int i = 0; i < 4; i++) {
      if (row[i] != newRow[i]) {
        moved = true;
        break;
      }
    }

    return {'row': newRow, 'moved': moved, 'score': score};
  }

  Map<String, dynamic> _moveRowRight(List<int> row) {
    final reversed = row.reversed.toList();
    final result = _moveRowLeft(reversed);
    result['row'] = (result['row'] as List<int>).reversed.toList();
    return result;
  }

  void _checkGameState() {
    // Check for empty cells
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) return;
      }
    }

    // Check for possible moves
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (j < 3 && _grid[i][j] == _grid[i][j + 1]) return;
        if (i < 3 && _grid[i][j] == _grid[i + 1][j]) return;
      }
    }

    _gameOver = true;
    _gameOverAnimationController.forward();
    
    // Show game over dialog
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _showGameOverDialog();
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            Text(
              'Congratulations!',
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'You reached 2048! Keep playing to get an even higher score.',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Continue',
              style: GoogleFonts.poppins(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.sentiment_dissatisfied, color: Colors.red, size: 24),
            const SizedBox(width: 8),
            Text(
              'Game Over!',
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No more moves available!',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.cyanAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Final Score: $_score',
                    style: GoogleFonts.poppins(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: Text(
              'Play Again',
              style: GoogleFonts.poppins(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Exit',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
              const Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildScoreBoard(),
                      const SizedBox(height: 30),
                      _buildGameGrid(),
                      const SizedBox(height: 30),
                      _buildControlButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              '2048 Puzzle',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.cyanAccent),
            onPressed: _initializeGame,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.3);
  }

  Widget _buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreCard('SCORE', _score, Colors.amber),
        _buildScoreCard('BEST', _bestScore, Colors.cyanAccent),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2);
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return AnimatedBuilder(
      animation: _scoreAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_scoreAnimationController.value * 0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  score.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameGrid() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          final row = index ~/ 4;
          final col = index % 4;
          final value = _grid[row][col];
          
          return GestureDetector(
            onPanEnd: (details) {
              final velocity = details.velocity.pixelsPerSecond;
              if (velocity.dx.abs() > velocity.dy.abs()) {
                if (velocity.dx > 0) {
                  _move(Direction.right);
                } else {
                  _move(Direction.left);
                }
              } else {
                if (velocity.dy > 0) {
                  _move(Direction.down);
                } else {
                  _move(Direction.up);
                }
              }
            },
            child: _buildTile(value),
          );
        },
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildTile(int value) {
    final colors = _getTileColors(value);
    
    // Optimize by reducing unnecessary animations for empty tiles
    if (value == 0) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }
    
    return AnimatedBuilder(
      animation: _tileAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + (_tileAnimationController.value * 0.05), // Reduced scale for performance
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colors[0].withOpacity(0.2), // Reduced opacity for performance
                  blurRadius: 4, // Reduced blur for performance
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: GoogleFonts.poppins(
                  fontSize: _getFontSize(value),
                  fontWeight: FontWeight.w700,
                  color: value <= 4 ? Colors.grey[800] : Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> _getTileColors(int value) {
    switch (value) {
      case 0: return [const Color(0xFF3A3A4E), const Color(0xFF2A2A3E)];
      case 2: return [const Color(0xFFEEE4DA), const Color(0xFFEDE0C8)];
      case 4: return [const Color(0xFFEDE0C8), const Color(0xFFEBDCBB)];
      case 8: return [const Color(0xFFF2B179), const Color(0xFFEFA460)];
      case 16: return [const Color(0xFFF59563), const Color(0xFFF2854B)];
      case 32: return [const Color(0xFFF67C5F), const Color(0xFFF46042)];
      case 64: return [const Color(0xFFF65E3B), const Color(0xFFED4C2F)];
      case 128: return [const Color(0xFFEDCF72), const Color(0xFFEBCC61)];
      case 256: return [const Color(0xFFEDCC61), const Color(0xFFEBC850)];
      case 512: return [const Color(0xFFEDC850), const Color(0xFFEBC53F)];
      case 1024: return [const Color(0xFFEDC53F), const Color(0xFFE8C12E)];
      case 2048: return [const Color(0xFFEDC22E), const Color(0xFFFFD700)];
      default: return [const Color(0xFF3C3A32), const Color(0xFF2A2A2A)];
    }
  }

  double _getFontSize(int value) {
    if (value < 100) return 24;
    if (value < 1000) return 20;
    return 16;
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.undo,
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
        _buildControlButton(
          icon: Icons.refresh,
          label: 'New Game',
          onPressed: _initializeGame,
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3);
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.8),
            Colors.cyanAccent.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.black, size: 20),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}