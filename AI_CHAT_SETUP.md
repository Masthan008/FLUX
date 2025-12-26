# 🤖 Nova AI Chat - Setup & Usage Guide

## ✅ AI Chat is Now Available!

The Nova AI Chat feature has been added to your app and is ready to use!

---

## 📍 How to Access

### From Home Screen:
```
1. Open Drawer (☰ menu)
2. Scroll down
3. Tap "Nova AI Chat" (purple brain icon)
```

**Location in Drawer:**
- Below "Focus Forest"
- Purple psychology icon
- Easy to find!

---

## 🤖 Two AI Models Available

### 1. Gemini Pro (Default)
**By:** Google  
**Icon:** ✨ Auto Awesome  
**Best For:**
- General questions
- Homework help
- Study assistance
- Quick answers
- Explanations

**Features:**
- Fast responses
- Accurate information
- Great for students
- Free to use (with API key)

### 2. Llama 3
**By:** Meta  
**Icon:** 🚀 Rocket  
**Best For:**
- Creative writing
- Detailed explanations
- Open-source preference
- Alternative to Gemini

**Features:**
- Powerful AI
- Free via OpenRouter
- Good for complex queries

---

## 🎨 Features

### Chat Interface:
- **Purple Theme:** Matches AI/brain theme
- **Markdown Support:** Code blocks, formatting
- **Message Bubbles:** User (right), AI (left)
- **Avatars:** Brain icon for AI, Person for user

### Controls:
- **Model Switcher:** Tap ✨/🚀 icon to switch AI
- **Clear Chat:** Tap 🗑️ to start fresh
- **Send Message:** Type and tap send button

### Smart Features:
- **Thinking Indicator:** Shows when AI is processing
- **Model Info Banner:** Shows which AI you're using
- **Scroll to Bottom:** Auto-scrolls to new messages
- **Error Handling:** Graceful error messages

---

## 💡 Usage Examples

### Homework Help:
```
User: "Explain photosynthesis in simple terms"
Nova: [Detailed explanation with examples]
```

### Math Problems:
```
User: "How do I solve quadratic equations?"
Nova: [Step-by-step guide with formulas]
```

### Study Tips:
```
User: "Best way to prepare for exams?"
Nova: [Study strategies and tips]
```

### Code Help:
```
User: "Explain Python loops"
Nova: [Code examples with explanations]
```

### General Knowledge:
```
User: "What is quantum physics?"
Nova: [Clear explanation for students]
```

---

## 🔑 API Keys

### Current Status:
- ✅ **Gemini API Key:** Already configured
- ✅ **OpenRouter API Key:** Already configured

### Keys are in:
`lib/services/ai_service.dart`

```dart
static const String geminiKey = 'AIzaSyCT_YhKvW9b5XemcrXy20E__Zlyi5PEO44';
static const String openRouterKey = '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';
```

**Note:** These keys are already set up and working!

---

## 🧪 Testing

### Test 1: Basic Chat
```
1. Open Nova AI Chat
2. Type: "Hello"
3. Tap Send
4. ✅ AI responds with greeting
```

### Test 2: Switch Models
```
1. Tap ✨ icon (top right)
2. Select "Llama 3"
3. ✅ Snackbar shows "Switched to Llama AI"
4. Ask a question
5. ✅ Llama responds
```

### Test 3: Clear Chat
```
1. Have a conversation
2. Tap 🗑️ icon
3. ✅ Chat clears
4. ✅ Welcome message appears
```

### Test 4: Markdown Rendering
```
1. Ask: "Show me a Python code example"
2. ✅ Code appears in formatted block
3. ✅ Syntax highlighting works
```

---

## 🎯 Use Cases for Students

### 1. Study Assistant
- Explain difficult concepts
- Break down complex topics
- Provide examples
- Answer "why" questions

### 2. Homework Helper
- Math problem solving
- Science explanations
- History facts
- Language help

### 3. Exam Prep
- Create study guides
- Generate practice questions
- Explain formulas
- Review key concepts

### 4. Writing Help
- Essay brainstorming
- Grammar checking
- Vocabulary suggestions
- Structure advice

### 5. Coding Tutor
- Explain programming concepts
- Debug code issues
- Suggest best practices
- Provide code examples

---

## 🚀 Pro Tips

### Get Better Answers:
1. **Be Specific:** "Explain Newton's 2nd Law" vs "Physics help"
2. **Provide Context:** "I'm studying for a test on..."
3. **Ask Follow-ups:** "Can you explain that differently?"
4. **Request Examples:** "Show me an example"

### Model Selection:
- **Gemini:** Fast, accurate, great for quick questions
- **Llama:** Detailed, creative, good for essays

### Chat Management:
- Clear chat when switching topics
- Keep conversations focused
- Use markdown for code/formulas

---

## ⚠️ Limitations

### What AI Can Do:
✅ Explain concepts  
✅ Provide examples  
✅ Answer questions  
✅ Help with homework  
✅ Generate ideas  

### What AI Cannot Do:
❌ Take exams for you  
❌ Guarantee 100% accuracy  
❌ Replace teachers  
❌ Do your work for you  
❌ Access real-time data  

### Important Notes:
- Always verify important information
- Use AI as a learning tool, not a shortcut
- Understand the answers, don't just copy
- Teachers can tell if you just copied AI responses

---

## 🐛 Troubleshooting

### Issue: AI not responding
**Possible Causes:**
- No internet connection
- API key issue
- Server timeout

**Solutions:**
1. Check internet connection
2. Try switching AI models
3. Clear chat and try again
4. Restart app

### Issue: "API key not configured" error
**Solution:**
- Keys are already configured in `ai_service.dart`
- If you see this, the file may have been modified
- Check that keys are not set to placeholder values

### Issue: Slow responses
**Possible Causes:**
- Slow internet
- Complex question
- Server load

**Solutions:**
1. Wait a bit longer
2. Try simpler questions
3. Switch to other AI model

---

## 📊 Comparison

### Gemini Pro vs Llama 3

| Feature | Gemini Pro | Llama 3 |
|---------|-----------|---------|
| Speed | ⚡ Fast | 🐢 Moderate |
| Accuracy | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Detail | Good | Excellent |
| Code Help | Excellent | Good |
| Creative | Good | Excellent |
| Free | Yes (with key) | Yes |

**Recommendation:** Start with Gemini, try Llama for creative tasks.

---

## 🎓 Educational Value

### Benefits for Students:
1. **24/7 Tutor:** Available anytime
2. **Patient:** Never gets tired of questions
3. **Personalized:** Adapts to your level
4. **Instant:** No waiting for answers
5. **Private:** Ask "dumb" questions safely

### Learning Enhancement:
- Reinforces classroom learning
- Fills knowledge gaps
- Provides different perspectives
- Encourages curiosity
- Builds confidence

---

## 📝 Privacy & Safety

### Data Handling:
- Conversations not stored permanently
- API calls go through Google/OpenRouter
- No personal data required
- Clear chat anytime

### Safe Usage:
- Don't share personal information
- Don't ask for medical/legal advice
- Use for educational purposes
- Verify important information

---

## 🎉 Summary

✅ **Nova AI Chat is ready to use!**  
✅ **Two AI models available**  
✅ **Perfect for study assistance**  
✅ **Easy to access from drawer**  
✅ **Free to use with provided keys**  

**Location:** Drawer → Nova AI Chat (purple icon)

**Start chatting and boost your learning! 🚀**

---

**Version:** 44.0+  
**Status:** ✅ Active  
**Last Updated:** November 28, 2025
