import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatEnhancedService {
  static final _supabase = Supabase.instance.client;
  
  // Get current user
  static String _getCurrentUser() {
    final box = Hive.box('user_prefs');
    return box.get('user_name', defaultValue: 'Student');
  }
  
  // Get current role
  static String _getCurrentRole() {
    final box = Hive.box('user_prefs');
    return box.get('role', defaultValue: 'student');
  }
  
  // ==================== DISAPPEARING MESSAGES ====================
  
  /// Send message with expiry time
  static Future<bool> sendDisappearingMessage({
    required String message,
    required Duration expiresIn,
    int? replyToId,
  }) async {
    try {
      final userName = _getCurrentUser();
      final expiresAt = DateTime.now().add(expiresIn);
      
      final messageData = {
        'sender': userName,
        'message': message,
        'expires_at': expiresAt.toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      };
      
      if (replyToId != null) {
        final replyMsg = await _supabase
            .from('chat_messages')
            .select()
            .eq('id', replyToId)
            .single();
        
        messageData['reply_to'] = replyToId.toString();
        messageData['reply_message'] = replyMsg['message'];
        messageData['reply_sender'] = replyMsg['sender'];
      }
      
      await _supabase.from('chat_messages').insert(messageData);
      return true;
    } catch (e) {
      debugPrint('⚠️ Send disappearing message error: $e');
      return false;
    }
  }
  
  /// Get time remaining for disappearing message
  static Duration? getTimeRemaining(String? expiresAt) {
    if (expiresAt == null) return null;
    
    try {
      final expiry = DateTime.parse(expiresAt);
      final now = DateTime.now();
      
      if (expiry.isBefore(now)) return Duration.zero;
      return expiry.difference(now);
    } catch (e) {
      return null;
    }
  }
  
  /// Manually delete expired messages (call periodically)
  static Future<void> deleteExpiredMessages() async {
    try {
      await _supabase
          .from('chat_messages')
          .delete()
          .lt('expires_at', DateTime.now().toIso8601String())
          .not('expires_at', 'is', null);
      
      debugPrint('✅ Expired messages deleted');
    } catch (e) {
      debugPrint('⚠️ Delete expired messages error: $e');
    }
  }
  
  // ==================== MESSAGE REACTIONS ====================
  
  /// Add or remove reaction to message
  static Future<bool> toggleReaction(int messageId, String emoji) async {
    try {
      final userName = _getCurrentUser();
      
      // Check if reaction exists
      final existing = await _supabase
          .from('message_reactions')
          .select()
          .eq('message_id', messageId)
          .eq('user_name', userName)
          .eq('emoji', emoji)
          .maybeSingle();
      
      if (existing != null) {
        // Remove reaction
        await _supabase
            .from('message_reactions')
            .delete()
            .eq('id', existing['id']);
      } else {
        // Add reaction
        await _supabase.from('message_reactions').insert({
          'message_id': messageId,
          'user_name': userName,
          'emoji': emoji,
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('⚠️ Toggle reaction error: $e');
      return false;
    }
  }
  
  /// Get reactions for a message
  static Future<Map<String, List<String>>> getMessageReactions(int messageId) async {
    try {
      final response = await _supabase
          .from('message_reactions')
          .select()
          .eq('message_id', messageId);
      
      final reactions = <String, List<String>>{};
      
      for (var reaction in response) {
        final emoji = reaction['emoji'] as String;
        final userName = reaction['user_name'] as String;
        
        if (!reactions.containsKey(emoji)) {
          reactions[emoji] = [];
        }
        reactions[emoji]!.add(userName);
      }
      
      return reactions;
    } catch (e) {
      debugPrint('⚠️ Get reactions error: $e');
      return {};
    }
  }
  
  /// Stream reactions for a message
  static Stream<Map<String, List<String>>> streamMessageReactions(int messageId) {
    return _supabase
        .from('message_reactions')
        .stream(primaryKey: ['id'])
        .eq('message_id', messageId)
        .map((data) {
          final reactions = <String, List<String>>{};
          
          for (var reaction in data) {
            final emoji = reaction['emoji'] as String;
            final userName = reaction['user_name'] as String;
            
            if (!reactions.containsKey(emoji)) {
              reactions[emoji] = [];
            }
            reactions[emoji]!.add(userName);
          }
          
          return reactions;
        });
  }
  
  // ==================== POLLS ====================
  
  /// Create a poll
  static Future<int?> createPoll({
    required String question,
    required List<String> options,
    Duration? expiresIn,
  }) async {
    try {
      final userName = _getCurrentUser();
      
      // First create the message
      final messageResponse = await _supabase
          .from('chat_messages')
          .insert({
            'sender': userName,
            'message': '📊 Poll: $question',
            'message_type': 'poll',
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      
      final messageId = messageResponse['id'] as int;
      
      // Create poll data
      final pollOptions = options.asMap().entries.map((entry) {
        return {
          'index': entry.key,
          'text': entry.value,
          'votes': 0,
        };
      }).toList();
      
      final pollData = {
        'message_id': messageId,
        'question': question,
        'options': pollOptions,
        'created_by': userName,
      };
      
      if (expiresIn != null) {
        pollData['expires_at'] = DateTime.now().add(expiresIn).toIso8601String();
      }
      
      await _supabase.from('chat_polls').insert(pollData);
      
      return messageId;
    } catch (e) {
      debugPrint('⚠️ Create poll error: $e');
      return null;
    }
  }
  
  /// Vote on a poll
  static Future<bool> votePoll(int pollId, int optionIndex) async {
    try {
      final userName = _getCurrentUser();
      
      // Check if already voted
      final existing = await _supabase
          .from('poll_votes')
          .select()
          .eq('poll_id', pollId)
          .eq('user_name', userName)
          .maybeSingle();
      
      if (existing != null) {
        // Update vote
        await _supabase
            .from('poll_votes')
            .update({'option_index': optionIndex})
            .eq('id', existing['id']);
      } else {
        // New vote
        await _supabase.from('poll_votes').insert({
          'poll_id': pollId,
          'user_name': userName,
          'option_index': optionIndex,
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('⚠️ Vote poll error: $e');
      return false;
    }
  }
  
  /// Get poll results
  static Future<Map<String, dynamic>?> getPollResults(int messageId) async {
    try {
      final poll = await _supabase
          .from('chat_polls')
          .select()
          .eq('message_id', messageId)
          .maybeSingle();
      
      if (poll == null) return null;
      
      final pollId = poll['id'] as int;
      final votes = await _supabase
          .from('poll_votes')
          .select()
          .eq('poll_id', pollId);
      
      final options = List<Map<String, dynamic>>.from(poll['options']);
      
      // Count votes for each option
      for (var vote in votes) {
        final optionIndex = vote['option_index'] as int;
        if (optionIndex < options.length) {
          options[optionIndex]['votes'] = (options[optionIndex]['votes'] ?? 0) + 1;
        }
      }
      
      return {
        'poll_id': pollId,
        'question': poll['question'],
        'options': options,
        'total_votes': votes.length,
        'expires_at': poll['expires_at'],
      };
    } catch (e) {
      debugPrint('⚠️ Get poll results error: $e');
      return null;
    }
  }
  
  // ==================== PINNED MESSAGES ====================
  
  /// Pin a message (teacher only)
  static Future<bool> pinMessage(int messageId) async {
    try {
      final role = _getCurrentRole();
      if (role != 'teacher') {
        debugPrint('⚠️ Only teachers can pin messages');
        return false;
      }
      
      final userName = _getCurrentUser();
      
      await _supabase.from('chat_messages').update({
        'is_pinned': true,
        'pinned_by': userName,
        'pinned_at': DateTime.now().toIso8601String(),
      }).eq('id', messageId);
      
      return true;
    } catch (e) {
      debugPrint('⚠️ Pin message error: $e');
      return false;
    }
  }
  
  /// Unpin a message
  static Future<bool> unpinMessage(int messageId) async {
    try {
      final role = _getCurrentRole();
      if (role != 'teacher') {
        debugPrint('⚠️ Only teachers can unpin messages');
        return false;
      }
      
      await _supabase.from('chat_messages').update({
        'is_pinned': false,
        'pinned_by': null,
        'pinned_at': null,
      }).eq('id', messageId);
      
      return true;
    } catch (e) {
      debugPrint('⚠️ Unpin message error: $e');
      return false;
    }
  }
  
  /// Get pinned messages
  static Future<List<Map<String, dynamic>>> getPinnedMessages() async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select()
          .eq('is_pinned', true)
          .order('pinned_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get pinned messages error: $e');
      return [];
    }
  }
  
  // ==================== TYPING INDICATORS ====================
  
  /// Update typing status
  static Future<void> setTyping(bool isTyping) async {
    try {
      final userName = _getCurrentUser();
      
      await _supabase.from('user_typing').upsert({
        'user_name': userName,
        'is_typing': isTyping,
        'last_typed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('⚠️ Set typing error: $e');
    }
  }
  
  /// Get users currently typing
  static Stream<List<String>> streamTypingUsers() {
    final currentUser = _getCurrentUser();
    
    return _supabase
        .from('user_typing')
        .stream(primaryKey: ['user_name'])
        .eq('is_typing', true)
        .map((data) {
          final users = <String>[];
          final cutoff = DateTime.now().subtract(const Duration(seconds: 10));
          
          for (var user in data) {
            final userName = user['user_name'] as String;
            final lastTyped = DateTime.parse(user['last_typed_at']);
            
            // Only show if typed in last 10 seconds and not current user
            if (userName != currentUser && lastTyped.isAfter(cutoff)) {
              users.add(userName);
            }
          }
          
          return users;
        });
  }
  
  // ==================== THREADS ====================
  
  /// Get thread replies for a message
  static Future<List<Map<String, dynamic>>> getThreadReplies(int parentMessageId) async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select()
          .eq('reply_to', parentMessageId)
          .order('created_at', ascending: true);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get thread replies error: $e');
      return [];
    }
  }
  
  /// Get thread count for a message
  static Future<int> getThreadCount(int parentMessageId) async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select('id')
          .eq('reply_to', parentMessageId);
      
      return (response as List).length;
    } catch (e) {
      debugPrint('⚠️ Get thread count error: $e');
      return 0;
    }
  }
  
  // ==================== BOOKMARKS ====================
  
  /// Bookmark a message
  static Future<bool> bookmarkMessage(int messageId) async {
    try {
      final userName = _getCurrentUser();
      
      await _supabase.from('message_bookmarks').insert({
        'message_id': messageId,
        'user_name': userName,
      });
      
      return true;
    } catch (e) {
      debugPrint('⚠️ Bookmark message error: $e');
      return false;
    }
  }
  
  /// Remove bookmark
  static Future<bool> unbookmarkMessage(int messageId) async {
    try {
      final userName = _getCurrentUser();
      
      await _supabase
          .from('message_bookmarks')
          .delete()
          .eq('message_id', messageId)
          .eq('user_name', userName);
      
      return true;
    } catch (e) {
      debugPrint('⚠️ Unbookmark message error: $e');
      return false;
    }
  }
  
  /// Check if message is bookmarked
  static Future<bool> isBookmarked(int messageId) async {
    try {
      final userName = _getCurrentUser();
      
      final response = await _supabase
          .from('message_bookmarks')
          .select()
          .eq('message_id', messageId)
          .eq('user_name', userName)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }
  
  /// Get bookmarked messages
  static Future<List<Map<String, dynamic>>> getBookmarkedMessages() async {
    try {
      final userName = _getCurrentUser();
      
      final bookmarks = await _supabase
          .from('message_bookmarks')
          .select('message_id')
          .eq('user_name', userName);
      
      if (bookmarks.isEmpty) return [];
      
      final messageIds = bookmarks.map((b) => b['message_id']).toList();
      
      final messages = await _supabase
          .from('chat_messages')
          .select()
          .filter('id', 'in', '(${messageIds.join(',')})')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(messages);
    } catch (e) {
      debugPrint('⚠️ Get bookmarked messages error: $e');
      return [];
    }
  }
}
