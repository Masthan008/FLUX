-- MINIMAL Supabase Setup - Run this if you want just the essential features
-- Copy and paste each section one by one into your Supabase SQL editor

-- 1. Create storage bucket
INSERT INTO storage.buckets (id, name, public) 
VALUES ('user-backups', 'user-backups', false)
ON CONFLICT (id) DO NOTHING;

-- 2. Create backup metadata table
CREATE TABLE IF NOT EXISTS backup_metadata (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,
    backup_version TEXT DEFAULT '2.0.0',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create user profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT UNIQUE NOT NULL,
    email TEXT,
    display_name TEXT,
    preferences JSONB DEFAULT '{}',
    sync_settings JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create basic indexes
CREATE INDEX IF NOT EXISTS idx_backup_metadata_user_name ON backup_metadata(user_name);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_name ON user_profiles(user_name);

-- 5. Enable RLS and create permissive policies
ALTER TABLE backup_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow all backup access" ON backup_metadata;
CREATE POLICY "Allow all backup access" ON backup_metadata FOR ALL USING (true);

DROP POLICY IF EXISTS "Allow all profile access" ON user_profiles;
CREATE POLICY "Allow all profile access" ON user_profiles FOR ALL USING (true);

-- 6. Storage policy
DROP POLICY IF EXISTS "Allow backup storage access" ON storage.objects;
CREATE POLICY "Allow backup storage access" ON storage.objects 
FOR ALL USING (bucket_id = 'user-backups');

-- 7. Insert test user
INSERT INTO user_profiles (user_name, email, display_name, preferences, sync_settings) 
VALUES (
    'test_user', 
    'test@example.com', 
    'Test User',
    '{"theme": "dark"}',
    '{"backup_frequency": "weekly"}'
) ON CONFLICT (user_name) DO NOTHING;

-- 8. Grant permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;

-- Done! Check if it worked:
SELECT 'Minimal setup completed!' as status;
SELECT COUNT(*) as user_profiles_count FROM user_profiles;
SELECT COUNT(*) as backup_metadata_count FROM backup_metadata;