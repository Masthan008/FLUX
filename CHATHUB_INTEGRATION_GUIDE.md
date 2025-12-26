# ChatHub Enhanced Features - Quick Integration Guide

## 🎯 Quick Start

All the backend services and UI widgets are ready. Here's how to integrate them into your existing chat screen.

---

## Step 1: Run SQL Setup (REQUIRED)

Open Supabase SQL Editor and run:
```
SUPABASE_CHATHUB_ENHANCED_SETUP.sql
```

This creates all necessary tables:
- `message_reactions`
- `chat_polls`
- `poll_votes`
- `message_threads`
- `user_typing`
- `message_bookmarks`

---

## Step 2: Add Imports to chat_screen.dart

Add these at the top of `lib/screens/chat_screen.dart`:

```dart
import '../services/chat_enhanced_service.dart';
import '../widgets/emoji_reaction_picker.dart';
import '../widgets/poll_creator_dialog.dart';
import '../widgets/poll_widget.dart';
import '../widgets/disappearing_message_dialog.dart';
import '../widgets/pinned_messages_banner.dart';
import '../widgets/typing_indicator.dart';
```

---

## Step 3: Add State Variables

Add to `_ChatScreenState`:

```dart
Duration? _disappearingDuration; // For disappearing messages
Timer? _typingTimer; // For typing indicator
```

---

## Step 4: Update AppBar

Replace the existing AppBar with:

```dart
appBar: AppBar(
  backgroundColor: Colors.grey.shade900,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Hub - Chatroom',
        style: GoogleFonts.orbitron(
          color: Colors.cyanAccent,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
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
            ),
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
  iconTheme: const IconThemeData(color: Colors.cyanAccent),
  actions: [
    // NEW: Bookmarks button
    IconButton(
      icon: const Icon(Icons.bookmark_border),
      onPressed: _showBookmarks,
      tooltip: 'Bookmarks',
    ),
    // Existing search button
    IconButton(
      icon: Icon(_isSearching ? Icons.close : Icons.search),
      onPressed: () {
        setState(() {
          _isSearching = !_isSearching;
          if (!_isSearching) {
            _searchQuery = '';
            _searchController.clear();
          }
        });
      },
    ),
  ],
),
```

---

## Step 5: Update Body with Pinned Banner

Replace the body Column with:

```dart
body: Column(
  children: [
    // NEW: Pinned messages banner
    PinnedMessagesBanner(
      onMessageTap: (message) {
        // TODO: Scroll to message (optional)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pinned: ${message['message']}')),
        );
      },
    ),
    
    // Messages List - Takes all available space
    Expanded(
      child: Column(
        children: [
          // Search bar (existing)
          if (_isSearching) ...[
            // Your existing search bar
          ],
          
          // Messages stream (existing)
          Expanded(
            child: Container(
              // Your existing StreamBuilder
            ),
          ),
        ],
      ),
    ),

    // NEW: Typing indicator
    const TypingIndicator(),

    // Input Bar (modified below)
    Container(
      padding: const EdgeInsets.only(
        bottom: 80,
        left: 10,
        right: 10,
        top: 10,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Reply preview (existing)
          if (_replyingTo != null) ...[
            // Your existing reply preview
          ],
          
          // NEW: Disappearing message indicator
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
          
          Row(
            children: [
              // NEW: Timer button
              IconButton(
                icon: Icon(
                  Icons.timer,
                  color: _disappearingDuration != null ? Colors.orange : Colors.grey,
                ),
                onPressed: _showDisappearingDialog,
                tooltip: 'Disappearing message',
              ),
              
              // NEW: Poll button
              IconButton(
                icon: const Icon(Icons.poll, color: Colors.cyanAccent),
                onPressed: _showPollCreator,
                tooltip: 'Create poll',
              ),
              
              // Existing text field (modified)
              Expanded(
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
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
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  // NEW: Typing indicator
                  onChanged: _onTypingChanged,
                ),
              ),
              const SizedBox(width: 8),
              
              // Existing send button
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blueAccent],
                    ),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.black,
                    size: 24,
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
```

---

## Step 6: Update _sendMessage Method

Replace with:

```dart
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
      // Regular message (existing code)
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
```

---

## Step 7: Add New Handler Methods

Add these methods to `_ChatScreenState`:

```dart
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
  
  if (created == true) {
    // Poll created successfully
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Poll created!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// Show emoji picker (update existing _showReactionPicker)
void _showReactionPicker(int messageId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => EmojiReactionPicker(
      onEmojiSelected: (emoji) async {
        await ChatEnhancedService.toggleReaction(messageId, emoji);
      },
    ),
  );
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
  // Cancel previous timer
  _typingTimer?.cancel();
  
  if (text.isNotEmpty) {
    // Set typing
    ChatEnhancedService.setTyping(true);
    
    // Auto-stop after 3 seconds
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
Future<void> _toggleBookmark(int messageId, bool isBookmarked) async {
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
```

---

## Step 8: Update Long-Press Menu

Update the `showModalBottomSheet` in `_buildMessageBubble`:

```dart
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
          // NEW: Bookmark option
          ListTile(
            leading: const Icon(Icons.bookmark_border, color: Colors.blue),
            title: const Text('Bookmark', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _toggleBookmark(messageId, false);
            },
          ),
          // NEW: Pin option (teacher only)
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
```

---

## Step 9: Update Message Bubble for Polls

In `_buildMessageBubble`, add poll detection:

```dart
Widget _buildMessageBubble({
  required int messageId,
  required String sender,
  required String message,
  required bool isMe,
  required bool isTeacher,
  String? replyTo,
  String? replySender,
  dynamic reactions,
  String? messageType, // NEW
  String? expiresAt, // NEW
}) {
  // Check if it's a poll
  if (messageType == 'poll') {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PollWidget(messageId: messageId),
    );
  }
  
  // Check if disappearing
  Duration? timeRemaining;
  if (expiresAt != null) {
    timeRemaining = ChatEnhancedService.getTimeRemaining(expiresAt);
  }
  
  return GestureDetector(
    onLongPress: () { /* existing long-press handler */ },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        // ... existing message bubble code ...
        
        // Add timer badge if disappearing
        if (timeRemaining != null && timeRemaining.inSeconds > 0)
          Container(
            margin: const EdgeInsets.only(top: 4),
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
      ),
    ),
  );
}

String _formatTimeRemaining(Duration duration) {
  if (duration.inHours > 0) {
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  } else if (duration.inMinutes > 0) {
    return '${duration.inMinutes}m';
  } else {
    return '${duration.inSeconds}s';
  }
}
```

---

## Step 10: Update StreamBuilder Query

Update the stream to include new fields:

```dart
stream: Supabase.instance.client
    .from('chat_messages')
    .stream(primaryKey: ['id'])
    .order('created_at', ascending: true),
```

And in the itemBuilder, pass the new fields:

```dart
return _buildMessageBubble(
  messageId: msg['id'],
  sender: sender,
  message: message,
  isMe: isMe,
  isTeacher: isTeacher,
  replyTo: msg['reply_message'],
  replySender: msg['reply_sender'],
  reactions: msg['reactions'],
  messageType: msg['message_type'], // NEW
  expiresAt: msg['expires_at'], // NEW
);
```

---

## Step 11: Cleanup on Dispose

Add to dispose method:

```dart
@override
void dispose() {
  _messageController.dispose();
  _searchController.dispose();
  _scrollController.dispose();
  _focusNode.dispose();
  _typingTimer?.cancel(); // NEW
  ChatEnhancedService.setTyping(false); // NEW
  super.dispose();
}
```

---

## ✅ That's It!

All features are now integrated! Test each feature:

1. ✅ Send disappearing message (tap timer icon)
2. ✅ Create poll (tap poll icon)
3. ✅ React to message (long-press → React)
4. ✅ Pin message (long-press → Pin, teacher only)
5. ✅ Bookmark message (long-press → Bookmark)
6. ✅ See typing indicators (start typing)
7. ✅ View bookmarks (tap bookmark icon in appbar)

---

## 🐛 Troubleshooting

**Issue:** Reactions not showing  
**Fix:** Make sure SQL setup is complete

**Issue:** Typing indicator not working  
**Fix:** Check Supabase realtime is enabled

**Issue:** Polls not creating  
**Fix:** Verify `chat_polls` table exists

**Issue:** Can't pin messages  
**Fix:** Ensure user role is 'teacher'

---

**Ready to use!** 🎉

