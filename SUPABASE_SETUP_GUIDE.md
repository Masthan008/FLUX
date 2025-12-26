# Supabase Setup Guide - Step by Step

## ⚠️ IMPORTANT: Run in This Exact Order

### Step 1: Run Main Profile Setup
**File:** `SUPABASE_PROFILE_SETUP.sql`

This creates all the core tables. Run the entire file in Supabase SQL Editor.

**What it creates:**
- user_profiles
- login_history
- user_activity
- shared_books
- book_likes
- focus_sessions
- study_streaks
- user_achievements
- chat_mentions
- focus_leaderboard (view)

**Expected Result:** All tables created successfully

---

### Step 2: Run Helper Functions
**File:** `SUPABASE_FUNCTIONS_SETUP.sql`

This adds helper functions and additional features.

**What it creates:**
- increment_book_likes()
- decrement_book_likes()
- increment_book_downloads()
- message_reports table
- Additional indexes
- Views for analytics

**Expected Result:** All functions and views created

---

### Step 3: Create Storage Bucket

**In Supabase Dashboard:**

1. Go to **Storage** section
2. Click **New Bucket**
3. Settings:
   ```
   Name: shared-files
   Public: ✅ Yes
   File size limit: 50 MB
   Allowed MIME types: 
     - application/pdf
     - application/msword
     - application/vnd.openxmlformats-officedocument.wordprocessingml.document
     - text/plain
     - application/vnd.ms-powerpoint
     - application/vnd.openxmlformats-officedocument.presentationml.presentation
     - image/jpeg
     - image/png
   ```

4. Click **Create Bucket**

---

### Step 4: Set Storage Policies

**In Supabase Dashboard > Storage > shared-files > Policies:**

#### Policy 1: Allow Public Uploads
```sql
-- Name: Anyone can upload files
-- Operation: INSERT
-- Policy definition:
true
```

#### Policy 2: Allow Public Downloads
```sql
-- Name: Anyone can read files
-- Operation: SELECT
-- Policy definition:
true
```

#### Policy 3: Allow Users to Delete Own Files
```sql
-- Name: Users can delete own files
-- Operation: DELETE
-- Policy definition:
(storage.foldername(name))[1] = auth.uid()::text
```

---

### Step 5: Enable Realtime (Optional)

**In Supabase Dashboard > Database > Replication:**

Enable realtime for these tables:
- ✅ user_profiles
- ✅ shared_books
- ✅ focus_sessions
- ✅ chat_messages
- ✅ chat_mentions

---

### Step 6: Test the Setup

Run these test queries in SQL Editor:

#### Test 1: Create a test user
```sql
INSERT INTO user_profiles (user_id, user_name, branch, role)
VALUES ('test_user_001', 'Test Student', 'CSE', 'student')
RETURNING *;
```

**Expected:** Returns the created user profile

#### Test 2: Log a login
```sql
INSERT INTO login_history (user_id, user_name, device_info)
VALUES ('test_user_001', 'Test Student', 'Android')
RETURNING *;
```

**Expected:** Returns the login record

#### Test 3: Create a focus session
```sql
INSERT INTO focus_sessions (user_id, duration_minutes, status, ambient_sound)
VALUES ('test_user_001', 25, 'completed', 'Rain')
RETURNING *;
```

**Expected:** Returns the focus session

#### Test 4: Share a book
```sql
INSERT INTO shared_books (title, author, subject, uploaded_by, uploader_name)
VALUES ('Test Book', 'Test Author', 'Computer Science', 'test_user_001', 'Test Student')
RETURNING *;
```

**Expected:** Returns the shared book

#### Test 5: Check leaderboard
```sql
SELECT * FROM focus_leaderboard LIMIT 5;
```

**Expected:** Returns leaderboard with test user

---

### Step 7: Verify All Tables Exist

Run this query to list all tables:

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Expected tables:**
- book_likes
- chat_mentions
- chat_messages
- focus_sessions
- login_history
- message_reports
- shared_books
- study_streaks
- user_achievements
- user_activity
- user_profiles

---

### Step 8: Verify All Functions Exist

```sql
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_type = 'FUNCTION'
ORDER BY routine_name;
```

**Expected functions:**
- award_achievement
- decrement_book_likes
- increment_book_downloads
- increment_book_likes
- update_last_login
- update_study_streak

---

## 🔧 Troubleshooting

### Error: "relation does not exist"
**Solution:** Run SUPABASE_PROFILE_SETUP.sql first

### Error: "foreign key constraint violation"
**Solution:** Create user profile before inserting related data

### Error: "function does not exist"
**Solution:** Run SUPABASE_FUNCTIONS_SETUP.sql

### Error: "storage bucket not found"
**Solution:** Create storage bucket in Dashboard

### Error: "permission denied"
**Solution:** Check RLS policies are enabled

---

## 🧪 Complete Test Script

Run this after setup to verify everything works:

```sql
-- Clean up test data first
DELETE FROM user_achievements WHERE user_id = 'test_user_001';
DELETE FROM focus_sessions WHERE user_id = 'test_user_001';
DELETE FROM shared_books WHERE uploaded_by = 'test_user_001';
DELETE FROM login_history WHERE user_id = 'test_user_001';
DELETE FROM user_profiles WHERE user_id = 'test_user_001';

-- Test 1: Create user
INSERT INTO user_profiles (user_id, user_name, branch, role)
VALUES ('test_user_001', 'Test Student', 'CSE', 'student');

-- Test 2: Log login
INSERT INTO login_history (user_id, user_name, device_info)
VALUES ('test_user_001', 'Test Student', 'Android');

-- Test 3: Create focus session
INSERT INTO focus_sessions (user_id, duration_minutes, status, ambient_sound)
VALUES ('test_user_001', 25, 'completed', 'Rain');

-- Test 4: Update streak
SELECT update_study_streak('test_user_001');

-- Test 5: Award achievement
SELECT award_achievement('test_user_001', 'focus', 'First Focus Session');

-- Test 6: Share book
INSERT INTO shared_books (title, author, subject, uploaded_by, uploader_name)
VALUES ('Test Book', 'Test Author', 'Computer Science', 'test_user_001', 'Test Student');

-- Test 7: Like book
INSERT INTO book_likes (book_id, user_id)
SELECT id, 'test_user_001' FROM shared_books WHERE uploaded_by = 'test_user_001' LIMIT 1;

-- Test 8: Increment likes
SELECT increment_book_likes((SELECT id FROM shared_books WHERE uploaded_by = 'test_user_001' LIMIT 1));

-- Test 9: Check leaderboard
SELECT * FROM focus_leaderboard WHERE user_id = 'test_user_001';

-- Test 10: Check user stats
SELECT 
  up.*,
  COUNT(DISTINCT fs.id) as focus_sessions,
  COUNT(DISTINCT sb.id) as books_shared,
  COUNT(DISTINCT ua.id) as achievements
FROM user_profiles up
LEFT JOIN focus_sessions fs ON up.user_id = fs.user_id
LEFT JOIN shared_books sb ON up.user_id = sb.uploaded_by
LEFT JOIN user_achievements ua ON up.user_id = ua.user_id
WHERE up.user_id = 'test_user_001'
GROUP BY up.id;

-- If all tests pass, you're good to go! ✅
```

---

## 📱 Flutter Integration

After Supabase setup is complete, integrate with Flutter:

### 1. Update main.dart
```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  // ... rest of initialization
}
```

### 2. Update auth flow
```dart
// In auth_screen.dart after successful login:
import 'package:your_app/services/profile_service.dart';

await ProfileService.syncProfile();
await ProfileService.logLogin();
await ProfileService.setOnlineStatus(true);
```

### 3. Update focus provider
```dart
// In focus_provider.dart after session completes:
import 'package:your_app/services/focus_service.dart';

await FocusService.saveFocusSession(
  durationMinutes: _sessionDuration ~/ 60,
  status: 'completed',
  ambientSound: _ambientSound,
);
```

### 4. Test in app
1. Login to app
2. Check Supabase Dashboard > Table Editor > user_profiles
3. You should see your user profile created
4. Complete a focus session
5. Check focus_sessions table
6. Verify data is syncing

---

## 🎯 Quick Verification Checklist

- [ ] SUPABASE_PROFILE_SETUP.sql ran without errors
- [ ] SUPABASE_FUNCTIONS_SETUP.sql ran without errors
- [ ] Storage bucket "shared-files" created
- [ ] Storage policies configured
- [ ] All 11 tables exist
- [ ] All 6 functions exist
- [ ] Test user created successfully
- [ ] Test focus session created
- [ ] Test book shared
- [ ] Leaderboard shows data
- [ ] Flutter app connected to Supabase
- [ ] Profile syncs on login
- [ ] Focus sessions save to database

---

## 🚀 You're Ready!

Once all checks pass, your Supabase backend is fully configured and ready for production use.

**Next Steps:**
1. Build UI screens for new features
2. Add profile stats screen
3. Add shared books tab
4. Add focus leaderboard
5. Add mentions badge in chat
6. Test with multiple users
7. Deploy to production

---

## 📞 Support

If you encounter issues:
1. Check error messages carefully
2. Verify table names match exactly
3. Ensure foreign keys reference existing data
4. Check RLS policies are enabled
5. Verify storage bucket exists
6. Test with sample data first

**Common Issues:**
- Foreign key errors → Create parent record first
- Permission denied → Check RLS policies
- Function not found → Run FUNCTIONS_SETUP.sql
- Storage errors → Create bucket and set policies

---

**Setup Complete! 🎉**
