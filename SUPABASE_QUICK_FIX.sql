-- ============================================
-- QUICK FIX FOR SUPABASE SETUP ERRORS
-- ============================================
-- Run this if you encountered errors during setup

-- Step 1: Drop problematic sample data section
-- (This was trying to insert before tables existed)

-- Step 2: Verify all tables exist
DO $$
BEGIN
  -- Check if shared_books exists
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'shared_books') THEN
    RAISE NOTICE 'ERROR: shared_books table does not exist!';
    RAISE NOTICE 'SOLUTION: Run SUPABASE_PROFILE_SETUP.sql first';
  ELSE
    RAISE NOTICE 'OK: shared_books table exists';
  END IF;
  
  -- Check if user_profiles exists
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'user_profiles') THEN
    RAISE NOTICE 'ERROR: user_profiles table does not exist!';
    RAISE NOTICE 'SOLUTION: Run SUPABASE_PROFILE_SETUP.sql first';
  ELSE
    RAISE NOTICE 'OK: user_profiles table exists';
  END IF;
  
  -- Check if user_achievements exists
  IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'user_achievements') THEN
    RAISE NOTICE 'ERROR: user_achievements table does not exist!';
    RAISE NOTICE 'SOLUTION: Run SUPABASE_PROFILE_SETUP.sql first';
  ELSE
    RAISE NOTICE 'OK: user_achievements table exists';
  END IF;
END $$;

-- Step 3: List all existing tables
SELECT 
  'Existing tables:' as info,
  table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Step 4: If tables don't exist, here's the correct order:

-- OPTION A: If NO tables exist yet
-- Run this entire block:

/*
-- This is the COMPLETE setup in correct order
-- Copy and run SUPABASE_PROFILE_SETUP.sql first, then come back here
*/

-- OPTION B: If tables exist but you got foreign key errors
-- This means you tried to insert sample data before creating the user

-- Create a sample user first:
INSERT INTO user_profiles (user_id, user_name, branch, role)
VALUES ('sample_user', 'Sample Student', 'CSE', 'student')
ON CONFLICT (user_id) DO NOTHING;

-- Now you can insert sample achievements:
INSERT INTO user_achievements (user_id, achievement_type, achievement_name)
VALUES 
  ('sample_user', 'focus', 'First Focus Session'),
  ('sample_user', 'focus', '10 Focus Sessions'),
  ('sample_user', 'focus', '100 Hours Focused'),
  ('sample_user', 'streak', '7 Day Streak'),
  ('sample_user', 'streak', '30 Day Streak'),
  ('sample_user', 'books', 'First Book Shared'),
  ('sample_user', 'chat', '100 Messages Sent')
ON CONFLICT DO NOTHING;

-- Step 5: Verify setup is complete
SELECT 
  'Setup verification:' as check_type,
  COUNT(*) as count,
  'user_profiles' as table_name
FROM user_profiles
UNION ALL
SELECT 
  'Setup verification:',
  COUNT(*),
  'shared_books'
FROM shared_books
UNION ALL
SELECT 
  'Setup verification:',
  COUNT(*),
  'focus_sessions'
FROM focus_sessions
UNION ALL
SELECT 
  'Setup verification:',
  COUNT(*),
  'user_achievements'
FROM user_achievements;

-- Step 6: Test that functions exist
SELECT 
  routine_name as function_name,
  'EXISTS' as status
FROM information_schema.routines 
WHERE routine_schema = 'public' 
  AND routine_type = 'FUNCTION'
  AND routine_name IN (
    'increment_book_likes',
    'decrement_book_likes',
    'increment_book_downloads',
    'update_study_streak',
    'award_achievement',
    'update_last_login'
  )
ORDER BY routine_name;

-- ============================================
-- COMPLETE RESET (Use only if needed)
-- ============================================
-- WARNING: This will delete ALL data!
-- Uncomment and run only if you want to start fresh

/*
-- Drop all tables in reverse order (respecting foreign keys)
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

-- Drop views
DROP VIEW IF EXISTS focus_leaderboard CASCADE;
DROP VIEW IF EXISTS daily_active_users CASCADE;
DROP VIEW IF EXISTS popular_books CASCADE;
DROP VIEW IF EXISTS top_contributors CASCADE;
DROP VIEW IF EXISTS chat_activity CASCADE;
DROP VIEW IF EXISTS achievement_leaderboard CASCADE;

-- Drop functions
DROP FUNCTION IF EXISTS increment_book_likes(BIGINT) CASCADE;
DROP FUNCTION IF EXISTS decrement_book_likes(BIGINT) CASCADE;
DROP FUNCTION IF EXISTS increment_book_downloads(BIGINT) CASCADE;
DROP FUNCTION IF EXISTS update_last_login(TEXT) CASCADE;
DROP FUNCTION IF EXISTS update_study_streak(TEXT) CASCADE;
DROP FUNCTION IF EXISTS award_achievement(TEXT, TEXT, TEXT) CASCADE;
DROP FUNCTION IF EXISTS update_modified_column() CASCADE;

-- Now run SUPABASE_PROFILE_SETUP.sql again
-- Then run SUPABASE_FUNCTIONS_SETUP.sql
*/

-- ============================================
-- FINAL CHECK
-- ============================================

-- Run this to see if everything is ready:
DO $$
DECLARE
  table_count INTEGER;
  function_count INTEGER;
BEGIN
  -- Count tables
  SELECT COUNT(*) INTO table_count
  FROM information_schema.tables 
  WHERE table_schema = 'public' 
    AND table_type = 'BASE TABLE'
    AND table_name IN (
      'user_profiles',
      'login_history',
      'user_activity',
      'shared_books',
      'book_likes',
      'focus_sessions',
      'study_streaks',
      'user_achievements',
      'chat_mentions'
    );
  
  -- Count functions
  SELECT COUNT(*) INTO function_count
  FROM information_schema.routines 
  WHERE routine_schema = 'public' 
    AND routine_type = 'FUNCTION'
    AND routine_name IN (
      'increment_book_likes',
      'decrement_book_likes',
      'increment_book_downloads',
      'update_study_streak',
      'award_achievement',
      'update_last_login'
    );
  
  RAISE NOTICE '========================================';
  RAISE NOTICE 'SETUP STATUS CHECK';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Tables found: % / 9 required', table_count;
  RAISE NOTICE 'Functions found: % / 6 required', function_count;
  
  IF table_count = 9 AND function_count = 6 THEN
    RAISE NOTICE 'STATUS: ✅ SETUP COMPLETE!';
    RAISE NOTICE 'You can now use the app with Supabase';
  ELSIF table_count = 0 THEN
    RAISE NOTICE 'STATUS: ❌ NO TABLES FOUND';
    RAISE NOTICE 'ACTION: Run SUPABASE_PROFILE_SETUP.sql';
  ELSIF function_count = 0 THEN
    RAISE NOTICE 'STATUS: ⚠️ TABLES OK, FUNCTIONS MISSING';
    RAISE NOTICE 'ACTION: Run SUPABASE_FUNCTIONS_SETUP.sql';
  ELSE
    RAISE NOTICE 'STATUS: ⚠️ INCOMPLETE SETUP';
    RAISE NOTICE 'ACTION: Check which tables/functions are missing';
  END IF;
  RAISE NOTICE '========================================';
END $$;
