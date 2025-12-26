# ⚡ Quick Fix: C-Code Lab Not Updating

## Problem
New code snippets added to Supabase don't appear in the app.

## Solution (3 Steps)

### Step 1: Update Code ✅ DONE
The code has been fixed to order by `created_at` instead of `id`.

### Step 2: Run SQL in Supabase

1. Go to **Supabase Dashboard**
2. Click **SQL Editor**
3. Copy and paste this:

```sql
-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE code_snippets;

-- Fix Permissions
ALTER TABLE code_snippets ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow anonymous reads" ON code_snippets;

CREATE POLICY "Allow anonymous reads"
  ON code_snippets
  FOR SELECT
  TO anon
  USING (true);
```

4. Click **Run**

### Step 3: Restart App

1. Close app completely (swipe away)
2. Reopen app
3. Go to **C-Code Lab** → **Cloud** tab
4. Should see all code snippets

---

## Test It

### Quick Test:
1. In Supabase, go to **Table Editor** → `code_snippets`
2. Click **Insert Row**
3. Fill in:
   - title: "Test"
   - code: "printf('hello');"
   - output: "hello"
4. Save
5. **Check app** - should appear instantly!

---

## Still Not Working?

### Check 1: Internet
Make sure you have internet connection.

### Check 2: Supabase Keys
Verify in `lib/main.dart`:
```dart
await Supabase.initialize(
  url: 'YOUR_URL',  // Must be correct
  anonKey: 'YOUR_KEY',  // Must be correct
);
```

### Check 3: Table Exists
In Supabase SQL Editor:
```sql
SELECT * FROM code_snippets LIMIT 5;
```
Should return rows (not error).

### Check 4: Full Setup
Run the complete SQL script: `SUPABASE_CODE_SNIPPETS_SETUP.sql`

---

## Files Changed
- ✅ `lib/modules/coding/c_patterns_screen.dart` - Fixed stream ordering

## Documentation
- 📄 `C_CODE_LAB_REALTIME_FIX.md` - Detailed explanation
- 📄 `SUPABASE_CODE_SNIPPETS_SETUP.sql` - Complete SQL setup

---

**Status:** ✅ Fixed  
**Date:** November 28, 2025
