import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/chat_enhanced_service.dart';
import '../widgets/emoji_reaction_picker.dart';
import '../widgets/poll_creator_dialog.dart';
import '../widgets/poll_widget.dart';
import '../widgets/disappearing_message_dialog.dart';
import '../widgets/pinned_messages_banner.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String _currentUser = 'Student';
  String _currentRole = 'student';
  int _onlineCount = 0;
  Map<String, dynamic>? _replyingTo;
  bool _isSearching = false;
  String _searchQuery = '';
  Duration? _disappearingDuration;
  Timer? _typingTimer;
  
  // Animation controllers
  late AnimationController _headerAnimationController;
  late AnimationController _messageAnimationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _fabScaleAnimation;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('user_prefs');
    _currentUser = box.get('user_name', defaultValue: 'Student');
    _currentRole = box.get('role', defaultValue: 'student');
    
    // Initialize animations
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _messageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _trackPresence();
    
    // Start animations
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _fabAnimationController.forward();
    });
  }

  void _trackPresence() {
    // Track online presence using Supabase Realtime
    try {
      final channel = Supabase.instance.client.channel('online_users');
      
      channel.onPresenceSync((payload) {
        setState(() {
          _onlineCount = channel.presenceState().length;
        });
      }).subscribe((status, error) async {
        if (status == RealtimeSubscribeStatus.subscribed) {
          await channel.track({'user': _currentUser});
        }
      });
    } catch (e) {
      // Presence tracking failed, continue without it
      print('Presence tracking error: $e');
    }
  }

  Future<void> _deleteMessage(int messageId, String sender) async {
    // Only allow deletion if it's your message OR you're a teacher
    final canDelete = sender == _currentUser || _currentRole == 'teacher';
    
    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only delete your own messages')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Delete Message?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This message will be deleted for everyone.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client
            .from('chat_messages')
            .delete()
            .eq('id', messageId);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting message: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _typingTimer?.cancel();
    _headerAnimationController.dispose();
    _messageAnimationController.dispose();
    _fabAnimationController.dispose();
    ChatEnhancedService.setTyping(false);
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      // Check if disappearing message
      if (_disappearingDuration != null) {
        await ChatEnhancedService.sendDisappearingMessage(
          message: message,
          expiresIn: _disappearingDuration!,
          replyToId: _replyingTo?['id'] as int?,
        );
      } else {
        // Regular message
        final messageData = <String, dynamic>{
          'sender': _currentUser,
          'message': message,
          'created_at': DateTime.now().toIso8601String(),
        };
        
        if (_replyingTo != null) {
          messageData['reply_to'] = _replyingTo!['id'] as int;
          messageData['reply_message'] = _replyingTo!['message'] as String;
          messageData['reply_sender'] = _replyingTo!['sender'] as String;
        }

        await Supabase.instance.client.from('chat_messages').insert(messageData);
      }

      _messageController.clear();
      setState(() {
        _replyingTo = null;
        _disappearingDuration = null;
      });
      
      // Stop typing indicator
      ChatEnhancedService.setTyping(false);
      
      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients && mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reactToMessage(int messageId, String emoji) async {
    try {
      // Fetch current message to get existing reactions
      final response = await Supabase.instance.client
          .from('chat_messages')
          .select('reactions')
          .eq('id', messageId)
          .single();
      
      Map<String, dynamic> reactions = {};
      if (response['reactions'] != null && response['reactions'] is Map) {
        reactions = Map<String, dynamic>.from(response['reactions']);
      }
      
      // Toggle reaction for current user
      if (reactions.containsKey(emoji)) {
        final users = List<String>.from(reactions[emoji]);
        if (users.contains(_currentUser)) {
          users.remove(_currentUser);
          if (users.isEmpty) {
            reactions.remove(emoji);
          } else {
            reactions[emoji] = users;
          }
        } else {
          users.add(_currentUser);
          reactions[emoji] = users;
        }
      } else {
        reactions[emoji] = [_currentUser];
      }
      
      await Supabase.instance.client.from('chat_messages').update({
        'reactions': reactions,
      }).eq('id', messageId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding reaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _replyToMessage(Map<String, dynamic> message) {
    setState(() {
      _replyingTo = message;
    });
    _focusNode.requestFocus();
  }

  void _showReactionPicker(int messageId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EmojiReactionPicker(
        onEmojiSelected: (emoji) async {
          await _reactToMessage(messageId, emoji);
        },
      ),
    );
  }

  // Show disappearing message dialog
  Future<void> _showDisappearingDialog() async {
    final duration = await showDialog<Duration>(
      context: context,
      builder: (context) => const DisappearingMessageDialog(),
    );
    
    if (duration != null) {
      setState(() {
        _disappearingDuration = duration;
      });
    }
  }

  // Show poll creator
  Future<void> _showPollCreator() async {
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => const PollCreatorDialog(),
    );
    
    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Poll created!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Show bookmarks
  Future<void> _showBookmarks() async {
    final bookmarks = await ChatEnhancedService.getBookmarkedMessages();
    
    if (!mounted) return;
    
    if (bookmarks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No bookmarked messages')),
      );
      return;
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bookmarked Messages',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  final msg = bookmarks[index];
                  return ListTile(
                    title: Text(
                      msg['sender'],
                      style: const TextStyle(color: Colors.cyanAccent),
                    ),
                    subtitle: Text(
                      msg['message'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.bookmark_remove, color: Colors.red),
                      onPressed: () async {
                        await ChatEnhancedService.unbookmarkMessage(msg['id']);
                        Navigator.pop(context);
                        _showBookmarks(); // Refresh
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Typing indicator handler
  void _onTypingChanged(String text) {
    _typingTimer?.cancel();
    
    if (text.isNotEmpty) {
      ChatEnhancedService.setTyping(true);
      _typingTimer = Timer(const Duration(seconds: 3), () {
        ChatEnhancedService.setTyping(false);
      });
    } else {
      ChatEnhancedService.setTyping(false);
    }
  }

  // Format duration for display
  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }

  // Format time remaining for disappearing messages
  String _formatTimeRemaining(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  // Pin/unpin message (teacher only)
  Future<void> _togglePin(int messageId, bool isPinned) async {
    if (_currentRole != 'teacher') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only teachers can pin messages')),
      );
      return;
    }
    
    final success = isPinned
        ? await ChatEnhancedService.unpinMessage(messageId)
        : await ChatEnhancedService.pinMessage(messageId);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isPinned ? 'Message unpinned' : 'Message pinned'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Bookmark message
  Future<void> _toggleBookmark(int messageId) async {
    // Check if already bookmarked
    final isBookmarked = await ChatEnhancedService.isBookmarked(messageId);
    
    final success = isBookmarked
        ? await ChatEnhancedService.unbookmarkMessage(messageId)
        : await ChatEnhancedService.bookmarkMessage(messageId);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isBookmarked ? 'Bookmark removed' : 'Message bookmarked'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.grey.shade900.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: AnimatedBuilder(
          animation: _headerFadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _headerFadeAnimation,
              child: SlideTransition(
                position: _headerSlideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.cyanAccent, Colors.blue],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.chat_bubble, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'ChatHub',
                          style: GoogleFonts.orbitron(
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    if (_onlineCount > 0)
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          )
                              .animate(onPlay: (controller) => controller.repeat(reverse: true))
                              .scale(duration: 1.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)),
                          const SizedBox(width: 6),
                          Text(
                            '$_onlineCount Online',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.8),
                    Colors.blueAccent.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bookmark_border, color: Colors.white),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showBookmarks();
            },
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.8),
                    Colors.purpleAccent.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Enhanced Animated Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF121212),
                  Colors.grey.shade900,
                  const Color(0xFF121212),
                ],
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(
                duration: 10.seconds,
                color: Colors.cyanAccent.withOpacity(0.05),
              ),

          // Floating Particles Background
          ...List.generate(15, (index) {
            return Positioned(
              left: (index * 60.0) % MediaQuery.of(context).size.width,
              top: (index * 100.0) % MediaQuery.of(context).size.height,
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .fadeIn(duration: (2 + index % 4).seconds)
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5)),
            );
          }),

          Positioned.fill(
            child: Column(
            children: [
              const SizedBox(height: 100), // Space for app bar
              
              // Pinned messages banner
              PinnedMessagesBanner(
                onMessageTap: (message) {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pinned: ${message['message']}')),
                  );
                },
              )
                  .animate()
                  .fadeIn(delay: 300.ms, duration: 600.ms)
                  .slideY(begin: -0.3, end: 0),
          
              // Messages List - Takes all available space
              Expanded(
                child: Column(
                  children: [
                    // Enhanced Search bar
                    if (_isSearching)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade900,
                              Colors.grey.shade800,
                            ],
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search messages...',
                            hintStyle: TextStyle(color: Colors.grey.shade600),
                            filled: true,
                            fillColor: Colors.black.withOpacity(0.8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.purpleAccent],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.search, color: Colors.white, size: 20),
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: -0.5, end: 0),
                    
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF121212),
                          image: DecorationImage(
                            image: const NetworkImage(
                              'https://www.transparenttextures.com/patterns/dark-matter.png',
                            ),
                            repeat: ImageRepeat.repeat,
                            opacity: 0.05,
                            onError: (exception, stackTrace) {
                              // Fallback if pattern fails to load
                            },
                          ),
                        ),
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: Supabase.instance.client
                              .from('chat_messages')
                              .stream(primaryKey: ['id'])
                              .order('created_at', ascending: true),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red, size: 48),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Error loading messages',
                                      style: GoogleFonts.montserrat(color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${snapshot.error}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.chat_bubble_outline, 
                                      color: Colors.grey, size: 64),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No messages yet',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Be the first to say hello!',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.grey.shade700,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final messages = snapshot.data!;
                            
                            // Filter messages based on search
                            final filteredMessages = _searchQuery.isEmpty
                                ? messages
                                : messages.where((msg) {
                                    final message = (msg['message'] ?? '').toString().toLowerCase();
                                    final sender = (msg['sender'] ?? '').toString().toLowerCase();
                                    return message.contains(_searchQuery) || sender.contains(_searchQuery);
                                  }).toList();
                            
                            // Auto-scroll to bottom when new messages arrive
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_scrollController.hasClients && _searchQuery.isEmpty) {
                                _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent,
                                );
                              }
                            });

                            return ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                              itemCount: filteredMessages.length,
                              itemBuilder: (context, index) {
                                final msg = filteredMessages[index];
                                final sender = msg['sender'] ?? 'Unknown';
                                final message = msg['message'] ?? '';
                                final isMe = sender == _currentUser;
                                final isTeacher = sender.toLowerCase().contains('teacher') || 
                                                 sender.toLowerCase().contains('prof') ||
                                                 sender.toLowerCase().contains('sir') ||
                                                 sender.toLowerCase().contains('madam');

                                return _buildMessageBubble(
                                  messageId: msg['id'],
                                  sender: sender,
                                  message: message,
                                  isMe: isMe,
                                  isTeacher: isTeacher,
                                  replyTo: msg['reply_message'],
                                  replySender: msg['reply_sender'],
                                  reactions: msg['reactions'],
                                  messageType: msg['message_type'],
                                  expiresAt: msg['expires_at'],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Typing indicator
              const TypingIndicator(),

              // Input Bar - Pinned to bottom
              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Reply preview
                    if (_replyingTo != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.reply, color: Colors.cyanAccent, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Replying to ${_replyingTo!['sender']}',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.cyanAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _replyingTo!['message'],
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey, size: 16),
                              onPressed: () {
                                setState(() {
                                  _replyingTo = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    
                    // Disappearing message indicator
                    if (_disappearingDuration != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer, color: Colors.orange, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Message will disappear after ${_formatDuration(_disappearingDuration!)}',
                                style: GoogleFonts.montserrat(
                                  color: Colors.orange,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.orange, size: 16),
                              onPressed: () {
                                setState(() {
                                  _disappearingDuration = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    
                    // Quick emoji bar removed to save space
                    
                    const SizedBox(height: 8),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Attachment Buttons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildAttachmentButton(
                               icon: Icons.mic,
                               color: Colors.purple,
                               onTap: () {
                                 HapticFeedback.mediumImpact();
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(content: Text('Voice messages coming soon!'), backgroundColor: Colors.purple),
                                 );
                               }
                            ),
                            const SizedBox(width: 8),
                            _buildAttachmentButton(
                               icon: Icons.gif_box,
                               color: Colors.green,
                               onTap: () {
                                 HapticFeedback.mediumImpact();
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(content: Text('GIFs & Stickers coming soon!'), backgroundColor: Colors.green),
                                 );
                               }
                            ),
                             const SizedBox(width: 8),
                             _buildAttachmentButton(
                               icon: Icons.timer,
                               color: _disappearingDuration != null ? Colors.orange : Colors.grey,
                               onTap: _showDisappearingDialog,
                            ),
                             const SizedBox(width: 8),
                             _buildAttachmentButton(
                               icon: Icons.poll,
                               color: Colors.cyanAccent,
                               onTap: _showPollCreator,
                            ),
                          ],
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Text Input Field
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.grey.shade900.withOpacity(0.8),
                                  Colors.black.withOpacity(0.9),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.cyanAccent.withOpacity(0.2),
                              ),
                            ),
                            child: TextField(
                              controller: _messageController,
                              focusNode: _focusNode,
                              style: const TextStyle(color: Colors.white),
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(color: Colors.grey.shade500),
                                filled: false,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.amber, size: 20),
                                  onPressed: () {
                                     // TODO: Show emoji picker
                                  },
                                ),
                              ),
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _sendMessage(),
                              onChanged: _onTypingChanged,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Send Button
                        AnimatedBuilder(
                          animation: _fabScaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _fabScaleAnimation.value,
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  _sendMessage();
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Colors.cyanAccent, Colors.blueAccent],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyanAccent.withOpacity(0.4),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ],
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required int messageId,
    required String sender,
    required String message,
    required bool isMe,
    required bool isTeacher,
    String? replyTo,
    String? replySender,
    dynamic reactions,
    String? messageType,
    String? expiresAt,
  }) {
    // Check if it's a poll
    if (messageType == 'poll') {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: PollWidget(messageId: messageId)
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0, duration: 600.ms),
      );
    }
    
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.grey.shade900,
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.reply, color: Colors.cyanAccent),
                  title: const Text('Reply', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _replyToMessage({'id': messageId, 'sender': sender, 'message': message});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_emotions, color: Colors.yellow),
                  title: const Text('React', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _showReactionPicker(messageId);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark_border, color: Colors.blue),
                  title: const Text('Bookmark', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _toggleBookmark(messageId);
                  },
                ),
                if (_currentRole == 'teacher')
                  ListTile(
                    leading: const Icon(Icons.push_pin, color: Colors.orange),
                    title: const Text('Pin Message', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      _togglePin(messageId, false);
                    },
                  ),
                if (sender == _currentUser || _currentRole == 'teacher')
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Delete', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteMessage(messageId, sender);
                    },
                  ),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe) ...[
              // Enhanced Avatar for others
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isTeacher 
                    ? const LinearGradient(colors: [Colors.orange, Colors.deepOrange])
                    : LinearGradient(colors: [Colors.grey.shade800, Colors.grey.shade700]),
                  boxShadow: [
                    BoxShadow(
                      color: (isTeacher ? Colors.orange : Colors.cyanAccent).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: Text(
                    sender[0].toUpperCase(),
                    style: TextStyle(
                      color: isTeacher ? Colors.white : Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(delay: 100.ms, duration: 400.ms)
                  .fadeIn(),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            sender,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: isTeacher ? Colors.orange : Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isTeacher) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 14,
                              color: Colors.orange,
                            ),
                          ],
                        ],
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: isMe
                          ? const LinearGradient(
                              colors: [Color(0xFF00BCD4), Color(0xFF2196F3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : isTeacher
                              ? LinearGradient(
                                  colors: [
                                    Colors.grey.shade800,
                                    Colors.grey.shade700,
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    const Color(0xFF2A2A2A),
                                    Colors.grey.shade800,
                                  ],
                                ),
                      border: isTeacher && !isMe
                          ? Border.all(
                              color: Colors.orange,
                              width: 2,
                            )
                          : Border.all(
                              color: isMe 
                                ? Colors.cyanAccent.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.2),
                              width: 1,
                            ),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: Radius.circular(isMe ? 20 : 6),
                        bottomRight: Radius.circular(isMe ? 6 : 20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isMe 
                            ? Colors.cyanAccent.withOpacity(0.4)
                            : isTeacher
                                ? Colors.orange.withOpacity(0.3)
                                : Colors.black.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reply preview
                        if (replyTo != null && replySender != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  replySender,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  replyTo,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        Text(
                          message,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        // Reactions display
                        if (reactions != null && reactions is Map && reactions.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: (reactions as Map<String, dynamic>).entries.map((entry) {
                                final emoji = entry.key;
                                final users = List<String>.from(entry.value);
                                final count = users.length;
                                final hasReacted = users.contains(_currentUser);
                                
                                return GestureDetector(
                                  onTap: () => _reactToMessage(messageId, emoji),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: hasReacted 
                                          ? Colors.cyanAccent.withOpacity(0.3)
                                          : Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: hasReacted 
                                            ? Colors.cyanAccent
                                            : Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(emoji, style: const TextStyle(fontSize: 14)),
                                        if (count > 1) ...[
                                          const SizedBox(width: 4),
                                          Text(
                                            '$count',
                                            style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        // Disappearing message timer
                        if (expiresAt != null)
                          Builder(
                            builder: (context) {
                              final timeRemaining = ChatEnhancedService.getTimeRemaining(expiresAt);
                              if (timeRemaining != null && timeRemaining.inSeconds > 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.orange),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.timer, color: Colors.orange, size: 12),
                                        const SizedBox(width: 4),
                                        Text(
                                          _formatTimeRemaining(timeRemaining),
                                          style: GoogleFonts.montserrat(
                                            color: Colors.orange,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (isMe) ...[
              const SizedBox(width: 12),
              // Enhanced Avatar for me
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.cyanAccent, Colors.blue],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 20,
                  child: Text(
                    sender[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(delay: 100.ms, duration: 400.ms)
                  .fadeIn(),
            ],
          ],
        )
            .animate()
            .fadeIn(duration: 600.ms, curve: Curves.easeOutCubic)
            .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(0.95, 0.95), duration: 600.ms, curve: Curves.easeOutCubic),
      ),
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}