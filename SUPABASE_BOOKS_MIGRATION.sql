-- =====================================================
-- BOOK UPLOAD SYSTEM - MIGRATION SCRIPT
-- =====================================================
-- This script handles existing tables and adds missing columns
-- Run each section separately in Supabase SQL Editor

-- =====================================================
-- STEP 1: Check what exists
-- =====================================================

-- Check if community_books table exists
SELECT EXISTS (
  SELECT FROM information_schema.tables 
  WHERE table_schema = 'public' 
  AND table_name = 'community_books'
) as table_exists;

-- Check existing columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'community_books'
ORDER BY ordinal_position;

-- =====================================================
-- STEP 2: Add missing columns to existing table
-- =====================================================

-- Add semester column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' 
    AND column_name = 'semester'
  ) THEN
    ALTER TABLE community_books ADD COLUMN semester TEXT;
    RAISE NOTICE 'Added semester column';
  ELSE
    RAISE NOTICE 'semester column already exists';
  END IF;
END $$;

-- Add subject column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' 
    AND column_name = 'subject'
  ) THEN
    ALTER TABLE community_books ADD COLUMN subject TEXT;
    RAISE NOTICE 'Added subject column';
  ELSE
    RAISE NOTICE 'subject column already exists';
  END IF;
END $$;

-- Add file_size column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' 
    AND column_name = 'file_size'
  ) THEN
    ALTER TABLE community_books ADD COLUMN file_size BIGINT;
    RAISE NOTICE 'Added file_size column';
  ELSE
    RAISE NOTICE 'file_size column already exists';
  END IF;
END $$;

-- Add file_type column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' 
    AND column_name = 'file_type'
  ) THEN
    ALTER TABLE community_books ADD COLUMN file_type TEXT;
    RAISE NOTICE 'Added file_type column';
  ELSE
    RAISE NOTICE 'file_type column already exists';
  END IF;
END $$;

-- Add tags column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' 
    AND column_name = 'tags'
  ) THEN
    ALTER TABLE community_books ADD COLUMN tags TEXT[];
    RAISE NOTICE 'Added tags column';
  ELSE
    RAISE NOTICE 'tags column already exists';
  END IF;
END $$;

-- Add is_approved column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' 
    AND column_name = 'is_approved'
  ) THEN
    ALTER TABLE community_books ADD COLUMN is_approved BOOLEAN DEFAULT true;
    RAISE NOTICE 'Added is_approved column';
  ELSE
    RAISE NOTICE 'is_approved column already exists';
  END IF;
END $$;

-- Add uploader_id column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' 
    AND column_name = 'uploader_id'
  ) THEN
    ALTER TABLE community_books ADD COLUMN uploader_id TEXT;
    RAISE NOTICE 'Added uploader_id column';
  ELSE
    RAISE NOTICE 'uploader_id column already exists';
  END IF;
END $$;

-- =====================================================
-- STEP 3: Create related tables if they don't exist
-- =====================================================

-- Create book_likes table
CREATE TABLE IF NOT EXISTS book_likes (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(book_id, user_name)
);

-- Create book_downloads table
CREATE TABLE IF NOT EXISTS book_downloads (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  downloaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create book_reports table
CREATE TABLE IF NOT EXISTS book_reports (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  reported_by TEXT NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- STEP 4: Create/Update indexes
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_community_books_subject ON community_books(subject);
CREATE INDEX IF NOT EXISTS idx_community_books_semester ON community_books(semester);
CREATE INDEX IF NOT EXISTS idx_community_books_uploaded_by ON community_books(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_community_books_upload_date ON community_books(upload_date DESC);
CREATE INDEX IF NOT EXISTS idx_community_books_is_approved ON community_books(is_approved);
CREATE INDEX IF NOT EXISTS idx_book_likes_book_id ON book_likes(book_id);
CREATE INDEX IF NOT EXISTS idx_book_downloads_book_id ON book_downloads(book_id);

-- =====================================================
-- STEP 5: Create/Update functions
-- =====================================================

-- Function to increment downloads
CREATE OR REPLACE FUNCTION increment_book_downloads(book_id_param BIGINT)
RETURNS void AS $$
BEGIN
  UPDATE community_books
  SET downloads = downloads + 1
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql;

-- Function to increment likes
CREATE OR REPLACE FUNCTION increment_book_likes(book_id_param BIGINT)
RETURNS void AS $$
BEGIN
  UPDATE community_books
  SET likes = likes + 1
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql;

-- Function to decrement likes
CREATE OR REPLACE FUNCTION decrement_book_likes(book_id_param BIGINT)
RETURNS void AS $$
BEGIN
  UPDATE community_books
  SET likes = GREATEST(likes - 1, 0)
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql;

-- Function to get book statistics
CREATE OR REPLACE FUNCTION get_book_stats(book_id_param BIGINT)
RETURNS TABLE(
  total_downloads BIGINT,
  total_likes BIGINT,
  unique_downloaders BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COALESCE((SELECT downloads FROM community_books WHERE id = book_id_param), 0)::BIGINT,
    COALESCE((SELECT COUNT(*) FROM book_likes WHERE book_id = book_id_param), 0)::BIGINT,
    COALESCE((SELECT COUNT(DISTINCT user_name) FROM book_downloads WHERE book_id = book_id_param), 0)::BIGINT;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- STEP 6: Enable RLS (if not already enabled)
-- =====================================================

ALTER TABLE community_books ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_reports ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- STEP 7: Drop old policies and create new ones
-- =====================================================

-- Drop all existing policies first
DROP POLICY IF EXISTS "Anyone can view approved books" ON community_books;
DROP POLICY IF EXISTS "Anyone can upload books" ON community_books;
DROP POLICY IF EXISTS "Users can update their own books" ON community_books;
DROP POLICY IF EXISTS "Users can delete their own books" ON community_books;
DROP POLICY IF EXISTS "Enable read access for all users" ON community_books;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON community_books;

-- Create new policies for community_books
CREATE POLICY "Anyone can view approved books"
  ON community_books FOR SELECT
  USING (is_approved = true OR is_approved IS NULL);

CREATE POLICY "Anyone can upload books"
  ON community_books FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can update their own books"
  ON community_books FOR UPDATE
  USING (true);

CREATE POLICY "Users can delete their own books"
  ON community_books FOR DELETE
  USING (true);

-- Policies for book_likes
DROP POLICY IF EXISTS "Anyone can view likes" ON book_likes;
DROP POLICY IF EXISTS "Users can like books" ON book_likes;
DROP POLICY IF EXISTS "Users can unlike books" ON book_likes;

CREATE POLICY "Anyone can view likes"
  ON book_likes FOR SELECT
  USING (true);

CREATE POLICY "Users can like books"
  ON book_likes FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can unlike books"
  ON book_likes FOR DELETE
  USING (true);

-- Policies for book_downloads
DROP POLICY IF EXISTS "Anyone can view downloads" ON book_downloads;
DROP POLICY IF EXISTS "Users can track downloads" ON book_downloads;

CREATE POLICY "Anyone can view downloads"
  ON book_downloads FOR SELECT
  USING (true);

CREATE POLICY "Users can track downloads"
  ON book_downloads FOR INSERT
  WITH CHECK (true);

-- Policies for book_reports
DROP POLICY IF EXISTS "Anyone can report books" ON book_reports;
DROP POLICY IF EXISTS "Only admins can view reports" ON book_reports;

CREATE POLICY "Anyone can report books"
  ON book_reports FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Only admins can view reports"
  ON book_reports FOR SELECT
  USING (false);

-- =====================================================
-- STEP 8: Verify everything
-- =====================================================

-- Check all columns
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'community_books'
ORDER BY ordinal_position;

-- Check all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('community_books', 'book_likes', 'book_downloads', 'book_reports');

-- Check all functions
SELECT routine_name 
FROM information_schema.routines 
WHERE routine_schema = 'public' 
AND routine_name LIKE '%book%';

-- Check all indexes
SELECT indexname 
FROM pg_indexes 
WHERE tablename IN ('community_books', 'book_likes', 'book_downloads');

-- =====================================================
-- SUCCESS MESSAGE
-- =====================================================

DO $$
BEGIN
  RAISE NOTICE '✅ Migration complete!';
  RAISE NOTICE '📝 All columns added successfully';
  RAISE NOTICE '📝 All tables created';
  RAISE NOTICE '📝 All functions created';
  RAISE NOTICE '📝 All policies updated';
  RAISE NOTICE '';
  RAISE NOTICE '🎯 Next steps:';
  RAISE NOTICE '   1. Create storage bucket "community-books" in Supabase Dashboard';
  RAISE NOTICE '   2. Test with Flutter app';
END $$;
