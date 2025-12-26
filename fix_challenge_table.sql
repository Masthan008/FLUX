-- =====================================================
-- CRITICAL FIX: Missing Table for Challenge Completion
-- =====================================================
-- This fixes the "Could not find table 'user_completed_tasks'" error
-- Run this in Supabase SQL Editor NOW
-- =====================================================

-- 1. Create the missing table
CREATE TABLE IF NOT EXISTS user_completed_tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES students(id) ON DELETE CASCADE,
  task_id TEXT NOT NULL,  -- Changed from challenge_id to match Flutter code
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  
  -- Prevent duplicate completions
  UNIQUE(user_id, task_id)
);

-- 2. Enable Row Level Security
ALTER TABLE user_completed_tasks ENABLE ROW LEVEL SECURITY;

-- 3. Allow students to insert and check their own tasks
CREATE POLICY "Students can manage their own tasks"
ON user_completed_tasks FOR ALL
USING (true)
WITH CHECK (true);

-- 4. Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_user_completed_tasks_user_id 
ON user_completed_tasks(user_id);

CREATE INDEX IF NOT EXISTS idx_user_completed_tasks_task_id 
ON user_completed_tasks(task_id);

-- =====================================================
-- VERIFICATION: Check if table was created
-- =====================================================
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'user_completed_tasks'
ORDER BY ordinal_position;

-- Expected output:
-- user_completed_tasks | id            | uuid
-- user_completed_tasks | user_id       | uuid
-- user_completed_tasks | task_id       | text
-- user_completed_tasks | completed_at  | timestamp with time zone
