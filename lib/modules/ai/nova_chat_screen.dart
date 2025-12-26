import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/ai_service.dart';
import '../../services/student_auth_service.dart';

class NovaChatScreen extends StatefulWidget {
  const NovaChatScreen({super.key});

  @override
  State<NovaChatScreen> createState() => _NovaChatScreenState();
}

class _NovaChatScreenState extends State<NovaChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isThinking = false;
  
  // Get tier dynamically from StudentAuthService
  String get _userTier => StudentAuthService.currentStudent?.subscriptionTier ?? 'free';

  @override
  void initState() {
    super.initState();
    
    // Welcome message based on tier
    final welcomeMessage = AIService.hasAIAccess(_userTier)
        ? '⚡ Hello! I\'m **Flux AI**, your intelligent study assistant powered by advanced multi-provider AI system.\n\nAsk me anything about coding, studies, or any topic you\'re curious about!\n\n${AIService.getTierFeatures(_userTier)}'
        : '⚡ Hello! I\'m **Flux AI**. ${AIService.getTierFeatures(_userTier)}';
    
    _messages.add(ChatMessage(
      text: welcomeMessage,
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isThinking) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isThinking = true;
    });

    _controller.clear();
    _scrollToBottom();

    // Get AI response using new tier-based system
    try {
      final response = await AIService.getResponse(text, userTier: _userTier);

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isThinking = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again in a moment.\n\nError: ${e.toString()}',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isThinking = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _messages.add(ChatMessage(
        text: 'Chat cleared! How can I help you?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              'Flux AI',
              style: GoogleFonts.orbitron(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.purple),
        actions: [
          // Tier Badge
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _userTier == 'ultra'
                    ? [Colors.purple, Colors.deepPurple]
                    : _userTier == 'pro'
                        ? [Colors.blue, Colors.cyan]
                        : [Colors.grey, Colors.grey.shade700],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _userTier.toUpperCase(),
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Clear Chat
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade900, Colors.black],
          ),
        ),
        child: Column(
          children: [
            // AI Status Banner
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AIService.hasAIAccess(_userTier)
                      ? [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.2)]
                      : [Colors.grey.withOpacity(0.3), Colors.grey.shade800.withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AIService.hasAIAccess(_userTier)
                      ? Colors.purple.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    AIService.hasAIAccess(_userTier) ? Icons.verified : Icons.lock,
                    color: AIService.hasAIAccess(_userTier) ? Colors.purple : Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AIService.hasAIAccess(_userTier)
                          ? 'Multi-provider AI with automatic fallback • ${_userTier.toUpperCase()} Tier'
                          : 'Upgrade to Pro or Ultra for AI access',
                      style: GoogleFonts.montserrat(
                        color: AIService.hasAIAccess(_userTier)
                            ? Colors.purple.shade200
                            : Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: -0.2, end: 0)
                .then()
                .shimmer(
                  delay: 1.seconds,
                  duration: 2.seconds,
                  color: AIService.hasAIAccess(_userTier)
                      ? Colors.purple.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                ),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Thinking Indicator with Animation
            if (_isThinking)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple.withOpacity(0.3), Colors.deepPurple.withOpacity(0.2)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.purple),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Flux AI is thinking...',
                      style: GoogleFonts.montserrat(
                        color: Colors.purple,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .fadeIn(duration: 600.ms)
                  .shimmer(duration: 1.5.seconds, color: Colors.purple.withOpacity(0.3)),

            // Input Bar
            Container(
              padding: EdgeInsets.only(
                bottom: 80, // Space for bottom nav
                left: 16,
                right: 16,
                top: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Ask Nova anything...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.purple.shade700],
                        ),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
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

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.withOpacity(0.3), Colors.deepPurple.withOpacity(0.2)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.purple,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.purple.withOpacity(0.3)
                    : Colors.grey.shade900,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                border: Border.all(
                  color: message.isUser
                      ? Colors.purple.withOpacity(0.5)
                      : Colors.grey.shade800,
                ),
              ),
              child: MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  code: GoogleFonts.firaCode(
                    backgroundColor: Colors.black,
                    color: Colors.cyanAccent,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
