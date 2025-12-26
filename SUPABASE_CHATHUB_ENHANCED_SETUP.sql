-- =====================================================
-- ENHANCED CHATHUB WITH DISAPPEARING MESSAGES
-- =====================================================
-- Run these SQL commands in Supabase SQL Editor

-- 1. Add new columns to existing chat_messages table
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS expires_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS is_pinned BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS pinned_by TEXT,
ADD COLUMN IF NOT EXISTS pinned_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS edited_at TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS is_announcement BOOLEAN DEFAULT false,
ADD COLUMN IF NOT EXISTS read_by TEXT[] DEFAULT '{}',
ADD COLUMN IF NOT EXISTS message_type TEXT DEFAULT 'text', -- text, image, file, poll
ADD COLUMN IF NOT EXISTS media_url TEXT,
ADD COLUMN IF NOT EXISTS file_name TEXT,
ADD COLUMN IF NOT EXISTS file_size BIGINT;

-- 2. Create message_reactions table for emoji reactions
CREATE TABLE IF NOT EXISTS message_reactions (
  id BIGSERIAL PRIMARY KEY,
  message_id BIGINT REFERENCES chat_messages(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  emoji TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(message_id, user_name, emoji)
);

-- 3. Create polls table for chat polls
CREATE TABLE IF NOT EXISTS chat_polls (
  id BIGSERIAL PRIMARY KEY,
  message_id BIGINT REFERENCES chat_messages(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  options JSONB NOT NULL, -- [{text: "Option 1", votes: 0}, ...]
  created_by TEXT NOT NULL,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Create poll_votes table
CREATE TABLE IF NOT EXISTS poll_votes (
  id BIGSERIAL PRIMARY KEY,
  poll_id BIGINT REFERENCES chat_polls(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  option_index INTEGER NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(poll_id, user_name)
);

-- 5. Create message_threads table for threaded replies
CREATE TABLE IF NOT EXISTS message_threads (
  id BIGSERIAL PRIMARY KEY,
  parent_message_id BIGINT REFERENCES chat_messages(id) ON DELETE CASCADE,
  reply_message_id BIGINT REFERENCES chat_messages(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 6. Create user_typing table for typing indicators
CREATE TABLE IF NOT EXISTS user_typing (
  user_name TEXT PRIMARY KEY,
  is_typing BOOLEAN DEFAULT false,
  last_typed_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Create message_bookmarks table
CREATE TABLE IF NOT EXISTS message_bookmarks (
  id BIGSERIAL PRIMARY KEY,
  message_id BIGINT REFERENCES chat_messages(id) ON DELETE CASCADE,
  user_name TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(message_id, user_name)
);

-- 8. Enable RLS on new tables
ALTER TABLE message_reactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_polls ENABLE ROW LEVEL SECURITY;
ALTER TABLE poll_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE message_threads ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_typing ENABLE ROW LEVEL SECURITY;
ALTER TABLE message_bookmarks ENABLE ROW LEVEL SECURITY;

-- 9. Create policies for message_reactions
CREATE POLICY "Anyone can view reactions"
  ON message_reactions FOR SELECT
  USING (true);

CREATE POLICY "Users can add reactions"
  ON message_reactions FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can remove their reactions"
  ON message_reactions FOR DELETE
  USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- 10. Create policies for chat_polls
CREATE POLICY "Anyone can view polls"
  ON chat_polls FOR SELECT
  USING (true);

CREATE POLICY "Users can create polls"
  ON chat_polls FOR INSERT
  WITH CHECK (true);

-- 11. Create policies for poll_votes
CREATE POLICY "Anyone can view votes"
  ON poll_votes FOR SELECT
  USING (true);

CREATE POLICY "Users can vote"
  ON poll_votes FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can change their vote"
  ON poll_votes FOR UPDATE
  USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- 12. Create policies for message_threads
CREATE POLICY "Anyone can view threads"
  ON message_threads FOR SELECT
  USING (true);

CREATE POLICY "Users can create threads"
  ON message_threads FOR INSERT
  WITH CHECK (true);

-- 13. Create policies for user_typing
CREATE POLICY "Anyone can view typing status"
  ON user_typing FOR SELECT
  USING (true);

CREATE POLICY "Users can update their typing status"
  ON user_typing FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can update their own typing status"
  ON user_typing FOR UPDATE
  USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- 14. Create policies for message_bookmarks
CREATE POLICY "Users can view their bookmarks"
  ON message_bookmarks FOR SELECT
  USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can bookmark messages"
  ON message_bookmarks FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Users can remove bookmarks"
  ON message_bookmarks FOR DELETE
  USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- 15. Create function to auto-delete expired messages
CREATE OR REPLACE FUNCTION delete_expired_messages()
RETURNS void AS $$
BEGIN
  DELETE FROM chat_messages
  WHERE expires_at IS NOT NULL AND expires_at < NOW();
END;
$$ LANGUAGE plpgsql;

-- 16. Create function to clean old typing indicators
CREATE OR REPLACE FUNCTION clean_old_typing_indicators()
RETURNS void AS $$
BEGIN
  DELETE FROM user_typing
  WHERE last_typed_at < NOW() - INTERVAL '10 seconds';
END;
$$ LANGUAGE plpgsql;

-- 17. Create function to get message with reactions count
CREATE OR REPLACE FUNCTION get_message_reactions(message_id_param BIGINT)
RETURNS TABLE(
  emoji TEXT,
  count BIGINT,
  users TEXT[]
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    mr.emoji,
    COUNT(*)::BIGINT as count,
    ARRAY_AGG(mr.user_name) as users
  FROM message_reactions mr
  WHERE mr.message_id = message_id_param
  GROUP BY mr.emoji;
END;
$$ LANGUAGE plpgsql;

-- 18. Create function to pin/unpin messages
CREATE OR REPLACE FUNCTION toggle_pin_message(
  message_id_param BIGINT,
  user_name_param TEXT
)
RETURNS BOOLEAN AS $$
DECLARE
  current_pin_status BOOLEAN;
BEGIN
  SELECT is_pinned INTO current_pin_status
  FROM chat_messages
  WHERE id = message_id_param;
  
  IF current_pin_status THEN
    -- Unpin
    UPDATE chat_messages
    SET is_pinned = false, pinned_by = NULL, pinned_at = NULL
    WHERE id = message_id_param;
    RETURN false;
  ELSE
    -- Pin
    UPDATE chat_messages
    SET is_pinned = true, pinned_by = user_name_param, pinned_at = NOW()
    WHERE id = message_id_param;
    RETURN true;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- 19. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_chat_messages_expires_at ON chat_messages(expires_at);
CREATE INDEX IF NOT EXISTS idx_chat_messages_is_pinned ON chat_messages(is_pinned);
CREATE INDEX IF NOT EXISTS idx_message_reactions_message_id ON message_reactions(message_id);
CREATE INDEX IF NOT EXISTS idx_chat_polls_message_id ON chat_polls(message_id);
CREATE INDEX IF NOT EXISTS idx_poll_votes_poll_id ON poll_votes(poll_id);
CREATE INDEX IF NOT EXISTS idx_message_threads_parent ON message_threads(parent_message_id);
CREATE INDEX IF NOT EXISTS idx_message_bookmarks_user ON message_bookmarks(user_name);

-- 20. Create scheduled job to delete expired messages (using pg_cron extension)
-- Note: pg_cron needs to be enabled in Supabase
-- SELECT cron.schedule(
--   'delete-expired-messages',
--   '*/5 * * * *', -- Every 5 minutes
--   $$ SELECT delete_expired_messages(); $$
-- );

-- 21. Create scheduled job to clean typing indicators
-- SELECT cron.schedule(
--   'clean-typing-indicators',
--   '* * * * *', -- Every minute
--   $$ SELECT clean_old_typing_indicators(); $$
-- );

-- =====================================================
-- DISAPPEARING MESSAGE PRESETS
-- =====================================================

-- Function to set message expiry
CREATE OR REPLACE FUNCTION set_message_expiry(
  message_id_param BIGINT,
  duration_minutes INTEGER
)
RETURNS void AS $$
BEGIN
  UPDATE chat_messages
  SET expires_at = NOW() + (duration_minutes || ' minutes')::INTERVAL
  WHERE id = message_id_param;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- SAMPLE QUERIES
-- =====================================================

-- Get messages with reaction counts
SELECT 
  cm.*,
  (SELECT COUNT(*) FROM message_reactions WHERE message_id = cm.id) as reaction_count,
  (SELECT COUNT(*) FROM message_threads WHERE parent_message_id = cm.id) as reply_count
FROM chat_messages cm
ORDER BY cm.created_at DESC
LIMIT 50;

-- Get pinned messages
SELECT * FROM chat_messages
WHERE is_pinned = true
ORDER BY pinned_at DESC;

-- Get messages expiring soon
SELECT * FROM chat_messages
WHERE expires_at IS NOT NULL 
AND expires_at > NOW()
AND expires_at < NOW() + INTERVAL '1 hour'
ORDER BY expires_at ASC;

-- Get poll results
SELECT 
  cp.*,
  (SELECT COUNT(*) FROM poll_votes WHERE poll_id = cp.id) as total_votes
FROM chat_polls cp;

-- =====================================================
-- VERIFICATION
-- =====================================================

-- Check new columns
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'chat_messages'
AND column_name IN ('expires_at', 'is_pinned', 'message_type', 'media_url');

-- Check new tables
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('message_reactions', 'chat_polls', 'poll_votes', 'message_threads', 'user_typing', 'message_bookmarks');

-- =====================================================
-- NOTES
-- =====================================================
-- 1. Disappearing messages: Set expires_at timestamp
-- 2. Reactions: Use message_reactions table
-- 3. Polls: Use chat_polls and poll_votes tables
-- 4. Threads: Use message_threads for replies
-- 5. Typing indicators: Use user_typing table
-- 6. Bookmarks: Use message_bookmarks table
-- 7. Pinned messages: Use is_pinned flag
-- 8. Announcements: Use is_announcement flag
-- 9. Read receipts: Use read_by array
-- 10. Media messages: Use message_type and media_url
