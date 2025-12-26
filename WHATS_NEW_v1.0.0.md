

`
**Role:** You are a Lead Flutter Developer.
**Task:** Expand Syllabus to all subjects, Redesign Chat UI, and Fix Chat Input overlapping.

### 📚 Phase 1: The Master Syllabus Engine (`lib/modules/academic/syllabus_screen.dart`)
**Action:** Replace the specific "IP Syllabus" with a generic "Subject Syllabus".
**Logic:**
1.  **Data:** Create a static `Map<String, List<Map<String, String>>> syllabusData` inside the class.
    * **Add Data for:** 'LAAC' (Maths), 'CHE' (Chemistry), 'CE' (English), 'BME' (Mech), 'BCE' (Civil).
    * *Example Content:* "Unit 1: Matrices", "Unit 2: Calculus", etc. (Use standard B.Tech 1st year topics).
2.  **UI:**
    * **Dropdown:** At the top, allow selecting the Subject. Default to "IP".
    * **List:** Show `ExpansionTile` for each Unit.
3.  **Drawer Update:** Update `home_screen.dart` to point "Syllabus" to this new generic screen.

### 💬 Phase 2: Chat UI Overhaul (`lib/screens/chat_screen.dart`)
**Action:** Make it look like a modern messaging app and FIX the bottom button.
**UI Changes:**
1.  **Background:** Add a subtle pattern (or use a dark grey color `#121212`) so bubbles pop.
2.  **Bubbles:**
    * **Me:** Gradient Cyan/Blue (Right side).
    * **Others:** Dark Grey (Left side).
    * **Teacher:** Gold/Orange border (Left side).
3.  **Avatar:** Show a small CircleAvatar with the user's initials next to the bubble.

### 🛠️ Phase 3: Fix Chat Input (The "Button in Down" Fix)
**The Fix:** Do NOT use `bottomNavigationBar` or `FloatingActionButton` for the input.
**Structure:**
```dart
Scaffold(
  resizeToAvoidBottomInset: true, // Critical for keyboard
  body: Column(
    children: [
      Expanded(child: MessageList(...)), // Takes all space
      
      // The Input Bar (Pinned to bottom)
      Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 10, // Safe Area fix
          left: 10, 
          right: 10, 
          top: 10
        ),
        color: Colors.grey[900],
        child: Row(
          children: [
            Expanded(child: CustomTextField(...)),
            SendButton(...)
          ],
        ),
      ),
    ],
  ),
)
````

### 📝 EXECUTION PLAN

1.  **Create `syllabus_screen.dart`** (With data for all 6 subjects).
2.  **Update `chat_screen.dart`** (New UI + Input Fix).
3.  **Update `home_screen.dart`** (Link to new Syllabus).

**Action:** Start by generating the **`syllabus_screen.dart`**.

```

---

### 💡 Preview of the Syllabus Data (I will include this in the code)
The AI will generate standard RGMCET/JNTU style syllabus for:
* **LAAC:** Matrices, Eigen values, Mean Value Theorems, Multivariable Calculus.
* **Chemistry:** Atomic Structure, Electrochemistry, Polymers, Water Technology.
* **English:** Vocabulary, Grammar, Reading Comprehension, Writing Skills.
* **BME/BCE:** Forces, Friction, Surveying, Stones/Bricks.

**Run this, and your app content will be 100% complete!**
```