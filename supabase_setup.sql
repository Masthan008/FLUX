-- ============================================
-- FLUXFLOW SUPABASE SETUP - Run in SQL Editor
-- ============================================

-- 1. Create Books Table
CREATE TABLE IF NOT EXISTS books (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  cover_url TEXT,
  pdf_drive_link TEXT NOT NULL,
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable Row Level Security
ALTER TABLE books ENABLE ROW LEVEL SECURITY;

-- 3. Create policy to allow public read access
CREATE POLICY "Allow public read access on books"
  ON books FOR SELECT
  USING (true);

-- 4. Create policy for admin insert/update (optional)
-- CREATE POLICY "Allow admin insert" ON books FOR INSERT
-- WITH CHECK (auth.role() = 'authenticated');

-- 5. Insert sample books (Replace with your Google Drive links)
INSERT INTO books (title, category, pdf_drive_link, is_premium) VALUES 
  ('Let Us C - Yashavant Kanetkar', 'C Programming', 'https://drive.google.com/file/d/YOUR_FILE_ID/view', false),
  ('Python Crash Course', 'Python', 'https://drive.google.com/file/d/YOUR_FILE_ID/view', false),
  ('Data Structures Made Easy', 'DSA', 'https://drive.google.com/file/d/YOUR_FILE_ID/view', true),
  ('GATE Computer Science', 'Interview Prep', 'https://drive.google.com/file/d/YOUR_FILE_ID/view', true),
  ('Engineering Mathematics', 'Mathematics', 'https://drive.google.com/file/d/YOUR_FILE_ID/view', false);

-- 6. Create Users table if not exists (for dynamic drawer)
CREATE TABLE IF NOT EXISTS users (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  username TEXT,
  full_name TEXT,
  email TEXT,
  avatar_url TEXT,
  is_premium BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Enable RLS on users
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- 8. Create policy for users to read their own data
CREATE POLICY "Users can read own data"
  ON users FOR SELECT
  USING (auth.uid() = id);

-- 9. Create policy for users to update their own data
CREATE POLICY "Users can update own data"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- 10. Create function to auto-create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, username, full_name)
  VALUES (
    NEW.id,
    NEW.email,
    split_part(NEW.email, '@', 1),
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 11. Create trigger for new user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================
-- VERIFICATION: Run these to check setup
-- ============================================
-- SELECT * FROM books;
-- SELECT * FROM users;
