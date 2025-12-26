-- ============================================
-- Profile Image Storage Setup
-- ============================================
-- Run this in Supabase SQL Editor to set up storage policies
-- for the profile-images bucket
-- ============================================

-- Step 1: Create the storage bucket (if it doesn't exist)
-- NOTE: You may need to create this manually in the Supabase Dashboard
-- Go to Storage > Create Bucket > Name: "profile-images" > Public: Yes

-- Step 2: Create storage policies for the profile-images bucket

-- Allow authenticated users to upload their own profile images
INSERT INTO storage.policies (name, bucket_id, definition, check_expression)
VALUES (
  'Allow authenticated users to upload profile images',
  'profile-images',
  '(bucket_id = ''profile-images'')',
  '(bucket_id = ''profile-images'')'
)
ON CONFLICT DO NOTHING;

-- Allow public read access to all profile images
INSERT INTO storage.policies (name, bucket_id, definition)
VALUES (
  'Allow public read access to profile images',
  'profile-images',
  '(bucket_id = ''profile-images'')'
)
ON CONFLICT DO NOTHING;

-- ============================================
-- Alternative: Use Supabase Dashboard
-- ============================================
-- If the SQL above doesn't work, create policies manually:
-- 
-- 1. Go to Storage in Supabase Dashboard
-- 2. Click on "profile-images" bucket
-- 3. Go to "Policies" tab
-- 4. Click "New Policy"
-- 
-- Policy 1: Upload Policy
--   - Name: "Allow authenticated uploads"
--   - Allowed operation: INSERT
--   - Target roles: authenticated
--   - Policy definition: true
--
-- Policy 2: Read Policy
--   - Name: "Allow public reads"
--   - Allowed operation: SELECT
--   - Target roles: public
--   - Policy definition: true
--
-- ============================================

-- Verify bucket exists
SELECT * FROM storage.buckets WHERE id = 'profile-images';

-- If you need to create the bucket via SQL (alternative to dashboard):
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('profile-images', 'profile-images', true)
-- ON CONFLICT DO NOTHING;
