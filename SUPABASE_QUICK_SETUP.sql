-- Quick Setup for Enhanced Data Management
-- Run these commands one by one in your Supabase SQL editor

-- 1. Create storage bucket for user backups
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
    device_info JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create user profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT UNIQUE NOT NULL,
    email TEXT,
    display_name TEXT,
    avatar_url TEXT,
    preferences JSONB DEFAULT '{}',
    sync_settings JSONB DEFAULT '{}',
    last_sync TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create data sync log table
CREATE TABLE IF NOT EXISTS data_sync_log (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    sync_type TEXT NOT NULL,
    status TEXT NOT NULL,
    data_size BIGINT DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_backup_metadata_user_name ON backup_metadata(user_name);
CREATE INDEX IF NOT EXISTS idx_backup_metadata_created_at ON backup_metadata(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_name ON user_profiles(user_name);
CREATE INDEX IF NOT EXISTS idx_data_sync_log_user_name ON data_sync_log(user_name);

-- 6. Enable Row Level Security
ALTER TABLE backup_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_sync_log ENABLE ROW LEVEL SECURITY;

-- 7. Create basic RLS policies (you may need to adjust these based on your auth setup)
-- For backup_metadata
DROP POLICY IF EXISTS "Users can manage their own backup metadata" ON backup_metadata;
CREATE POLICY "Users can manage their own backup metadata" ON backup_metadata
    FOR ALL USING (true); -- Temporarily allow all access - adjust based on your auth

-- For user_profiles  
DROP POLICY IF EXISTS "Users can manage their own profile" ON user_profiles;
CREATE POLICY "Users can manage their own profile" ON user_profiles
    FOR ALL USING (true); -- Temporarily allow all access - adjust based on your auth

-- For data_sync_log
DROP POLICY IF EXISTS "Users can manage their own sync log" ON data_sync_log;
CREATE POLICY "Users can manage their own sync log" ON data_sync_log
    FOR ALL USING (true); -- Temporarily allow all access - adjust based on your auth

-- 8. Storage policies for user-backups bucket
DROP POLICY IF EXISTS "Users can manage their backups" ON storage.objects;
CREATE POLICY "Users can manage their backups" ON storage.objects
    FOR ALL USING (bucket_id = 'user-backups'); -- Temporarily allow all access

-- 9. Insert test user profile
INSERT INTO user_profiles (user_name, email, display_name, preferences, sync_settings) VALUES
('test_user', 'test@example.com', 'Test User',
 '{"theme": "dark", "notifications": true, "auto_backup": true}',
 '{"backup_frequency": "weekly", "cloud_sync": true, "auto_export": false}'
) ON CONFLICT (user_name) DO NOTHING;

-- 10. Grant permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;