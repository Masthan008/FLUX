import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/chat_enhanced_service.dart';

class PollWidget extends StatefulWidget {
  final int messageId;
  
  const PollWidget({
    super.key,
    required this.messageId,
  });

  @override
  State<PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<PollWidget> {
  Map<String, dynamic>? _pollData;
  bool _isLoading = true;
  bool _isVoting = false;

  @override
  void initState() {
    super.initState();
    _loadPoll();
  }

  Future<void> _loadPoll() async {
    final data = await ChatEnhancedService.getPollResults(widget.messageId);
    if (mounted) {
      setState(() {
        _pollData = data;
        _isLoading = false;
      });
    }
  }

  Future<void> _vote(int optionIndex) async {
    if (_pollData == null || _isVoting) return;
    
    setState(() => _isVoting = true);
    
    final success = await ChatEnhancedService.votePoll(
      _pollData!['poll_id'] as int,
      optionIndex,
    );
    
    if (success) {
      await _loadPoll(); // Reload to show updated results
    }
    
    if (mounted) {
      setState(() => _isVoting = false);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vote recorded!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.cyanAccent),
        ),
      );
    }

    if (_pollData == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Poll not found',
          style: GoogleFonts.montserrat(color: Colors.grey),
        ),
      );
    }

    final question = _pollData!['question'] as String;
    final options = List<Map<String, dynamic>>.from(_pollData!['options']);
    final totalVotes = _pollData!['total_votes'] as int;
    final expiresAt = _pollData!['expires_at'] as String?;
    
    // Check if expired
    bool isExpired = false;
    if (expiresAt != null) {
      final expiry = DateTime.parse(expiresAt);
      isExpired = expiry.isBefore(DateTime.now());
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poll icon and question
          Row(
            children: [
              const Icon(Icons.poll, color: Colors.cyanAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Options
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final text = option['text'] as String;
            final votes = option['votes'] as int;
            final percentage = totalVotes > 0 ? (votes / totalVotes * 100).toInt() : 0;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: isExpired || _isVoting ? null : () => _vote(index),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.shade700,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              text,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            '$votes votes ($percentage%)',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: totalVotes > 0 ? votes / totalVotes : 0,
                          backgroundColor: Colors.grey.shade800,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          // Footer
          Row(
            children: [
              Icon(
                Icons.how_to_vote,
                color: Colors.grey.shade600,
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                '$totalVotes ${totalVotes == 1 ? 'vote' : 'votes'}',
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              if (isExpired) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'EXPIRED',
                    style: GoogleFonts.montserrat(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
