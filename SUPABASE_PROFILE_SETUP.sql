-- ============================================
-- SUPABASE PROFILE & ACTIVITY TRACKING SETUP
-- ============================================

-- 1. User Profiles Table
CREATE TABLE IF NOT EXISTS user_profiles (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id TEXT UNIQUE NOT NULL,
  user_name TEXT NOT NULL,
  email TEXT,
  branch TEXT,
  role TEXT DEFAULT 'student',
  photo_url TEXT,
  bio TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  login_count INTEGER DEFAULT 1,
  is_online BOOLEAN DEFAULT FALSE,
  CONSTRAINT valid_role CHECK (role IN ('student', 'teacher', 'admin'))
);

-- 2. Login History Table
CREATE TABLE IF NOT EXISTS login_history (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  user_name TEXT NOT NULL,
  login_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  device_info TEXT,
  ip_address TEXT,
  FOREIGN KEY (user_id) REFERENCES user_profiles(user_id) ON DELETE CASCADE
);

-- 3. User Activity Log
CREATE TABLE IF NOT EXISTS user_activity (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  activity_type TEXT NOT NULL,
  activity_data JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES user_profiles(user_id) ON DELETE CASCADE
);

-- 4. Shared Books Table (visible to all users)
CREATE TABLE IF NOT EXISTS shared_books (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  subject TEXT,
  link TEXT,
  file_url TEXT,
  file_name TEXT,
  uploaded_by TEXT NOT NULL,
  uploader_name TEXT NOT NULL,
  downloads INTEGER DEFAULT 0,
  likes INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (uploaded_by) REFERENCES user_profiles(user_id) ON DELETE CASCADE
);

-- 5. Book Likes Table
CREATE TABLE IF NOT EXISTS book_likes (
  id BIGSERIAL PRIMARY KEY,
  book_id BIGINT NOT NULL,
  user_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(book_id, user_id),
  FOREIGN KEY (book_id) REFERENCES shared_books(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES user_profiles(user_id) ON DELETE CASCADE
);

-- 6. Focus Sessions Table
CREATE TABLE IF NOT EXISTS focus_sessions (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL,
  status TEXT NOT NULL,
  ambient_sound TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES user_profiles(user_id) ON DELETE CASCADE,
  CONSTRAINT valid_status CHECK (status IN ('completed', 'failed'))
);

-- 7. Focus Leaderboard View
CREATE OR REPLACE VIEW focus_leaderboard AS
SELECT 
  up.user_id,
  up.user_name,
  up.photo_url,
  COUNT(fs.id) as total_sessions,
  SUM(fs.duration_minutes) as total_minutes,
  SUM(CASE WHEN fs.status = 'completed' THEN 1 ELSE 0 END) as completed_sessions,
  ROUND(AVG(fs.duration_minutes), 2) as avg_session_minutes
FROM user_profiles up
LEFT JOIN focus_sessions fs ON up.user_id = fs.user_id
GROUP BY up.user_id, up.user_name, up.photo_url
ORDER BY total_minutes DESC;

-- 8. Study Streaks Table
CREATE TABLE IF NOT EXISTS study_streaks (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT UNIQUE NOT NULL,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_study_date DATE,
  FOREIGN KEY (user_id) REFERENCES user_profiles(user_id) ON DELETE CASCADE
);

-- 9. Achievements Table
CREATE TABLE IF NOT EXISTS user_achievements (
  id BIGSERIAL PRIMARY KEY,
  user_id TEXT NOT NULL,
  achievement_type TEXT NOT NULL,
  achievement_name TEXT NOT NULL,
  earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES user_profiles(user_id) ON DELETE CASCADE
);

-- 10. Chat Mentions Table
CREATE TABLE IF NOT EXISTS chat_mentions (
  id BIGSERIAL PRIMARY KEY,
  message_id BIGINT NOT NULL,
  mentioned_user_id TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (message_id) REFERENCES chat_messages(id) ON DELETE CASCADE,
  FOREIGN KEY (mentioned_user_id) REFERENCES user_profiles(user_id) ON DELETE CASCADE
);

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_login_history_user_id ON login_history(user_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_user_id ON user_activity(user_id);
CREATE INDEX IF NOT EXISTS idx_shared_books_uploaded_by ON shared_books(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_focus_sessions_user_id ON focus_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_study_streaks_user_id ON study_streaks(user_id);
CREATE INDEX IF NOT EXISTS idx_chat_mentions_mentioned_user ON chat_mentions(mentioned_user_id);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE login_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_activity ENABLE ROW LEVEL SECURITY;
ALTER TABLE shared_books ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE focus_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_mentions ENABLE ROW LEVEL SECURITY;

-- Policies: Allow all users to read profiles
CREATE POLICY "Public profiles are viewable by everyone"
  ON user_profiles FOR SELECT
  USING (true);

-- Policies: Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON user_profiles FOR UPDATE
  USING (true);

-- Policies: Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON user_profiles FOR INSERT
  WITH CHECK (true);

-- Policies: Login history is readable by owner
CREATE POLICY "Users can view own login history"
  ON login_history FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own login history"
  ON login_history FOR INSERT
  WITH CHECK (true);

-- Policies: Shared books are viewable by everyone
CREATE POLICY "Shared books are viewable by everyone"
  ON shared_books FOR SELECT
  USING (true);

CREATE POLICY "Users can upload books"
  ON shared_books FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can delete own books"
  ON shared_books FOR DELETE
  USING (true);

-- Policies: Book likes
CREATE POLICY "Book likes are viewable by everyone"
  ON book_likes FOR SELECT
  USING (true);

CREATE POLICY "Users can like books"
  ON book_likes FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can unlike books"
  ON book_likes FOR DELETE
  USING (true);

-- Policies: Focus sessions
CREATE POLICY "Users can view own focus sessions"
  ON focus_sessions FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own focus sessions"
  ON focus_sessions FOR INSERT
  WITH CHECK (true);

-- Policies: Study streaks
CREATE POLICY "Users can view own streaks"
  ON study_streaks FOR SELECT
  USING (true);

CREATE POLICY "Users can update own streaks"
  ON study_streaks FOR UPDATE
  USING (true);

CREATE POLICY "Users can insert own streaks"
  ON study_streaks FOR INSERT
  WITH CHECK (true);

-- Policies: Achievements
CREATE POLICY "Users can view own achievements"
  ON user_achievements FOR SELECT
  USING (true);

CREATE POLICY "Users can insert own achievements"
  ON user_achievements FOR INSERT
  WITH CHECK (true);

-- Policies: Chat mentions
CREATE POLICY "Users can view own mentions"
  ON chat_mentions FOR SELECT
  USING (true);

CREATE POLICY "Anyone can create mentions"
  ON chat_mentions FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can update own mentions"
  ON chat_mentions FOR UPDATE
  USING (true);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to update last login
CREATE OR REPLACE FUNCTION update_last_login(p_user_id TEXT)
RETURNS VOID AS $$
BEGIN
  UPDATE user_profiles
  SET last_login = NOW(),
      login_count = login_count + 1,
      is_online = TRUE
  WHERE user_id = p_user_id;
END;
$$ LANGUAGE plpgsql;

-- Function to update study streak
CREATE OR REPLACE FUNCTION update_study_streak(p_user_id TEXT)
RETURNS VOID AS $$
DECLARE
  v_last_date DATE;
  v_current_streak INTEGER;
  v_longest_streak INTEGER;
BEGIN
  SELECT last_study_date, current_streak, longest_streak
  INTO v_last_date, v_current_streak, v_longest_streak
  FROM study_streaks
  WHERE user_id = p_user_id;
  
  IF NOT FOUND THEN
    -- First time
    INSERT INTO study_streaks (user_id, current_streak, longest_streak, last_study_date)
    VALUES (p_user_id, 1, 1, CURRENT_DATE);
  ELSIF v_last_date = CURRENT_DATE THEN
    -- Already studied today
    RETURN;
  ELSIF v_last_date = CURRENT_DATE - INTERVAL '1 day' THEN
    -- Consecutive day
    v_current_streak := v_current_streak + 1;
    v_longest_streak := GREATEST(v_longest_streak, v_current_streak);
    UPDATE study_streaks
    SET current_streak = v_current_streak,
        longest_streak = v_longest_streak,
        last_study_date = CURRENT_DATE
    WHERE user_id = p_user_id;
  ELSE
    -- Streak broken
    UPDATE study_streaks
    SET current_streak = 1,
        last_study_date = CURRENT_DATE
    WHERE user_id = p_user_id;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Function to award achievement
CREATE OR REPLACE FUNCTION award_achievement(
  p_user_id TEXT,
  p_achievement_type TEXT,
  p_achievement_name TEXT
)
RETURNS VOID AS $$
BEGIN
  INSERT INTO user_achievements (user_id, achievement_type, achievement_name)
  VALUES (p_user_id, p_achievement_type, p_achievement_name)
  ON CONFLICT DO NOTHING;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- REALTIME SUBSCRIPTIONS
-- ============================================

-- Enable realtime for relevant tables (skip if already added)
DO $$
BEGIN
  -- Add user_profiles if not already in publication
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'user_profiles'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE user_profiles;
  END IF;
  
  -- Add shared_books if not already in publication
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'shared_books'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE shared_books;
  END IF;
  
  -- Add focus_sessions if not already in publication
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'focus_sessions'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE focus_sessions;
  END IF;
  
  -- Add chat_mentions if not already in publication
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables 
    WHERE pubname = 'supabase_realtime' AND tablename = 'chat_mentions'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE chat_mentions;
  END IF;
END $$;

-- ============================================
-- SAMPLE DATA (Optional - Run after creating a real user)
-- ============================================

-- First create a sample user profile, then insert achievements
-- Example:
/*
-- Step 1: Create sample user
INSERT INTO user_profiles (user_id, user_name, branch, role)
VALUES ('sample_user', 'Sample Student', 'CSE', 'student')
ON CONFLICT (user_id) DO NOTHING;

-- Step 2: Insert sample achievements
INSERT INTO user_achievements (user_id, achievement_type, achievement_name)
VALUES 
  ('sample_user', 'focus', 'First Focus Session'),
  ('sample_user', 'focus', '10 Focus Sessions'),
  ('sample_user', 'focus', '100 Hours Focused'),
  ('sample_user', 'streak', '7 Day Streak'),
  ('sample_user', 'streak', '30 Day Streak'),
  ('sample_user', 'books', 'First Book Shared'),
  ('sample_user', 'chat', '100 Messages Sent')
ON CONFLICT DO NOTHING;
*/

-- ============================================
-- CLEANUP (Run if needed)
-- ============================================

-- DROP TABLE IF EXISTS chat_mentions CASCADE;
-- DROP TABLE IF EXISTS user_achievements CASCADE;
-- DROP TABLE IF EXISTS study_streaks CASCADE;
-- DROP TABLE IF EXISTS focus_sessions CASCADE;
-- DROP TABLE IF EXISTS book_likes CASCADE;
-- DROP TABLE IF EXISTS shared_books CASCADE;
-- DROP TABLE IF EXISTS user_activity CASCADE;
-- DROP TABLE IF EXISTS login_history CASCADE;
-- DROP TABLE IF EXISTS user_profiles CASCADE;
-- DROP VIEW IF EXISTS focus_leaderboard;
