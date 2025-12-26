-- ============================================
-- SUPABASE HELPER FUNCTIONS
-- ============================================
-- NOTE: Run this AFTER SUPABASE_PROFILE_SETUP.sql
-- This file adds helper functions and additional features

-- Function to increment book likes
CREATE OR REPLACE FUNCTION increment_book_likes(book_id BIGINT)
RETURNS VOID AS $$
BEGIN
  UPDATE shared_books
  SET likes = likes + 1
  WHERE id = book_id;
END;
$$ LANGUAGE plpgsql;

-- Function to decrement book likes
CREATE OR REPLACE FUNCTION decrement_book_likes(book_id BIGINT)
RETURNS VOID AS $$
BEGIN
  UPDATE shared_books
  SET likes = GREATEST(0, likes - 1)
  WHERE id = book_id;
END;
$$ LANGUAGE plpgsql;

-- Function to increment book downloads
CREATE OR REPLACE FUNCTION increment_book_downloads(book_id BIGINT)
RETURNS VOID AS $$
BEGIN
  UPDATE shared_books
  SET downloads = downloads + 1
  WHERE id = book_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add is_pinned column to chat_messages if not exists
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'chat_messages' AND column_name = 'is_pinned'
  ) THEN
    ALTER TABLE chat_messages ADD COLUMN is_pinned BOOLEAN DEFAULT FALSE;
  END IF;
END $$;

-- Create message_reports table if not exists
CREATE TABLE IF NOT EXISTS message_reports (
  id BIGSERIAL PRIMARY KEY,
  message_id BIGINT NOT NULL,
  reported_by TEXT NOT NULL,
  reason TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  FOREIGN KEY (message_id) REFERENCES chat_messages(id) ON DELETE CASCADE
);

-- Enable RLS on message_reports
ALTER TABLE message_reports ENABLE ROW LEVEL SECURITY;

-- Policy for message reports (teachers can view all)
CREATE POLICY "Anyone can report messages"
  ON message_reports FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Teachers can view reports"
  ON message_reports FOR SELECT
  USING (true);

-- Create index on message_reports
CREATE INDEX IF NOT EXISTS idx_message_reports_message_id ON message_reports(message_id);

-- ============================================
-- STORAGE BUCKET SETUP
-- ============================================

-- Note: Run this in Supabase Dashboard > Storage
-- 1. Create bucket named: shared-files
-- 2. Set as public
-- 3. Set file size limit: 50MB
-- 4. Allowed MIME types:
--    - application/pdf
--    - application/msword
--    - application/vnd.openxmlformats-officedocument.wordprocessingml.document
--    - text/plain
--    - application/vnd.ms-powerpoint
--    - application/vnd.openxmlformats-officedocument.presentationml.presentation
--    - image/jpeg
--    - image/png
--    - image/jpg

-- Storage policy for shared-files bucket
-- Run in Supabase Dashboard > Storage > Policies

-- Policy: Anyone can upload
-- INSERT policy:
-- Name: Anyone can upload files
-- Definition: true

-- Policy: Anyone can read
-- SELECT policy:
-- Name: Anyone can read files
-- Definition: true

-- Policy: Users can delete own files
-- DELETE policy:
-- Name: Users can delete own files
-- Definition: (storage.foldername(name))[1] = auth.uid()::text

-- ============================================
-- REALTIME SETUP
-- ============================================

-- Enable realtime for new tables (skip if already added)
DO $$
BEGIN
  -- Add tables to realtime publication if not already added
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'shared_books') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE shared_books;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'book_likes') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE book_likes;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'focus_sessions') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE focus_sessions;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'study_streaks') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE study_streaks;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'user_achievements') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE user_achievements;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'chat_mentions') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE chat_mentions;
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM pg_publication_tables WHERE pubname = 'supabase_realtime' AND tablename = 'message_reports') THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE message_reports;
  END IF;
END $$;

-- ============================================
-- INDEXES FOR BETTER PERFORMANCE
-- ============================================

CREATE INDEX IF NOT EXISTS idx_shared_books_subject ON shared_books(subject);
CREATE INDEX IF NOT EXISTS idx_shared_books_created_at ON shared_books(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_shared_books_likes ON shared_books(likes DESC);
CREATE INDEX IF NOT EXISTS idx_shared_books_downloads ON shared_books(downloads DESC);

CREATE INDEX IF NOT EXISTS idx_focus_sessions_created_at ON focus_sessions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_focus_sessions_status ON focus_sessions(status);

CREATE INDEX IF NOT EXISTS idx_chat_messages_is_pinned ON chat_messages(is_pinned) WHERE is_pinned = true;

CREATE INDEX IF NOT EXISTS idx_user_activity_created_at ON user_activity(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_activity_type ON user_activity(activity_type);

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger to update user's last_login on profile update
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.last_login = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_profiles_modified
BEFORE UPDATE ON user_profiles
FOR EACH ROW
EXECUTE FUNCTION update_modified_column();

-- ============================================
-- VIEWS FOR ANALYTICS
-- ============================================

-- View: Daily active users
CREATE OR REPLACE VIEW daily_active_users AS
SELECT 
  DATE(last_login) as date,
  COUNT(DISTINCT user_id) as active_users
FROM user_profiles
WHERE last_login >= NOW() - INTERVAL '30 days'
GROUP BY DATE(last_login)
ORDER BY date DESC;

-- View: Popular books
CREATE OR REPLACE VIEW popular_books AS
SELECT 
  sb.*,
  up.user_name as uploader_name,
  up.photo_url as uploader_photo
FROM shared_books sb
LEFT JOIN user_profiles up ON sb.uploaded_by = up.user_id
ORDER BY sb.likes DESC, sb.downloads DESC
LIMIT 100;

-- View: Top contributors
CREATE OR REPLACE VIEW top_contributors AS
SELECT 
  up.user_id,
  up.user_name,
  up.photo_url,
  COUNT(sb.id) as books_shared,
  SUM(sb.likes) as total_likes,
  SUM(sb.downloads) as total_downloads
FROM user_profiles up
LEFT JOIN shared_books sb ON up.user_id = sb.uploaded_by
GROUP BY up.user_id, up.user_name, up.photo_url
HAVING COUNT(sb.id) > 0
ORDER BY books_shared DESC, total_likes DESC
LIMIT 50;

-- View: Chat activity
CREATE OR REPLACE VIEW chat_activity AS
SELECT 
  DATE(created_at) as date,
  COUNT(*) as message_count,
  COUNT(DISTINCT sender) as active_users
FROM chat_messages
WHERE created_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY date DESC;

-- View: Achievement leaderboard
CREATE OR REPLACE VIEW achievement_leaderboard AS
SELECT 
  up.user_id,
  up.user_name,
  up.photo_url,
  COUNT(ua.id) as total_achievements,
  MAX(ua.earned_at) as last_achievement_date
FROM user_profiles up
LEFT JOIN user_achievements ua ON up.user_id = ua.user_id
GROUP BY up.user_id, up.user_name, up.photo_url
ORDER BY total_achievements DESC
LIMIT 100;

-- ============================================
-- SAMPLE QUERIES FOR TESTING
-- ============================================

-- Get user profile with stats
/*
SELECT 
  up.*,
  COUNT(DISTINCT fs.id) as total_focus_sessions,
  SUM(fs.duration_minutes) as total_focus_minutes,
  COUNT(DISTINCT sb.id) as books_shared,
  COUNT(DISTINCT ua.id) as achievements_earned
FROM user_profiles up
LEFT JOIN focus_sessions fs ON up.user_id = fs.user_id
LEFT JOIN shared_books sb ON up.user_id = sb.uploaded_by
LEFT JOIN user_achievements ua ON up.user_id = ua.user_id
WHERE up.user_id = 'YOUR_USER_ID'
GROUP BY up.id;
*/

-- Get trending books (last 7 days)
/*
SELECT *
FROM shared_books
WHERE created_at >= NOW() - INTERVAL '7 days'
ORDER BY likes DESC, downloads DESC
LIMIT 10;
*/

-- Get user's focus progress
/*
SELECT 
  DATE(created_at) as date,
  SUM(duration_minutes) as total_minutes,
  COUNT(*) as sessions,
  SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed
FROM focus_sessions
WHERE user_id = 'YOUR_USER_ID'
  AND created_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY date DESC;
*/

-- Get unread mentions
/*
SELECT 
  cm.*,
  msg.sender,
  msg.message,
  msg.created_at as message_time
FROM chat_mentions cm
JOIN chat_messages msg ON cm.message_id = msg.id
WHERE cm.mentioned_user_id = 'YOUR_USER_ID'
  AND cm.is_read = false
ORDER BY cm.created_at DESC;
*/

-- ============================================
-- MAINTENANCE QUERIES
-- ============================================

-- Clean up old login history (keep last 100 per user)
/*
DELETE FROM login_history
WHERE id NOT IN (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_time DESC) as rn
    FROM login_history
  ) t
  WHERE rn <= 100
);
*/

-- Clean up old activity logs (keep last 90 days)
/*
DELETE FROM user_activity
WHERE created_at < NOW() - INTERVAL '90 days';
*/

-- Update all users to offline (run on server restart)
/*
UPDATE user_profiles SET is_online = false;
*/

-- ============================================
-- BACKUP QUERIES
-- ============================================

-- Export user profiles
/*
COPY (SELECT * FROM user_profiles) TO '/tmp/user_profiles_backup.csv' CSV HEADER;
*/

-- Export shared books
/*
COPY (SELECT * FROM shared_books) TO '/tmp/shared_books_backup.csv' CSV HEADER;
*/

-- Export focus sessions
/*
COPY (SELECT * FROM focus_sessions) TO '/tmp/focus_sessions_backup.csv' CSV HEADER;
*/

-- ============================================
-- NOTES
-- ============================================

/*
1. Run SUPABASE_PROFILE_SETUP.sql first
2. Then run this file (SUPABASE_FUNCTIONS_SETUP.sql)
3. Create storage bucket in Supabase Dashboard
4. Enable realtime for tables you need
5. Test with sample queries
6. Set up regular maintenance jobs
7. Configure backups

For production:
- Set up automated backups
- Monitor query performance
- Set up alerts for errors
- Configure rate limiting
- Enable audit logging
*/
