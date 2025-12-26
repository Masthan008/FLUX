-- ============================================
-- ChatHub Reactions & Performance Optimization
-- ============================================

-- Add reply columns if they don't exist
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS reply_to BIGINT;

ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS reply_message TEXT;

ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS reply_sender TEXT;

-- Add reactions column to chat_messages table if it doesn't exist
ALTER TABLE chat_messages 
ADD COLUMN IF NOT EXISTS reactions JSONB DEFAULT '{}'::jsonb;

-- Create index on reactions for faster queries
CREATE INDEX IF NOT EXISTS idx_chat_messages_reactions 
ON chat_messages USING GIN (reactions);

-- Create index on created_at for faster ordering
CREATE INDEX IF NOT EXISTS idx_chat_messages_created_at 
ON chat_messages (created_at DESC);

-- Create index on sender for faster filtering
CREATE INDEX IF NOT EXISTS idx_chat_messages_sender 
ON chat_messages (sender);

-- Add index for reply_to for faster reply lookups
CREATE INDEX IF NOT EXISTS idx_chat_messages_reply_to 
ON chat_messages (reply_to) WHERE reply_to IS NOT NULL;

-- Add foreign key constraint for reply_to (optional but recommended)
DO $$ 
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'fk_chat_messages_reply_to'
  ) THEN
    ALTER TABLE chat_messages 
    ADD CONSTRAINT fk_chat_messages_reply_to 
    FOREIGN KEY (reply_to) REFERENCES chat_messages(id) ON DELETE SET NULL;
  END IF;
END $$;

-- Optional: Add a function to clean up old messages (keep last 500)
CREATE OR REPLACE FUNCTION cleanup_old_chat_messages()
RETURNS void AS $$
BEGIN
  DELETE FROM chat_messages
  WHERE id NOT IN (
    SELECT id FROM chat_messages
    ORDER BY created_at DESC
    LIMIT 500
  );
END;
$$ LANGUAGE plpgsql;

-- Optional: Create a scheduled job to run cleanup weekly
-- (Requires pg_cron extension - enable in Supabase dashboard if needed)
-- SELECT cron.schedule('cleanup-old-chats', '0 0 * * 0', 'SELECT cleanup_old_chat_messages()');

COMMENT ON COLUMN chat_messages.reactions IS 'Stores reactions as JSON: {"emoji": ["user1", "user2"]}';
