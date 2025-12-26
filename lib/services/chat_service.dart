import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatService {
  static final _supabase = Supabase.instance.client;
  
  // Get current user ID
  static String _getCurrentUserId() {
    final box = Hive.box('user_prefs');
    return box.get('user_id', defaultValue: 'guest');
  }
  
  // Get current user name
  static String _getCurrentUserName() {
    final box = Hive.box('user_prefs');
    return box.get('user_name', defaultValue: 'Student');
  }
  
  // Send message with mention detection
  static Future<bool> sendMessage(String message, {int? replyToId}) async {
    try {
      final userId = _getCurrentUserId();
      final userName = _getCurrentUserName();
      
      // Detect mentions (@username)
      final mentionRegex = RegExp(r'@(\w+)');
      final mentions = mentionRegex.allMatches(message);
      
      final messageData = {
        'sender': userName,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      if (replyToId != null) {
        // Get reply message details
        final replyMsg = await _supabase
            .from('chat_messages')
            .select()
            .eq('id', replyToId)
            .single();
        
        messageData['reply_to'] = replyToId;
        messageData['reply_message'] = replyMsg['message'];
        messageData['reply_sender'] = replyMsg['sender'];
      }
      
      final response = await _supabase
          .from('chat_messages')
          .insert(messageData)
          .select()
          .single();
      
      final messageId = response['id'];
      
      // Create mention notifications
      for (var match in mentions) {
        final mentionedUsername = match.group(1);
        if (mentionedUsername != null) {
          await _createMention(messageId, mentionedUsername);
        }
      }
      
      debugPrint('✅ Message sent with ${mentions.length} mentions');
      return true;
    } catch (e) {
      debugPrint('⚠️ Send message error: $e');
      return false;
    }
  }
  
  // Create mention notification
  static Future<void> _createMention(int messageId, String mentionedUsername) async {
    try {
      // Find user by username
      final user = await _supabase
          .from('user_profiles')
          .select('user_id')
          .eq('user_name', mentionedUsername)
          .maybeSingle();
      
      if (user != null) {
        await _supabase.from('chat_mentions').insert({
          'message_id': messageId,
          'mentioned_user_id': user['user_id'],
          'is_read': false,
          'created_at': DateTime.now().toIso8601String(),
        });
        
        debugPrint('✅ Mention created for @$mentionedUsername');
      }
    } catch (e) {
      debugPrint('⚠️ Create mention error: $e');
    }
  }
  
  // Get unread mentions count
  static Future<int> getUnreadMentionsCount() async {
    try {
      final userId = _getCurrentUserId();
      
      final response = await _supabase
          .from('chat_mentions')
          .select('id')
          .eq('mentioned_user_id', userId)
          .eq('is_read', false);
      
      return (response as List).length;
    } catch (e) {
      debugPrint('⚠️ Get mentions count error: $e');
      return 0;
    }
  }
  
  // Get user mentions
  static Future<List<Map<String, dynamic>>> getUserMentions() async {
    try {
      final userId = _getCurrentUserId();
      
      final response = await _supabase
          .from('chat_mentions')
          .select('''
            *,
            chat_messages (
              id,
              sender,
              message,
              created_at
            )
          ''')
          .eq('mentioned_user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get mentions error: $e');
      return [];
    }
  }
  
  // Mark mention as read
  static Future<void> markMentionAsRead(int mentionId) async {
    try {
      await _supabase
          .from('chat_mentions')
          .update({'is_read': true})
          .eq('id', mentionId);
      
      debugPrint('✅ Mention marked as read');
    } catch (e) {
      debugPrint('⚠️ Mark mention error: $e');
    }
  }
  
  // Mark all mentions as read
  static Future<void> markAllMentionsAsRead() async {
    try {
      final userId = _getCurrentUserId();
      
      await _supabase
          .from('chat_mentions')
          .update({'is_read': true})
          .eq('mentioned_user_id', userId)
          .eq('is_read', false);
      
      debugPrint('✅ All mentions marked as read');
    } catch (e) {
      debugPrint('⚠️ Mark all mentions error: $e');
    }
  }
  
  // Get chat statistics
  static Future<Map<String, dynamic>> getChatStats() async {
    try {
      final userName = _getCurrentUserName();
      
      // Get total messages sent
      final messages = await _supabase
          .from('chat_messages')
          .select('id')
          .eq('sender', userName);
      
      final totalMessages = (messages as List).length;
      
      // Get messages with reactions
      final reactedMessages = await _supabase
          .from('chat_messages')
          .select('reactions')
          .eq('sender', userName)
          .not('reactions', 'is', null);
      
      int totalReactions = 0;
      for (var msg in reactedMessages) {
        if (msg['reactions'] != null && msg['reactions'] is Map) {
          final reactions = msg['reactions'] as Map;
          for (var users in reactions.values) {
            if (users is List) {
              totalReactions += users.length;
            }
          }
        }
      }
      
      // Get mentions received
      final userId = _getCurrentUserId();
      final mentions = await _supabase
          .from('chat_mentions')
          .select('id')
          .eq('mentioned_user_id', userId);
      
      final totalMentions = (mentions as List).length;
      
      return {
        'total_messages': totalMessages,
        'total_reactions': totalReactions,
        'total_mentions': totalMentions,
      };
    } catch (e) {
      debugPrint('⚠️ Get chat stats error: $e');
      return {
        'total_messages': 0,
        'total_reactions': 0,
        'total_mentions': 0,
      };
    }
  }
  
  // Search messages
  static Future<List<Map<String, dynamic>>> searchMessages(String query) async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select()
          .or('message.ilike.%$query%,sender.ilike.%$query%')
          .order('created_at', ascending: false)
          .limit(50);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Search messages error: $e');
      return [];
    }
  }
  
  // Get message by ID
  static Future<Map<String, dynamic>?> getMessage(int messageId) async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select()
          .eq('id', messageId)
          .maybeSingle();
      
      return response;
    } catch (e) {
      debugPrint('⚠️ Get message error: $e');
      return null;
    }
  }
  
  // Pin message (teacher only)
  static Future<bool> pinMessage(int messageId) async {
    try {
      await _supabase
          .from('chat_messages')
          .update({'is_pinned': true})
          .eq('id', messageId);
      
      debugPrint('✅ Message pinned');
      return true;
    } catch (e) {
      debugPrint('⚠️ Pin message error: $e');
      return false;
    }
  }
  
  // Unpin message
  static Future<bool> unpinMessage(int messageId) async {
    try {
      await _supabase
          .from('chat_messages')
          .update({'is_pinned': false})
          .eq('id', messageId);
      
      debugPrint('✅ Message unpinned');
      return true;
    } catch (e) {
      debugPrint('⚠️ Unpin message error: $e');
      return false;
    }
  }
  
  // Get pinned messages
  static Future<List<Map<String, dynamic>>> getPinnedMessages() async {
    try {
      final response = await _supabase
          .from('chat_messages')
          .select()
          .eq('is_pinned', true)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get pinned messages error: $e');
      return [];
    }
  }
  
  // Report message
  static Future<bool> reportMessage(int messageId, String reason) async {
    try {
      final userId = _getCurrentUserId();
      
      await _supabase.from('message_reports').insert({
        'message_id': messageId,
        'reported_by': userId,
        'reason': reason,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      debugPrint('✅ Message reported');
      return true;
    } catch (e) {
      debugPrint('⚠️ Report message error: $e');
      return false;
    }
  }
  
  // Get active users (who sent messages in last 24 hours)
  static Future<List<String>> getActiveUsers() async {
    try {
      final yesterday = DateTime.now().subtract(const Duration(hours: 24));
      
      final response = await _supabase
          .from('chat_messages')
          .select('sender')
          .gte('created_at', yesterday.toIso8601String());
      
      final messages = List<Map<String, dynamic>>.from(response);
      final users = messages.map((m) => m['sender'] as String).toSet().toList();
      
      return users;
    } catch (e) {
      debugPrint('⚠️ Get active users error: $e');
      return [];
    }
  }
}
