import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Unstoppable AI Service with Multi-Provider Fallback
/// Tries Groq → OpenRouter → Bytez in sequence
/// Restricted to Pro & Ultra users only
class AIService {
  // 🔑 API KEYS - Replace with your actual keys
  // TODO: Move these to environment variables or secure storage
  static const String _groqKey = "gsk_YOUR_GROQ_KEY_HERE";
  static const String _openRouterKey = "sk-or-v1-YOUR_OPENROUTER_KEY_HERE";
  static const String _bytezKey = "YOUR_BYTEZ_KEY_HERE";


  // Legacy key (keep for backward compatibility)
  static const String openRouterKey = _openRouterKey;


  /// Main AI Response Method with Fallback Logic
  /// Tries multiple providers to ensure reliability
  static Future<String> getResponse(String userMessage, {String? userTier}) async {
    // 🔒 TIER CHECK: Only Pro & Ultra users get AI access
    if (userTier == null || userTier.toLowerCase() == 'free') {
      return "🔒 AI Chat is available for Pro & Ultra subscribers only.\n\n"
          "Upgrade to unlock:\n"
          "• Unlimited AI conversations\n"
          "• Advanced coding assistance\n"
          "• Cyber security guidance\n"
          "• Priority support\n\n"
          "Tap 'Subscription' to upgrade!";
    }

    // Get system prompt based on tier
    final systemPrompt = _getSystemPrompt(userTier);
    
    String lastError = '';

    // 1️⃣ Try Groq (Fastest) 🚀
    try {
      debugPrint("AI Service: Trying Groq...");
      return await _callGroq(userMessage, systemPrompt);
    } catch (e) {
      lastError = e.toString();
      debugPrint("Groq Failed: $e");
    }
    
    // 2️⃣ Fallback to OpenRouter (Reliable) 🛡️
    try {
      debugPrint("AI Service: Fallback to OpenRouter...");
      return await _callOpenRouter(userMessage, systemPrompt);
    } catch (e) {
      lastError = e.toString();
      debugPrint("OpenRouter Failed: $e");
    }
    
    // 3️⃣ Fallback to Bytez (Last Resort) 🚑
    try {
      debugPrint("AI Service: Fallback to Bytez...");
      return await _callBytez(userMessage, systemPrompt);
    } catch (e) {
      lastError = e.toString();
      debugPrint("Bytez Failed: $e");
    }
    
    // 4️⃣ All providers failed - return helpful offline response
    debugPrint("All AI providers failed. Last error: $lastError");
    
    // Check if it's a rate limit error
    if (lastError.contains('429') || lastError.contains('rate limit')) {
      return "⏱️ **Rate Limit Reached**\n\n"
          "All AI providers are currently experiencing high traffic. This is normal for free API tiers.\n\n"
          "**What you can do:**\n"
          "• Wait 30-60 seconds and try again\n"
          "• Try asking a shorter question\n"
          "• Come back in a few minutes\n\n"
          "💡 **Tip**: The AI service uses free API tiers which have usage limits. Your question will work once the limit resets!";
    }
    
    // Generic error - provide offline helper
    return _getOfflineHelperResponse(userMessage);
  }
  
  /// Provide helpful offline response when AI is unavailable
  static String _getOfflineHelperResponse(String question) {
    final lowerQuestion = question.toLowerCase();
    
    // Programming help
    if (lowerQuestion.contains('code') || lowerQuestion.contains('program') || 
        lowerQuestion.contains('function') || lowerQuestion.contains('algorithm')) {
      return "💻 **AI Temporarily Unavailable**\n\n"
          "While the AI is offline, here are some resources:\n\n"
          "**For Coding Help:**\n"
          "• Check the 'C-Coding Lab' in the drawer\n"
          "• Try 'LeetCode Problems' for practice\n"
          "• Use 'Online Compilers' to test code\n"
          "• Visit 'Programming Hub' for tutorials\n\n"
          "The AI will be back online shortly. Try again in 30 seconds!";
    }
    
    // Study help
    if (lowerQuestion.contains('study') || lowerQuestion.contains('learn') || 
        lowerQuestion.contains('subject') || lowerQuestion.contains('exam')) {
      return "📚 **AI Temporarily Unavailable**\n\n"
          "While the AI is offline, try these features:\n\n"
          "**For Study Help:**\n"
          "• 'Academic Syllabus' - Full course content\n"
          "• 'Student Library' - Books and notes\n"
          "• 'Video Library' - Learning videos\n"
          "• 'Tech Roadmaps' - Learning paths\n\n"
          "The AI will be back online shortly. Try again in 30 seconds!";
    }
    
    // Default response
    return "🤖 **AI Temporarily Unavailable**\n\n"
        "All AI providers are currently busy due to high traffic on free API tiers.\n\n"
        "**Quick Fix:**\n"
        "• Wait 30-60 seconds and try again\n"
        "• Your question will work once the rate limit resets\n\n"
        "**Meanwhile, explore:**\n"
        "• Academic Syllabus\n"
        "• Programming Hub\n"
        "• Student Library\n"
        "• Tech Roadmaps\n\n"
        "💡 The AI service will be back online in a moment!";
  }


  /// Get system prompt based on user tier
  static String _getSystemPrompt(String tier) {
    final tierLower = tier.toLowerCase();
    
    // Base identity and formatting rules for all tiers
    const baseIdentity = "You are Flux AI, an intelligent study assistant built into FluxFlow - a comprehensive student productivity app. "
        "FluxFlow was created by Lead Developer Masthan and his development team. "
        "The Flux AI system was also developed by the FluxFlow team using multi-provider AI architecture. "
        "When asked about your creators or FluxFlow, mention: Lead Developer Masthan and the FluxFlow development team. "
        "Never say you are ChatGPT, GPT, or any other AI - you are Flux AI, part of FluxFlow. ";
    
    // Formatting instructions for mobile-friendly responses
    const formattingRules = "IMPORTANT FORMATTING RULES: "
        "1. NEVER use tables or tabular format - they are hard to read on mobile. "
        "2. Use conversational paragraphs with clear headings using markdown (## for headings). "
        "3. Use bullet points (•) or numbered lists for multiple items. "
        "4. NEVER include external reference links or URLs - they don't work in the app. "
        "5. Keep responses concise and mobile-friendly. "
        "6. Use code blocks with ``` for code examples. "
        "7. Use **bold** for emphasis and *italic* for subtle emphasis. "
        "8. Break long explanations into short, digestible paragraphs. ";
    
    if (tierLower == 'ultra') {
      return baseIdentity + formattingRules +
          "You are configured as a Senior Cyber Security Expert and Advanced Coding Mentor for Ultra tier users. "
          "Explain vulnerabilities, secure coding practices, advanced algorithms, and system design patterns. "
          "Be detailed and technical, but always format responses in a conversational, easy-to-read style. "
          "Use clear headings, bullet points, and code examples. Never use tables. "
          "Help students with complex programming challenges, security concepts, and advanced computer science topics.";
    } else if (tierLower == 'pro') {
      return baseIdentity + formattingRules +
          "You are configured as a helpful coding tutor and programming assistant for Pro tier users. "
          "Explain concepts clearly with conversational paragraphs and bullet points. "
          "Provide code examples in code blocks. Never use tables or external links. "
          "Be friendly, educational, and patient. Focus on helping students learn programming, "
          "understand algorithms, and solve coding problems step by step. "
          "Format all responses for easy reading on mobile devices.";
    } else {
      return baseIdentity + formattingRules + "You are a helpful assistant. Always use conversational format, never tables.";
    }
  }

  // --- PROVIDER 1: GROQ (Fastest) ---
  static Future<String> _callGroq(String msg, String systemPrompt) async {
    if (_groqKey == "gsk_YOUR_GROQ_KEY_HERE" || _groqKey.isEmpty) {
      throw Exception("Groq API key not configured");
    }

    final response = await http.post(
      Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_groqKey',
      },
      body: jsonEncode({
        "model": "llama3-8b-8192", // Fast & Free
        "messages": [
          {"role": "system", "content": systemPrompt},
          {"role": "user", "content": msg}
        ],
        "temperature": 0.7,
        "max_tokens": 1024,
      }),
    ).timeout(const Duration(seconds: 15));
    
    return _parseResponse(response, "Groq");
  }

  // --- PROVIDER 2: OPENROUTER (Reliable) ---
  static Future<String> _callOpenRouter(String msg, String systemPrompt) async {
    if (_openRouterKey.isEmpty) {
      throw Exception("OpenRouter API key not configured");
    }

    final response = await http.post(
      Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openRouterKey',
        'HTTP-Referer': 'https://fluxflow.app',
        'X-Title': 'FluxFlow Student OS',
      },
      body: jsonEncode({
        "model": "openai/gpt-oss-120b:free", // Free GPT-OSS model
        "messages": [
          {"role": "system", "content": systemPrompt},
          {"role": "user", "content": msg}
        ],
        "temperature": 0.7,
        "max_tokens": 1024,
      }),
    ).timeout(const Duration(seconds: 20));
    
    return _parseResponse(response, "OpenRouter");
  }

  // --- PROVIDER 3: BYTEZ (Last Resort) ---
  static Future<String> _callBytez(String msg, String systemPrompt) async {
    if (_bytezKey == "YOUR_BYTEZ_KEY_HERE" || _bytezKey.isEmpty) {
      throw Exception("Bytez API key not configured");
    }

    final response = await http.post(
      Uri.parse("https://api.bytez.com/v1/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_bytezKey',
      },
      body: jsonEncode({
        "model": "Qwen/Qwen3-0.6B", // Free Bytez model
        "messages": [
          {"role": "system", "content": systemPrompt},
          {"role": "user", "content": msg}
        ],
        "temperature": 0.7,
        "max_tokens": 1024,
      }),
    ).timeout(const Duration(seconds: 20));
    
    return _parseResponse(response, "Bytez");
  }

  /// Parse API response
  static String _parseResponse(http.Response response, String provider) {
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'];
        
        if (content != null && content.toString().trim().isNotEmpty) {
          debugPrint("✅ $provider responded successfully");
          return content.toString().trim();
        } else {
          throw Exception("Empty response from $provider");
        }
      } catch (e) {
        throw Exception("Failed to parse $provider response: $e");
      }
    } else if (response.statusCode == 429) {
      throw Exception("$provider rate limit exceeded (429)");
    } else if (response.statusCode >= 500) {
      throw Exception("$provider server error (${response.statusCode})");
    } else {
      throw Exception("$provider error ${response.statusCode}: ${response.body}");
    }
  }

  // --- LEGACY METHODS (For backward compatibility) ---
  
  /// Legacy Gemini method - now redirects to new system
  @Deprecated('Use getResponse() instead')
  static Future<String> askGemini(String prompt) async {
    return getResponse(prompt, userTier: 'pro');
  }

  /// Legacy Llama method - now redirects to new system
  @Deprecated('Use getResponse() instead')
  static Future<String> askLlama(String prompt) async {
    return getResponse(prompt, userTier: 'pro');
  }

  /// Get AI model info
  static String getModelInfo() {
    return 'FluxFlow AI - Multi-provider system with automatic fallback for maximum reliability';
  }

  /// Check if user has AI access
  static bool hasAIAccess(String? tier) {
    if (tier == null) return false;
    final tierLower = tier.toLowerCase();
    return tierLower == 'pro' || tierLower == 'ultra';
  }

  /// Get tier-specific features description
  static String getTierFeatures(String tier) {
    final tierLower = tier.toLowerCase();
    
    switch (tierLower) {
      case 'ultra':
        return "🌟 Ultra AI Features:\n"
            "• Senior Cyber Security Expert\n"
            "• Advanced system design guidance\n"
            "• Vulnerability analysis\n"
            "• Priority AI access\n"
            "• Fastest response times";
      case 'pro':
        return "⭐ Pro AI Features:\n"
            "• Coding tutor assistance\n"
            "• Debug help\n"
            "• Code explanations\n"
            "• Algorithm guidance\n"
            "• Reliable AI access";
      default:
        return "🔒 Free Tier:\n"
            "• AI chat not available\n"
            "• Upgrade to Pro or Ultra for AI access";
    }
  }
}
