-- ============================================================
-- FluxFlow Authentication & Subscription System
-- Run this SQL in Supabase SQL Editor
-- ============================================================

-- 1. Create the 'students' table (replaces Hive user_prefs)
CREATE TABLE IF NOT EXISTS students (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  regd_no TEXT NOT NULL UNIQUE,        -- Unique ID (Roll Number)
  group_name TEXT NOT NULL,            -- 'CSE', 'ECE', etc.
  section TEXT NOT NULL,               -- 'A', 'B'
  year TEXT NOT NULL,                  -- '1st Year', '2nd Year'
  image_url TEXT,                      -- Optional Profile Picture
  subscription_tier TEXT DEFAULT 'free', -- 'free', 'pro', 'ultra'
  subscription_end_date TIMESTAMPTZ,   -- When subscription expires (optional)
  badge_url TEXT,                      -- Custom badge icon
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create the 'payment_requests' table for Manual UTR Verification
CREATE TABLE IF NOT EXISTS payment_requests (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id UUID REFERENCES students(id) ON DELETE CASCADE NOT NULL,
  utr_number TEXT NOT NULL,
  requested_plan TEXT NOT NULL,        -- 'pro', 'ultra'
  amount TEXT NOT NULL,                -- '49', '99'
  status TEXT DEFAULT 'pending',       -- 'pending', 'approved', 'rejected'
  admin_notes TEXT,                    -- Notes from admin
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Add 'min_tier_required' column to books table (if not exists)
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'books' AND column_name = 'min_tier_required'
  ) THEN
    ALTER TABLE books ADD COLUMN min_tier_required TEXT DEFAULT 'free';
  END IF;
END $$;

-- 4. Create a helper function to get tier level (for comparisons)
CREATE OR REPLACE FUNCTION get_tier_level(tier TEXT) 
RETURNS INTEGER AS $$
BEGIN
  RETURN CASE 
    WHEN tier = 'ultra' THEN 3
    WHEN tier = 'pro' THEN 2
    ELSE 1  -- free
  END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- 5. Create RLS (Row Level Security) policies
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_requests ENABLE ROW LEVEL SECURITY;

-- Allow public read/write for students (simple auth model)
DROP POLICY IF EXISTS "Allow public access to students" ON students;
CREATE POLICY "Allow public access to students" ON students
  FOR ALL USING (true) WITH CHECK (true);

-- Allow public access to payment_requests
DROP POLICY IF EXISTS "Allow public access to payment_requests" ON payment_requests;
CREATE POLICY "Allow public access to payment_requests" ON payment_requests
  FOR ALL USING (true) WITH CHECK (true);

-- 6. Create indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_students_regd_no ON students(regd_no);
CREATE INDEX IF NOT EXISTS idx_students_name ON students(name);
CREATE INDEX IF NOT EXISTS idx_payment_requests_status ON payment_requests(status);
CREATE INDEX IF NOT EXISTS idx_payment_requests_student_id ON payment_requests(student_id);

-- 7. Optional: Create storage bucket for profile images
INSERT INTO storage.buckets (id, name, public) 
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

-- ============================================================
-- ADMIN QUERIES (Use these in Supabase Dashboard)
-- ============================================================

-- View pending payment requests:
-- SELECT pr.*, s.name, s.regd_no 
-- FROM payment_requests pr 
-- JOIN students s ON pr.student_id = s.id 
-- WHERE pr.status = 'pending';

-- Approve a payment (replace UUID and tier):
-- UPDATE students SET subscription_tier = 'pro' WHERE id = 'UUID_HERE';
-- UPDATE payment_requests SET status = 'approved' WHERE id = 'REQUEST_UUID_HERE';

-- View all Pro/Ultra users:
-- SELECT name, regd_no, subscription_tier FROM students WHERE subscription_tier != 'free';
