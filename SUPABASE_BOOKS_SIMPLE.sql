-- ============================================
-- SIMPLE BOOKS STORAGE FOR SUPABASE
-- ============================================

-- Create books table (visible to all users)
CREATE TABLE IF NOT EXISTS community_books (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  subject TEXT,
  link TEXT,
  file_url TEXT,
  file_name TEXT,
  uploaded_by_name TEXT NOT NULL,
  uploaded_by_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create notes table (visible to all users)
CREATE TABLE IF NOT EXISTS community_notes (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  subject TEXT,
  uploaded_by_name TEXT NOT NULL,
  uploaded_by_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE community_books ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_notes ENABLE ROW LEVEL SECURITY;

-- Policy: Everyone can read books
CREATE POLICY "Anyone can view books"
  ON community_books FOR SELECT
  USING (true);

-- Policy: Anyone can upload books
CREATE POLICY "Anyone can upload books"
  ON community_books FOR INSERT
  WITH CHECK (true);

-- Policy: Users can delete own books
CREATE POLICY "Users can delete own books"
  ON community_books FOR DELETE
  USING (true);

-- Policy: Everyone can read notes
CREATE POLICY "Anyone can view notes"
  ON community_notes FOR SELECT
  USING (true);

-- Policy: Anyone can upload notes
CREATE POLICY "Anyone can upload notes"
  ON community_notes FOR INSERT
  WITH CHECK (true);

-- Policy: Users can delete own notes
CREATE POLICY "Users can delete own notes"
  ON community_notes FOR DELETE
  USING (true);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_community_books_subject ON community_books(subject);
CREATE INDEX IF NOT EXISTS idx_community_books_created_at ON community_books(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_books_uploaded_by ON community_books(uploaded_by_id);

CREATE INDEX IF NOT EXISTS idx_community_notes_subject ON community_notes(subject);
CREATE INDEX IF NOT EXISTS idx_community_notes_created_at ON community_notes(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_notes_uploaded_by ON community_notes(uploaded_by_id);

-- Enable realtime (optional)
ALTER PUBLICATION supabase_realtime ADD TABLE community_books;
ALTER PUBLICATION supabase_realtime ADD TABLE community_notes;

-- Test query: Insert sample book
/*
INSERT INTO community_books (title, author, subject, uploaded_by_name, uploaded_by_id)
VALUES ('Sample Book', 'Sample Author', 'Computer Science', 'John Doe', '21091A0501');
*/

-- Test query: Get all books
/*
SELECT * FROM community_books ORDER BY created_at DESC;
*/

-- Test query: Get books by subject
/*
SELECT * FROM community_books WHERE subject = 'Computer Science' ORDER BY created_at DESC;
*/

-- Test query: Search books
/*
SELECT * FROM community_books 
WHERE title ILIKE '%sample%' OR author ILIKE '%sample%'
ORDER BY created_at DESC;
*/

-- ============================================
-- STORAGE BUCKET SETUP
-- ============================================

/*
In Supabase Dashboard > Storage:

1. Create New Bucket:
   Name: community-books
   Public: YES
   File size limit: 50 MB
   
2. Allowed MIME types:
   - application/pdf
   - application/msword
   - application/vnd.openxmlformats-officedocument.wordprocessingml.document
   - text/plain
   - application/vnd.ms-powerpoint
   - application/vnd.openxmlformats-officedocument.presentationml.presentation
   - image/jpeg
   - image/png
   - image/jpg

3. Set Policies:
   
   Policy 1 - Upload:
   Name: Anyone can upload
   Operation: INSERT
   Policy: true
   
   Policy 2 - Download:
   Name: Anyone can download
   Operation: SELECT
   Policy: true
   
   Policy 3 - Delete:
   Name: Anyone can delete
   Operation: DELETE
   Policy: true
*/

-- ============================================
-- CLEANUP (if needed)
-- ============================================

/*
-- Drop tables
DROP TABLE IF EXISTS community_notes CASCADE;
DROP TABLE IF EXISTS community_books CASCADE;
*/
