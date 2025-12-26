-- =====================================================
-- COMPLETE BOOK UPLOAD SYSTEM MIGRATION
-- =====================================================
-- This adds ALL missing columns to existing community_books table
-- Run this entire script in Supabase SQL Editor

-- =====================================================
-- STEP 1: Add ALL missing columns
-- =====================================================

-- Add uploaded_by column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'uploaded_by'
  ) THEN
    ALTER TABLE community_books ADD COLUMN uploaded_by TEXT NOT NULL DEFAULT 'Unknown';
    RAISE NOTICE '✅ Added uploaded_by column';
  END IF;
END $$;

-- Add uploader_id column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'uploader_id'
  ) THEN
    ALTER TABLE community_books ADD COLUMN uploader_id TEXT;
    RAISE NOTICE '✅ Added uploader_id column';
  END IF;
END $$;

-- Add upload_date column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'upload_date'
  ) THEN
    ALTER TABLE community_books ADD COLUMN upload_date TIMESTAMPTZ DEFAULT NOW();
    RAISE NOTICE '✅ Added upload_date column';
  END IF;
END $$;

-- Add downloads column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'downloads'
  ) THEN
    ALTER TABLE community_books ADD COLUMN downloads INTEGER DEFAULT 0;
    RAISE NOTICE '✅ Added downloads column';
  END IF;
END $$;

-- Add likes column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'likes'
  ) THEN
    ALTER TABLE community_books ADD COLUMN likes INTEGER DEFAULT 0;
    RAISE NOTICE '✅ Added likes column';
  END IF;
END $$;

-- Add semester column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'semester'
  ) THEN
    ALTER TABLE community_books ADD COLUMN semester TEXT;
    RAISE NOTICE '✅ Added semester column';
  END IF;
END $$;

-- Add subject column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'subject'
  ) THEN
    ALTER TABLE community_books ADD COLUMN subject TEXT;
    RAISE NOTICE '✅ Added subject column';
  END IF;
END $$;

-- Add file_size column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'file_size'
  ) THEN
    ALTER TABLE community_books ADD COLUMN file_size BIGINT;
    RAISE NOTICE '✅ Added file_size column';
  END IF;
END $$;

-- Add file_type column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'file_type'
  ) THEN
    ALTER TABLE community_books ADD COLUMN file_type TEXT;
    RAISE NOTICE '✅ Added file_type column';
  END IF;
END $$;

-- Add tags column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'tags'
  ) THEN
    ALTER TABLE community_books ADD COLUMN tags TEXT[] DEFAULT '{}';
    RAISE NOTICE '✅ Added tags column';
  END IF;
END $$;

-- Add is_approved column
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'is_approved'
  ) THEN
    ALTER TABLE community_books ADD COLUMN is_approved BOOLEAN DEFAULT true;
    RAISE NOTICE '✅ Added is_approved column';
  END IF;
END $$;

-- Add created_at column if missing
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT FROM information_schema.columns 
    WHERE table_name = 'community_books' AND column_name = 'created_at'
  ) THEN
    ALTER TABLE community_books ADD COLUMN created_at TIMESTAMPTZ DEFAULT NOW();
    RAISE NOTICE '✅ Added created_at column';
  END IF;
END $$;

-- =====================================================
-- STEP 2: Create related tables
-- =====================================================

CREATE TABLE IF NOT EXISTS book_likes (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(book_id, user_name)
);

CREATE TABLE IF NOT EXISTS book_downloads (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  downloaded_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS book_reports (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  reported_by TEXT NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- STEP 3: Create indexes
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_community_books_subject ON community_books(subject);
CREATE INDEX IF NOT EXISTS idx_community_books_semester ON community_books(semester);
CREATE INDEX IF NOT EXISTS idx_community_books_uploaded_by ON community_books(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_community_books_upload_date ON community_books(upload_date DESC);
CREATE INDEX IF NOT EXISTS idx_community_books_is_approved ON community_books(is_approved);
CREATE INDEX IF NOT EXISTS idx_book_likes_book_id ON book_likes(book_id);
CREATE INDEX IF NOT EXISTS idx_book_downloads_book_id ON book_downloads(book_id);

-- =====================================================
-- STEP 4: Create functions
-- =====================================================

CREATE OR REPLACE FUNCTION increment_book_downloads(book_id_param BIGINT)
RETURNS void AS $$
BEGIN
  UPDATE community_books
  SET downloads = downloads + 1
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION increment_book_likes(book_id_param BIGINT)
RETURNS void AS $$
BEGIN
  UPDATE community_books
  SET likes = likes + 1
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION decrement_book_likes(book_id_param BIGINT)
RETURNS void AS $$
BEGIN
  UPDATE community_books
  SET likes = GREATEST(likes - 1, 0)
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql;

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
-- STEP 5: Enable RLS
-- =====================================================

ALTER TABLE community_books ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_reports ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- STEP 6: Drop old policies
-- =====================================================

DROP POLICY IF EXISTS "Anyone can view approved books" ON community_books;
DROP POLICY IF EXISTS "Anyone can upload books" ON community_books;
DROP POLICY IF EXISTS "Users can update their own books" ON community_books;
DROP POLICY IF EXISTS "Users can delete their own books" ON community_books;
DROP POLICY IF EXISTS "Enable read access for all users" ON community_books;
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON community_books;
DROP POLICY IF EXISTS "Anyone can view likes" ON book_likes;
DROP POLICY IF EXISTS "Users can like books" ON book_likes;
DROP POLICY IF EXISTS "Users can unlike books" ON book_likes;
DROP POLICY IF EXISTS "Anyone can view downloads" ON book_downloads;
DROP POLICY IF EXISTS "Users can track downloads" ON book_downloads;
DROP POLICY IF EXISTS "Anyone can report books" ON book_reports;
DROP POLICY IF EXISTS "Only admins can view reports" ON book_reports;

-- =====================================================
-- STEP 7: Create new policies
-- =====================================================

-- Policies for community_books
CREATE POLICY "Anyone can view approved books"
  ON community_books FOR SELECT
  USING (is_approved = true OR is_approved IS NULL);

CREATE POLICY "Anyone can upload books"
  ON community_books FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Anyone can update books"
  ON community_books FOR UPDATE
  USING (true);

CREATE POLICY "Anyone can delete books"
  ON community_books FOR DELETE
  USING (true);

-- Policies for book_likes
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
CREATE POLICY "Anyone can view downloads"
  ON book_downloads FOR SELECT
  USING (true);

CREATE POLICY "Users can track downloads"
  ON book_downloads FOR INSERT
  WITH CHECK (true);

-- Policies for book_reports
CREATE POLICY "Anyone can report books"
  ON book_reports FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Only admins can view reports"
  ON book_reports FOR SELECT
  USING (false);

-- =====================================================
-- STEP 8: Verify setup
-- =====================================================

DO $$
DECLARE
  col_count INTEGER;
  table_count INTEGER;
  func_count INTEGER;
BEGIN
  -- Count columns
  SELECT COUNT(*) INTO col_count
  FROM information_schema.columns 
  WHERE table_name = 'community_books';
  
  -- Count tables
  SELECT COUNT(*) INTO table_count
  FROM information_schema.tables 
  WHERE table_schema = 'public' 
  AND table_name IN ('community_books', 'book_likes', 'book_downloads', 'book_reports');
  
  -- Count functions
  SELECT COUNT(*) INTO func_count
  FROM information_schema.routines 
  WHERE routine_schema = 'public' 
  AND routine_name LIKE '%book%';
  
  RAISE NOTICE '';
  RAISE NOTICE '╔════════════════════════════════════════╗';
  RAISE NOTICE '║   ✅ MIGRATION COMPLETE!              ║';
  RAISE NOTICE '╚════════════════════════════════════════╝';
  RAISE NOTICE '';
  RAISE NOTICE '📊 Summary:';
  RAISE NOTICE '   • Columns in community_books: %', col_count;
  RAISE NOTICE '   • Tables created: %', table_count;
  RAISE NOTICE '   • Functions created: %', func_count;
  RAISE NOTICE '';
  RAISE NOTICE '🎯 Next steps:';
  RAISE NOTICE '   1. Create storage bucket "community-books"';
  RAISE NOTICE '   2. Test with Flutter app';
  RAISE NOTICE '';
END $$;

-- Show all columns
SELECT 
  column_name, 
  data_type, 
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_name = 'community_books'
ORDER BY ordinal_position;
