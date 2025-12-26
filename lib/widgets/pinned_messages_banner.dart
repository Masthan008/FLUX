import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/chat_enhanced_service.dart';

class PinnedMessagesBanner extends StatefulWidget {
  final Function(Map<String, dynamic>) onMessageTap;
  
  const PinnedMessagesBanner({
    super.key,
    required this.onMessageTap,
  });

  @override
  State<PinnedMessagesBanner> createState() => _PinnedMessagesBannerState();
}

class _PinnedMessagesBannerState extends State<PinnedMessagesBanner> {
  List<Map<String, dynamic>> _pinnedMessages = [];
  bool _isLoading = true;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPinnedMessages();
  }

  Future<void> _loadPinnedMessages() async {
    final messages = await ChatEnhancedService.getPinnedMessages();
    if (mounted) {
      setState(() {
        _pinnedMessages = messages;
        _isLoading = false;
      });
    }
  }

  void _nextMessage() {
    if (_pinnedMessages.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _pinnedMessages.length;
    });
  }

  void _previousMessage() {
    if (_pinnedMessages.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex - 1 + _pinnedMessages.length) % _pinnedMessages.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (_pinnedMessages.isEmpty) {
      return const SizedBox.shrink();
    }

    final message = _pinnedMessages[_currentIndex];
    final sender = message['sender'] as String;
    final text = message['message'] as String;

    return GestureDetector(
      onTap: () => widget.onMessageTap(message),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(
              color: Colors.orange.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.push_pin,
              color: Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pinned by $sender',
                    style: GoogleFonts.montserrat(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    text,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (_pinnedMessages.length > 1) ...[
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.orange, size: 20),
                onPressed: _previousMessage,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                '${_currentIndex + 1}/${_pinnedMessages.length}',
                style: GoogleFonts.montserrat(
                  color: Colors.orange,
                  fontSize: 11,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.orange, size: 20),
                onPressed: _nextMessage,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
