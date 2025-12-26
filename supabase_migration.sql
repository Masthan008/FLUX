-- ========================================
-- FluxFlow Students OS - Database Migration
-- 3-Tier Subscription System Setup
-- ========================================

-- 1. Add subscription_tier to students table (if not exists)
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS subscription_tier text DEFAULT 'free';

-- IMPORTANT: Update existing rows with NULL or invalid values to 'free'
UPDATE students 
SET subscription_tier = 'free' 
WHERE subscription_tier IS NULL 
   OR subscription_tier NOT IN ('free', 'pro', 'ultra');

-- Add check constraint for valid tiers
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'valid_subscription_tier'
    ) THEN
        ALTER TABLE students 
        ADD CONSTRAINT valid_subscription_tier 
        CHECK (subscription_tier IN ('free', 'pro', 'ultra'));
    END IF;
END $$;

-- 2. Add mobile_number and email to students table
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS mobile_number text,
ADD COLUMN IF NOT EXISTS email text;

-- 3. Ensure image_url exists (for profile pictures)
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS image_url text;

-- 4. Add subscription_end_date for tracking expiry
ALTER TABLE students 
ADD COLUMN IF NOT EXISTS subscription_end_date timestamp with time zone;

-- 5. Update books table for min_tier_required (if not exists)
ALTER TABLE books 
ADD COLUMN IF NOT EXISTS min_tier_required text DEFAULT 'free';

-- Update existing NULL or invalid values to 'free'
UPDATE books 
SET min_tier_required = 'free' 
WHERE min_tier_required IS NULL 
   OR min_tier_required NOT IN ('free', 'pro', 'ultra');

-- Add check constraint for books
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint 
        WHERE conname = 'valid_book_tier'
    ) THEN
        ALTER TABLE books 
        ADD CONSTRAINT valid_book_tier 
        CHECK (min_tier_required IN ('free', 'pro', 'ultra'));
    END IF;
END $$;

-- 6. Migrate old is_premium boolean to min_tier_required
-- Set premium books to 'pro' tier
UPDATE books 
SET min_tier_required = 'pro' 
WHERE is_premium = true AND (min_tier_required IS NULL OR min_tier_required = 'free');

-- Set non-premium books to 'free' tier
UPDATE books 
SET min_tier_required = 'free' 
WHERE (is_premium = false OR is_premium IS NULL) AND min_tier_required IS NULL;

-- 7. Create payment_requests table (if not exists)
CREATE TABLE IF NOT EXISTS payment_requests (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id uuid REFERENCES students(id) ON DELETE CASCADE,
  utr_number text NOT NULL,
  requested_plan text NOT NULL CHECK (requested_plan IN ('pro', 'ultra')),
  amount text NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now()
);

-- Create index on student_id for faster lookups
CREATE INDEX IF NOT EXISTS idx_payment_requests_student_id ON payment_requests(student_id);
CREATE INDEX IF NOT EXISTS idx_payment_requests_status ON payment_requests(status);

-- 8. Grant permissions
GRANT ALL ON students TO authenticated;
GRANT ALL ON students TO anon;
GRANT ALL ON students TO service_role;

GRANT ALL ON books TO authenticated;
GRANT ALL ON books TO anon;
GRANT ALL ON books TO service_role;

GRANT ALL ON payment_requests TO authenticated;
GRANT ALL ON payment_requests TO anon;
GRANT ALL ON payment_requests TO service_role;

-- ========================================
-- Storage Bucket Setup
-- ========================================
-- IMPORTANT: Create the bucket first in Supabase Storage UI:
-- 1. Go to Storage in Supabase Dashboard
-- 2. Click "New Bucket"
-- 3. Name: "profile-images"
-- 4. Make it PUBLIC
-- 5. Set allowed MIME types: image/jpeg, image/png, image/webp
-- 6. Max file size: 5MB

-- ========================================
-- Storage Policies (Run AFTER creating bucket)
-- ========================================
-- Note: If policies already exist, you can skip this section or drop them first:
-- DROP POLICY IF EXISTS "Users can upload their profile images" ON storage.objects;
-- DROP POLICY IF EXISTS "Anyone can view profile images" ON storage.objects;
-- DROP POLICY IF EXISTS "Users can update their own profile images" ON storage.objects;
-- DROP POLICY IF EXISTS "Users can delete their own profile images" ON storage.objects;

-- Allow authenticated users to upload profile images
CREATE POLICY "Users can upload their profile images"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'profile-images');

-- Allow anyone to view profile images (public bucket)
CREATE POLICY "Anyone can view profile images"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'profile-images');

-- Allow authenticated users to update their profile images
CREATE POLICY "Users can update their own profile images"
ON storage.objects FOR UPDATE
TO authenticated
USING (bucket_id = 'profile-images');

-- Allow authenticated users to delete their profile images
CREATE POLICY "Users can delete their own profile images"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'profile-images');
