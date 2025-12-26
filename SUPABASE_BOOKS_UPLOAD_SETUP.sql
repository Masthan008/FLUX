-- =====================================================
-- BOOK UPLOAD SYSTEM - SUPABASE SETUP
-- =====================================================
-- Run these SQL commands in Supabase SQL Editor

-- 1. Create community_books table for shared books
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

-- 2. Create book_likes table to track who liked what
CREATE TABLE IF NOT EXISTS book_likes (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(book_id, user_name)
);

-- 3. Create book_downloads table to track downloads
CREATE TABLE IF NOT EXISTS book_downloads (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  downloaded_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Create book_reports table for reporting inappropriate content
CREATE TABLE IF NOT EXISTS book_reports (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT REFERENCES community_books(id) ON DELETE CASCADE,
  reported_by TEXT NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 5. Enable Row Level Security
ALTER TABLE community_books ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_reports ENABLE ROW LEVEL SECURITY;

-- 6. Create policies for community_books
CREATE POLICY "Anyone can view approved books"
  ON community_books FOR SELECT
  USING (is_approved = true);

CREATE POLICY "Authenticated users can upload books"
  ON community_books FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can update their own books"
  ON community_books FOR UPDATE
  USING (uploaded_by = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can delete their own books"
  ON community_books FOR DELETE
  USING (uploaded_by = current_setting('request.jwt.claims', true)::json->>'user_name');

-- 7. Create policies for book_likes
CREATE POLICY "Anyone can view likes"
  ON book_likes FOR SELECT
  USING (true);

CREATE POLICY "Users can like books"
  ON book_likes FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can unlike books"
  ON book_likes FOR DELETE
  USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- 8. Create policies for book_downloads
CREATE POLICY "Anyone can view downloads"
  ON book_downloads FOR SELECT
  USING (true);

CREATE POLICY "Users can track downloads"
  ON book_downloads FOR INSERT
  WITH CHECK (true);

-- 9. Create policies for book_reports
CREATE POLICY "Anyone can report books"
  ON book_reports FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Only admins can view reports"
  ON book_reports FOR SELECT
  USING (false); -- Adjust based on your admin logic

-- 10. Create indexes for better performance
CREATE INDEX idx_community_books_subject ON community_books(subject);
CREATE INDEX idx_community_books_semester ON community_books(semester);
CREATE INDEX idx_community_books_uploaded_by ON community_books(uploaded_by);
CREATE INDEX idx_community_books_upload_date ON community_books(upload_date DESC);
CREATE INDEX idx_book_likes_book_id ON book_likes(book_id);
CREATE INDEX idx_book_downloads_book_id ON book_downloads(book_id);

-- 11. Create function to increment downloads
CREATE OR REPLACE FUNCTION increment_book_downloads(book_id_param BIGINT)
RETURNS void AS $$
BEGIN
  UPDATE community_books
  SET downloads = downloads + 1
  WHERE id = book_id_param;
END;
$$ LANGUAGE plpgsql;

-- 12. Create function to get book statistics
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
-- STORAGE BUCKET SETUP
-- =====================================================
-- Run these commands in Supabase Storage

-- 1. Create storage bucket for books (if not exists)
-- Go to Storage > Create Bucket
-- Name: community-books
-- Public: true (or false if you want authenticated access only)

-- 2. Set storage policies (adjust as needed)
-- Allow authenticated users to upload
-- Allow anyone to download (if public bucket)

-- =====================================================
-- SAMPLE DATA (Optional)
-- =====================================================

INSERT INTO community_books (title, description, subject, semester, file_url, file_name, uploaded_by, tags)
VALUES 
  ('Data Structures Notes', 'Complete DSA notes with examples', 'Computer Science', 'Semester 3', 'https://example.com/dsa.pdf', 'dsa_notes.pdf', 'Admin', ARRAY['DSA', 'Algorithms', 'Notes']),
  ('Python Programming Guide', 'Beginner to advanced Python', 'Programming', 'Semester 1', 'https://example.com/python.pdf', 'python_guide.pdf', 'Admin', ARRAY['Python', 'Programming', 'Tutorial']);

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check if tables were created
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('community_books', 'book_likes', 'book_downloads', 'book_reports');

-- Check sample data
SELECT * FROM community_books LIMIT 5;

-- =====================================================
-- NOTES
-- =====================================================
-- 1. Make sure to create the 'community-books' storage bucket in Supabase
-- 2. Configure storage policies based on your security requirements
-- 3. Adjust RLS policies if you have custom authentication
-- 4. Consider adding file size limits in your Flutter app
-- 5. Implement virus scanning for uploaded files (optional)
