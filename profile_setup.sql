-- =====================================================
-- Profile Feature - Database Column Setup
-- =====================================================
-- Run this in Supabase SQL Editor to add profile columns
-- =====================================================

-- Add missing columns to students table
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS mobile_number TEXT,
ADD COLUMN IF NOT EXISTS email TEXT,
ADD COLUMN IF NOT EXISTS image_url TEXT;

-- Verify columns were added successfully
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'students' 
  AND column_name IN ('mobile_number', 'email', 'image_url');

-- Expected output:
-- mobile_number | text
-- email         | text
-- image_url     | text

-- =====================================================
-- MANUAL STEPS: Storage Bucket Setup
-- =====================================================
-- Go to Supabase Dashboard → Storage → Buckets
-- 
-- 1. Create bucket: "profile-images"
-- 2. Toggle "Public bucket" ON
-- 3. Add RLS policies:
--    - INSERT: Allow authenticated users
--    - SELECT: Allow public read access
-- =====================================================
