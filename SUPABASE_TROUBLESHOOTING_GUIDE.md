# Supabase Setup Troubleshooting Guide

## 🚨 Common SQL Errors and Solutions

### Error: "column does not exist"
**Problem**: The SQL script is trying to insert data into columns that haven't been created yet.

**Solution**: Use the step-by-step approach below.

## 📋 Step-by-Step Setup (Guaranteed to Work)

### Option 1: Minimal Setup (Recommended for Testing)

1. **Go to your Supabase Dashboard** → SQL Editor
2. **Copy and paste ONLY the following code** (one section at a time):

```sql
-- Step 1: Create storage bucket
INSERT INTO storage.buckets (id, name, public) 
VALUES ('user-backups', 'user-backups', false)
ON CONFLICT (id) DO NOTHING;
```

3. **Click "Run"** and wait for success message

4. **Copy and paste this next**:

```sql
-- Step 2: Create backup table
CREATE TABLE IF NOT EXISTS backup_metadata (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,
    backup_version TEXT DEFAULT '2.0.0',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

5. **Click "Run"** and wait for success

6. **Copy and paste this**:

```sql
-- Step 3: Create user profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT UNIQUE NOT NULL,
    email TEXT,
    display_name TEXT,
    preferences JSONB DEFAULT '{}',
    sync_settings JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

7. **Click "Run"** and wait for success

8. **Copy and paste this**:

```sql
-- Step 4: Enable security and create policies
ALTER TABLE backup_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all backup access" ON backup_metadata FOR ALL USING (true);
CREATE POLICY "Allow all profile access" ON user_profiles FOR ALL USING (true);
CREATE POLICY "Allow backup storage access" ON storage.objects FOR ALL USING (bucket_id = 'user-backups');
```

9. **Click "Run"** and wait for success

10. **Copy and paste this**:

```sql
-- Step 5: Grant permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
```

11. **Click "Run"** and wait for success

12. **Test with this**:

```sql
-- Step 6: Insert test data
INSERT INTO user_profiles (user_name, email, display_name, preferences, sync_settings) 
VALUES (
    'test_user', 
    'test@example.com', 
    'Test User',
    '{"theme": "dark"}',
    '{"backup_frequency": "weekly"}'
) ON CONFLICT (user_name) DO NOTHING;

-- Verify it worked
SELECT * FROM user_profiles;
SELECT * FROM backup_metadata;
```

### Option 2: Use Pre-made Scripts

If you want to try the complete setup:

1. **Use `SUPABASE_MINIMAL_SETUP.sql`** first (copy entire content, paste, run)
2. **If that works**, then try `SUPABASE_FIXED_SETUP.sql` for full features

## 🔧 Troubleshooting Specific Issues

### Issue: "relation does not exist"
**Solution**: 
- Make sure you created the tables first
- Check the "Tables" section in your Supabase dashboard
- If tables don't exist, run the CREATE TABLE commands again

### Issue: "permission denied"
**Solution**:
- Run the GRANT commands from Step 5 above
- Make sure RLS policies are created
- Check that you're using the correct project

### Issue: "bucket does not exist"
**Solution**:
- Go to Storage → Create bucket → name it "user-backups"
- Or run the INSERT INTO storage.buckets command

### Issue: "syntax error"
**Solution**:
- Copy each SQL block exactly as shown
- Don't modify the SQL unless you know what you're doing
- Run one block at a time, not all at once

## ✅ Verification Steps

After setup, verify everything works:

1. **Check Tables Exist**:
```sql
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('backup_metadata', 'user_profiles');
```

2. **Check Storage Bucket**:
- Go to Storage in Supabase dashboard
- Should see "user-backups" bucket

3. **Test App Features**:
- Open FluxFlow app
- Go to Settings → Data Management
- Try "Data Statistics" (should work even with empty data)
- Try "Full Backup" → "Local Only" (should create a file)

## 🆘 If Nothing Works

### Nuclear Option: Start Fresh

1. **Delete all tables**:
```sql
DROP TABLE IF EXISTS backup_metadata CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
```

2. **Delete storage bucket**:
- Go to Storage → user-backups → Settings → Delete bucket

3. **Start over** with the minimal setup above

### Alternative: Skip Cloud Features

If Supabase keeps giving issues:

1. **Comment out cloud features** in the app temporarily
2. **Use only local backup features**
3. **Set up Supabase later when you have more time**

The app will work fine with just local backups!

## 📞 Getting Help

If you're still stuck:

1. **Check the exact error message** in Supabase SQL editor
2. **Try the minimal setup first** (it's much simpler)
3. **Make sure your Supabase project is active** (not paused)
4. **Check your internet connection**

## 🎯 Quick Test

To test if your setup worked, run this in your app:

```dart
// Add this temporarily to your main.dart
import 'lib/services/data_management_test.dart';

// In your main() function:
DataManagementTest.runAllTests();
```

Check the debug console for test results!

## ✨ Success Indicators

You'll know it's working when:
- ✅ Tables appear in Supabase dashboard
- ✅ Storage bucket exists
- ✅ App "Data Statistics" shows numbers
- ✅ "Full Backup" creates files without errors
- ✅ No red error messages in debug console

Remember: The app works great even without Supabase! Cloud features are just a bonus.