# Supabase Setup - Simple Instructions

## 🎯 What You Need to Do

You got errors because the SQL files were run in the wrong order. Here's the correct way:

---

## ✅ CORRECT SETUP ORDER

### Step 1: Run SUPABASE_PROFILE_SETUP.sql
**Location:** In your project root folder

**How to run:**
1. Open Supabase Dashboard
2. Go to **SQL Editor**
3. Click **New Query**
4. Copy ALL content from `SUPABASE_PROFILE_SETUP.sql`
5. Paste into SQL Editor
6. Click **Run** (or press Ctrl+Enter)

**What it does:**
- Creates 9 tables
- Creates 1 view (focus_leaderboard)
- Sets up security policies
- Creates helper functions

**Expected result:**
```
Success. No rows returned
```

---

### Step 2: Run SUPABASE_FUNCTIONS_SETUP.sql
**Location:** In your project root folder

**How to run:**
1. In Supabase SQL Editor
2. Click **New Query**
3. Copy ALL content from `SUPABASE_FUNCTIONS_SETUP.sql`
4. Paste into SQL Editor
5. Click **Run**

**What it does:**
- Adds helper functions for books
- Creates message_reports table
- Adds indexes for performance
- Creates analytics views

**Expected result:**
```
Success. No rows returned
```

---

### Step 3: Verify Setup
**Run this query to check:**

```sql
-- Copy and paste this into SQL Editor
SELECT 
  table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**You should see these 10 tables:**
1. book_likes
2. chat_mentions
3. chat_messages (already exists)
4. focus_sessions
5. login_history
6. message_reports
7. shared_books
8. study_streaks
9. user_achievements
10. user_activity
11. user_profiles

---

### Step 4: Create Storage Bucket

**In Supabase Dashboard:**

1. Click **Storage** in left sidebar
2. Click **New Bucket**
3. Enter name: `shared-files`
4. Check **Public bucket**
5. Click **Create bucket**

**Set policies:**
1. Click on `shared-files` bucket
2. Go to **Policies** tab
3. Click **New Policy**
4. Select **For full customization**
5. Add these 3 policies:

**Policy 1 - Upload:**
```
Name: Anyone can upload
Operation: INSERT
Policy: true
```

**Policy 2 - Download:**
```
Name: Anyone can download
Operation: SELECT
Policy: true
```

**Policy 3 - Delete:**
```
Name: Users can delete own files
Operation: DELETE
Policy: (storage.foldername(name))[1] = auth.uid()::text
```

---

## 🧪 Test Your Setup

Run this test query:

```sql
-- Test 1: Create a user
INSERT INTO user_profiles (user_id, user_name, branch, role)
VALUES ('test_001', 'Test User', 'CSE', 'student')
RETURNING *;

-- Test 2: Create a focus session
INSERT INTO focus_sessions (user_id, duration_minutes, status)
VALUES ('test_001', 25, 'completed')
RETURNING *;

-- Test 3: Share a book
INSERT INTO shared_books (title, author, subject, uploaded_by, uploader_name)
VALUES ('Test Book', 'Test Author', 'CS', 'test_001', 'Test User')
RETURNING *;

-- Test 4: Check leaderboard
SELECT * FROM focus_leaderboard LIMIT 5;
```

**If all 4 tests work, you're done! ✅**

---

## ❌ If You Got Errors

### Error: "relation does not exist"
**Fix:** You skipped Step 1. Run `SUPABASE_PROFILE_SETUP.sql` first.

### Error: "foreign key constraint violation"
**Fix:** You tried to insert data before creating the user. Create user profile first.

### Error: "function does not exist"
**Fix:** Run `SUPABASE_FUNCTIONS_SETUP.sql` (Step 2).

---

## 🔄 Start Over (If Needed)

If you want to completely reset and start fresh:

```sql
-- WARNING: This deletes everything!
-- Copy and run this in SQL Editor:

DROP TABLE IF EXISTS chat_mentions CASCADE;
DROP TABLE IF EXISTS user_achievements CASCADE;
DROP TABLE IF EXISTS study_streaks CASCADE;
DROP TABLE IF EXISTS focus_sessions CASCADE;
DROP TABLE IF EXISTS book_likes CASCADE;
DROP TABLE IF EXISTS shared_books CASCADE;
DROP TABLE IF EXISTS user_activity CASCADE;
DROP TABLE IF EXISTS login_history CASCADE;
DROP TABLE IF EXISTS message_reports CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP VIEW IF EXISTS focus_leaderboard CASCADE;

-- Now go back to Step 1 and run SUPABASE_PROFILE_SETUP.sql
```

---

## 📱 Connect Flutter App

After Supabase is set up, add to your Flutter app:

**In `main.dart`:**
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add this:
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  // ... rest of your code
}
```

**Get your URL and Key:**
1. Supabase Dashboard
2. Settings > API
3. Copy **Project URL** and **anon public** key

---

## ✅ Final Checklist

- [ ] Ran SUPABASE_PROFILE_SETUP.sql
- [ ] Ran SUPABASE_FUNCTIONS_SETUP.sql
- [ ] Created shared-files bucket
- [ ] Set storage policies
- [ ] Tested with sample data
- [ ] All tests passed
- [ ] Connected Flutter app
- [ ] Ready to use!

---

## 🎉 You're Done!

Your Supabase backend is now fully configured. The app can now:
- ✅ Sync user profiles
- ✅ Track login history
- ✅ Save focus sessions
- ✅ Share books with community
- ✅ Show leaderboards
- ✅ Track achievements
- ✅ Handle chat mentions

**Next:** Start using the services in your Flutter app!

---

## 📞 Need Help?

Check these files for more details:
- `SUPABASE_SETUP_GUIDE.md` - Detailed guide
- `SUPABASE_QUICK_FIX.sql` - Diagnostic queries
- `UPDATE_46_PROFILE_BOOKS_FOCUS_CHAT.md` - Feature documentation

**Common Issues:**
1. Tables not found → Run Step 1
2. Functions not found → Run Step 2
3. Storage errors → Create bucket (Step 4)
4. Permission errors → Check RLS policies

---

**That's it! Simple and straightforward.** 🚀
