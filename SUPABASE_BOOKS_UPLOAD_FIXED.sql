-- =====================================================
-- BOOK UPLOAD SYSTEM - SUPABASE SETUP (FIXED)
-- =====================================================
-- Run these SQL commands in Supabase SQL Editor
-- Execute in order - DO NOT run all at once

-- =====================================================
-- STEP 1: Create Tables First (without RLS)
-- =====================================================

-- 1. Create community_books table
CREATE TABLE IF NOT EXISTS community_books (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  subject TEXT,
  semester TEXT,
  file_url TEXT NOT NULL,
  file_name TEXT NOT NULL,
  file_size BIGINT,
  file_type TEXT,
  uploaded_by TEXT NOT NULL,
  uploader_id TEXT,
  upload_date TIMESTAMPTZ DEFAULT NOW(),
  downloads INTEGER DEFAULT 0,
  likes INTEGER DEFAULT 0,
  tags TEXT[],
  is_approved BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create book_likes table
CREATE TABLE IF NOT EXISTS book_likes (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(book_id, user_name)
);

-- 3. Create book_downloads table
CREATE TABLE IF NOT EXISTS book_downloads (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  downloaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Create book_reports table
CREATE TABLE IF NOT EXISTS book_reports (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  reported_by TEXT NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- STEP 2: Create Indexes
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_community_books_subject ON community_books(subject);
CREATE INDEX IF NOT EXISTS idx_community_books_semester ON community_books(semester);
CREATE INDEX IF NOT EXISTS idx_community_books_uploaded_by ON community_books(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_community_books_upload_date ON community_books(upload_date DESC);
CREATE INDEX IF NOT EXISTS idx_community_books_is_approved ON community_books(is_approved);
CREATE INDEX IF NOT EXISTS idx_book_likes_book_id ON book_likes(book_id);
CREATE INDEX IF NOT EXISTS idx_book_downloads_book_id ON book_downloads(book_id);

-- =====================================================
-- STEP 3: Create Functions
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
    (SELECT downloads FROM community_books WHERE id = book_id_param),
    (SELECT COUNT(*) FROM book_likes WHERE book_id = book_id_param),
    (SELECT COUNT(DISTINCT user_name) FROM book_downloads WHERE book_id = book_id_param);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- STEP 4: Enable Row Level Security
-- =====================================================

ALTER TABLE community_books ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_reports ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- STEP 5: Create RLS Policies
-- =====================================================

-- Policies for community_books
DROP POLICY IF EXISTS "Anyone can view approved books" ON community_books;
CREATE POLICY "Anyone can view approved books"
  ON community_books FOR SELECT
  USING (is_approved = true);

DROP POLICY IF EXISTS "Anyone can upload books" ON community_books;
CREATE POLICY "Anyone can upload books"
  ON community_books FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "Users can update their own books" ON community_books;
CREATE POLICY "Users can update their own books"
  ON community_books FOR UPDATE
  USING (uploaded_by = current_setting('app.current_user', true));

DROP POLICY IF EXISTS "Users can delete their own books" ON community_books;
CREATE POLICY "Users can delete their own books"
  ON community_books FOR DELETE
  USING (uploaded_by = current_setting('app.current_user', true));

-- Policies for book_likes
DROP POLICY IF EXISTS "Anyone can view likes" ON book_likes;
CREATE POLICY "Anyone can view likes"
  ON book_likes FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Users can like books" ON book_likes;
CREATE POLICY "Users can like books"
  ON book_likes FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "Users can unlike books" ON book_likes;
CREATE POLICY "Users can unlike books"
  ON book_likes FOR DELETE
  USING (true);

-- Policies for book_downloads
DROP POLICY IF EXISTS "Anyone can view downloads" ON book_downloads;
CREATE POLICY "Anyone can view downloads"
  ON book_downloads FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Users can track downloads" ON book_downloads;
CREATE POLICY "Users can track downloads"
  ON book_downloads FOR INSERT
  WITH CHECK (true);

-- Policies for book_reports
DROP POLICY IF EXISTS "Anyone can report books" ON book_reports;
CREATE POLICY "Anyone can report books"
  ON book_reports FOR INSERT
  WITH CHECK (true);

DROP POLICY IF EXISTS "Only admins can view reports" ON book_reports;
CREATE POLICY "Only admins can view reports"
  ON book_reports FOR SELECT
  USING (false);

-- =====================================================
-- STEP 6: Insert Sample Data (Optional)
-- =====================================================

INSERT INTO community_books (title, description, subject, semester, file_url, file_name, uploaded_by, tags, file_size, file_type)
VALUES 
  ('Data Structures Notes', 'Complete DSA notes with examples and diagrams', 'Computer Science', 'Semester 3', 'https://example.com/dsa.pdf', 'dsa_notes.pdf', 'Admin', ARRAY['DSA', 'Algorithms', 'Notes'], 2048000, 'application/pdf'),
  ('Python Programming Guide', 'Beginner to advanced Python programming', 'Programming', 'Semester 1', 'https://example.com/python.pdf', 'python_guide.pdf', 'Admin', ARRAY['Python', 'Programming', 'Tutorial'], 3145728, 'application/pdf'),
  ('Database Management Systems', 'Complete DBMS notes with SQL examples', 'Computer Science', 'Semester 4', 'https://example.com/dbms.pdf', 'dbms_notes.pdf', 'Admin', ARRAY['DBMS', 'SQL', 'Database'], 1572864, 'application/pdf')
ON CONFLICT DO NOTHING;

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check if tables were created
SELECT table_name, 
       (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
AND table_name IN ('community_books', 'book_likes', 'book_downloads', 'book_reports')
ORDER BY table_name;

-- Check columns in community_books
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'community_books'
ORDER BY ordinal_position;

-- Check sample data
SELECT id, title, subject, semester, uploaded_by, downloads, likes
FROM community_books
LIMIT 5;

-- Check indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename IN ('community_books', 'book_likes', 'book_downloads')
ORDER BY tablename, indexname;

-- Check functions
SELECT routine_name, routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name LIKE '%book%'
ORDER BY routine_name;

-- =====================================================
-- STORAGE BUCKET SETUP INSTRUCTIONS
-- =====================================================

/*
MANUAL STEPS IN SUPABASE DASHBOARD:

1. Go to Storage section in Supabase Dashboard
2. Click "Create Bucket"
3. Bucket name: community-books
4. Public bucket: Yes (or No if you want authenticated access only)
5. File size limit: 52428800 (50MB)
6. Allowed MIME types: 
   - application/pdf
   - application/vnd.openxmlformats-officedocument.wordprocessingml.document
   - application/vnd.openxmlformats-officedocument.presentationml.presentation
   - application/msword
   - application/vnd.ms-powerpoint

7. Set Storage Policies:
   - Allow authenticated users to upload
   - Allow anyone to download (if public)
   
Example policy for uploads:
```
CREATE POLICY "Authenticated users can upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'community-books');
```

Example policy for downloads:
```
CREATE POLICY "Anyone can download"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'community-books');
```
*/

-- =====================================================
-- CLEANUP (if needed)
-- =====================================================

/*
-- To drop everything and start fresh:

DROP TABLE IF EXISTS book_reports CASCADE;
DROP TABLE IF EXISTS book_downloads CASCADE;
DROP TABLE IF EXISTS book_likes CASCADE;
DROP TABLE IF EXISTS community_books CASCADE;

DROP FUNCTION IF EXISTS increment_book_downloads(BIGINT);
DROP FUNCTION IF EXISTS increment_book_likes(BIGINT);
DROP FUNCTION IF EXISTS decrement_book_likes(BIGINT);
DROP FUNCTION IF EXISTS get_book_stats(BIGINT);
*/

-- =====================================================
-- SUCCESS MESSAGE
-- =====================================================

DO $$
BEGIN
  RAISE NOTICE '✅ Book Upload System setup complete!';
  RAISE NOTICE '📝 Next steps:';
  RAISE NOTICE '   1. Create storage bucket "community-books" in Supabase Dashboard';
  RAISE NOTICE '   2. Configure storage policies';
  RAISE NOTICE '   3. Test with Flutter app';
END $$;
