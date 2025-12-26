import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../../services/game_time_service.dart';

class EnhancedTicTacToeScreen extends StatefulWidget {
  const EnhancedTicTacToeScreen({super.key});

  @override
  State<EnhancedTicTacToeScreen> createState() => _EnhancedTicTacToeScreenState();
}

class _EnhancedTicTacToeScreenState extends State<EnhancedTicTacToeScreen> 
    with TickerProviderStateMixin {
  static const String gameName = 'tictactoe';
  List<String> _board = List.filled(9, '');
  bool _isPlayerTurn = true; // true = X (player), false = O (AI)
  String _winner = '';
  int _playerScore = 0;
  int _aiScore = 0;
  int _draws = 0;
  bool _gameActive = true;
  
  late AnimationController _boardAnimationController;
  late AnimationController _cellAnimationController;
  late AnimationController _winAnimationController;
  late Animation<double> _boardScaleAnimation;
  late Animation<double> _cellScaleAnimation;
  late Animation<double> _winPulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkGameAccess();
  }

  void _initializeAnimations() {
    _boardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _cellAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _winAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _boardScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _boardAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _cellScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cellAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _winPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _winAnimationController,
      curve: Curves.elasticInOut,
    ));

    _boardAnimationController.forward();
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
    _boardAnimationController.dispose();
    _cellAnimationController.dispose();
    _winAnimationController.dispose();
    super.dispose();
  }

  void _makeMove(int index) {
    if (_board[index] != '' || !_gameActive || !_isPlayerTurn) return;

    setState(() {
      _board[index] = 'X';
      _isPlayerTurn = false;
    });

    _cellAnimationController.forward().then((_) {
      _cellAnimationController.reset();
    });

    HapticFeedback.lightImpact();

    if (_checkWinner()) {
      _handleGameEnd();
      return;
    }

    if (_isBoardFull()) {
      _handleDraw();
      return;
    }

    // AI move after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _makeAIMove();
    });
  }

  void _makeAIMove() {
    if (!_gameActive) return;

    int bestMove = _getBestMove();
    
    setState(() {
      _board[bestMove] = 'O';
      _isPlayerTurn = true;
    });

    _cellAnimationController.forward().then((_) {
      _cellAnimationController.reset();
    });

    if (_checkWinner()) {
      _handleGameEnd();
      return;
    }

    if (_isBoardFull()) {
      _handleDraw();
    }
  }

  int _getBestMove() {
    // Advanced AI using minimax algorithm
    int bestScore = -1000;
    int bestMove = 0;

    for (int i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = 'O';
        int score = _minimax(_board, 0, false);
        _board[i] = '';
        
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }

    return bestMove;
  }

  int _minimax(List<String> board, int depth, bool isMaximizing) {
    String result = _checkWinnerForBoard(board);
    
    if (result == 'O') return 10 - depth;
    if (result == 'X') return depth - 10;
    if (_isBoardFullForBoard(board)) return 0;

    if (isMaximizing) {
      int bestScore = -1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'O';
          int score = _minimax(board, depth + 1, false);
          board[i] = '';
          bestScore = max(score, bestScore);
        }
      }
      return bestScore;
    } else {
      int bestScore = 1000;
      for (int i = 0; i < 9; i++) {
        if (board[i] == '') {
          board[i] = 'X';
          int score = _minimax(board, depth + 1, true);
          board[i] = '';
          bestScore = min(score, bestScore);
        }
      }
      return bestScore;
    }
  }

  String _checkWinnerForBoard(List<String> board) {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (board[i] != '' && board[i] == board[i + 1] && board[i] == board[i + 2]) {
        return board[i];
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (board[i] != '' && board[i] == board[i + 3] && board[i] == board[i + 6]) {
        return board[i];
      }
    }

    // Check diagonals
    if (board[0] != '' && board[0] == board[4] && board[0] == board[8]) {
      return board[0];
    }
    if (board[2] != '' && board[2] == board[4] && board[2] == board[6]) {
      return board[2];
    }

    return '';
  }

  bool _isBoardFullForBoard(List<String> board) {
    return !board.contains('');
  }

  bool _checkWinner() {
    _winner = _checkWinnerForBoard(_board);
    return _winner != '';
  }

  bool _isBoardFull() {
    return !_board.contains('');
  }

  void _handleGameEnd() {
    setState(() {
      _gameActive = false;
      if (_winner == 'X') {
        _playerScore++;
      } else if (_winner == 'O') {
        _aiScore++;
      }
    });

    _winAnimationController.repeat(reverse: true);
    HapticFeedback.mediumImpact();

    _showGameEndDialog();
  }

  void _handleDraw() {
    setState(() {
      _gameActive = false;
      _draws++;
    });

    _showGameEndDialog();
  }

  void _showGameEndDialog() {
    String title;
    String message;
    Color color;
    IconData icon;

    if (_winner == 'X') {
      title = 'You Win!';
      message = 'Congratulations! You beat the AI.';
      color = Colors.green;
      icon = Icons.celebration;
    } else if (_winner == 'O') {
      title = 'AI Wins!';
      message = 'Better luck next time!';
      color = Colors.red;
      icon = Icons.smart_toy;
    } else {
      title = 'It\'s a Draw!';
      message = 'Great game! Try again.';
      color = Colors.orange;
      icon = Icons.handshake;
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1a1a2e),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: Text(
                'Play Again',
                style: GoogleFonts.poppins(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isPlayerTurn = true;
      _winner = '';
      _gameActive = true;
    });
    
    _winAnimationController.reset();
    _boardAnimationController.forward();
  }

  void _resetScores() {
    setState(() {
      _playerScore = 0;
      _aiScore = 0;
      _draws = 0;
    });
    _resetGame();
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
                      _buildCurrentPlayerIndicator(),
                      const SizedBox(height: 30),
                      _buildGameBoard(),
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
              'Tic-Tac-Toe',
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
            onPressed: _resetScores,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.3);
  }

  Widget _buildScoreBoard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildScoreCard('YOU', _playerScore, Colors.cyanAccent, 'X'),
        _buildScoreCard('DRAWS', _draws, Colors.orange, '='),
        _buildScoreCard('AI', _aiScore, Colors.red, 'O'),
      ],
    ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2);
  }

  Widget _buildScoreCard(String label, int score, Color color, String symbol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            symbol,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlayerIndicator() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: _isPlayerTurn ? Colors.cyanAccent.withOpacity(0.2) : Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isPlayerTurn ? Colors.cyanAccent : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isPlayerTurn ? Icons.person : Icons.smart_toy,
            color: _isPlayerTurn ? Colors.cyanAccent : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            _isPlayerTurn ? 'Your Turn (X)' : 'AI Turn (O)',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildGameBoard() {
    return AnimatedBuilder(
      animation: _boardScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _boardScaleAnimation.value,
          child: Container(
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
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return _buildCell(index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(int index) {
    final value = _board[index];
    final isWinningCell = _isWinningCell(index);
    
    return AnimatedBuilder(
      animation: isWinningCell ? _winPulseAnimation : _cellAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: isWinningCell ? _winPulseAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _makeMove(index),
            child: Container(
              decoration: BoxDecoration(
                color: value == '' 
                    ? const Color(0xFF3A3A4E) 
                    : (value == 'X' ? Colors.cyanAccent.withOpacity(0.2) : Colors.red.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: value == '' 
                      ? Colors.grey.withOpacity(0.3)
                      : (value == 'X' ? Colors.cyanAccent : Colors.red),
                  width: 2,
                ),
                boxShadow: value != '' ? [
                  BoxShadow(
                    color: (value == 'X' ? Colors.cyanAccent : Colors.red).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
              ),
              child: Center(
                child: value != ''
                    ? Text(
                        value,
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: value == 'X' ? Colors.cyanAccent : Colors.red,
                        ),
                      ).animate().scale(duration: 300.ms, curve: Curves.elasticOut)
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isWinningCell(int index) {
    if (_winner == '') return false;
    
    // Check if this cell is part of the winning combination
    List<List<int>> winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // columns
      [0, 4, 8], [2, 4, 6], // diagonals
    ];
    
    for (var combination in winningCombinations) {
      if (combination.every((i) => _board[i] == _winner) && combination.contains(index)) {
        return true;
      }
    }
    
    return false;
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(
          icon: Icons.refresh,
          label: 'New Game',
          onPressed: _resetGame,
        ),
        _buildControlButton(
          icon: Icons.restart_alt,
          label: 'Reset Scores',
          onPressed: _resetScores,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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