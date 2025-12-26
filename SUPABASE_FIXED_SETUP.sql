-- FIXED Supabase Setup for Enhanced Data Management
-- Run these commands step by step in your Supabase SQL editor

-- Step 1: Create storage bucket for user backups
INSERT INTO storage.buckets (id, name, public) 
VALUES ('user-backups', 'user-backups', false)
ON CONFLICT (id) DO NOTHING;

-- Step 2: Drop existing tables if they exist (to start fresh)
DROP TABLE IF EXISTS backup_metadata CASCADE;
DROP TABLE IF EXISTS user_profiles CASCADE;
DROP TABLE IF EXISTS data_sync_log CASCADE;
DROP TABLE IF EXISTS community_books_enhanced CASCADE;
DROP TABLE IF EXISTS book_ratings CASCADE;
DROP TABLE IF EXISTS user_activity_log CASCADE;

-- Step 3: Create backup metadata table
CREATE TABLE backup_metadata (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,
    backup_version TEXT DEFAULT '2.0.0',
    device_info JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 4: Create user profiles table with correct structure
CREATE TABLE user_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT UNIQUE NOT NULL,
    email TEXT,
    display_name TEXT,
    avatar_url TEXT,
    preferences JSONB DEFAULT '{}',
    sync_settings JSONB DEFAULT '{}',
    last_sync TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 5: Create data sync log table
CREATE TABLE data_sync_log (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    sync_type TEXT NOT NULL,
    status TEXT NOT NULL,
    data_size BIGINT DEFAULT 0,
    error_message TEXT,
    sync_details JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 6: Create enhanced community books table
CREATE TABLE community_books_enhanced (
    id BIGSERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT,
    description TEXT,
    subject TEXT,
    file_url TEXT,
    file_name TEXT,
    file_size BIGINT,
    file_type TEXT,
    uploaded_by TEXT NOT NULL,
    download_count INTEGER DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0.0,
    tags TEXT[],
    metadata JSONB DEFAULT '{}',
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 7: Create book ratings table
CREATE TABLE book_ratings (
    id BIGSERIAL PRIMARY KEY,
    book_id BIGINT REFERENCES community_books_enhanced(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(book_id, user_name)
);

-- Step 8: Create user activity log table
CREATE TABLE user_activity_log (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    activity_type TEXT NOT NULL,
    activity_data JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Step 9: Create indexes for better performance
CREATE INDEX idx_backup_metadata_user_name ON backup_metadata(user_name);
CREATE INDEX idx_backup_metadata_created_at ON backup_metadata(created_at DESC);
CREATE INDEX idx_user_profiles_user_name ON user_profiles(user_name);
CREATE INDEX idx_data_sync_log_user_name ON data_sync_log(user_name);
CREATE INDEX idx_data_sync_log_created_at ON data_sync_log(created_at DESC);
CREATE INDEX idx_community_books_enhanced_subject ON community_books_enhanced(subject);
CREATE INDEX idx_community_books_enhanced_uploaded_by ON community_books_enhanced(uploaded_by);
CREATE INDEX idx_community_books_enhanced_created_at ON community_books_enhanced(created_at DESC);
CREATE INDEX idx_book_ratings_book_id ON book_ratings(book_id);
CREATE INDEX idx_user_activity_log_user_name ON user_activity_log(user_name);
CREATE INDEX idx_user_activity_log_created_at ON user_activity_log(created_at DESC);

-- Step 10: Enable Row Level Security
ALTER TABLE backup_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_sync_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_books_enhanced ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_activity_log ENABLE ROW LEVEL SECURITY;

-- Step 11: Create RLS policies (allowing all access for now - adjust based on your auth setup)
CREATE POLICY "Allow all access to backup_metadata" ON backup_metadata FOR ALL USING (true);
CREATE POLICY "Allow all access to user_profiles" ON user_profiles FOR ALL USING (true);
CREATE POLICY "Allow all access to data_sync_log" ON data_sync_log FOR ALL USING (true);
CREATE POLICY "Allow all access to community_books_enhanced" ON community_books_enhanced FOR ALL USING (true);
CREATE POLICY "Allow all access to book_ratings" ON book_ratings FOR ALL USING (true);
CREATE POLICY "Allow all access to user_activity_log" ON user_activity_log FOR ALL USING (true);

-- Step 12: Create storage policies
CREATE POLICY "Allow all access to user backups" ON storage.objects 
FOR ALL USING (bucket_id = 'user-backups');

-- Step 13: Create functions for automatic updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Step 14: Create triggers for updated_at columns
CREATE TRIGGER update_backup_metadata_updated_at 
    BEFORE UPDATE ON backup_metadata
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at 
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_community_books_enhanced_updated_at 
    BEFORE UPDATE ON community_books_enhanced
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Step 15: Create function to update book ratings
CREATE OR REPLACE FUNCTION update_book_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE community_books_enhanced 
    SET rating = (
        SELECT COALESCE(AVG(rating)::DECIMAL(3,2), 0.0)
        FROM book_ratings 
        WHERE book_id = COALESCE(NEW.book_id, OLD.book_id)
    )
    WHERE id = COALESCE(NEW.book_id, OLD.book_id);
    RETURN COALESCE(NEW, OLD);
END;
$$ language 'plpgsql';

-- Step 16: Create trigger for book rating updates
CREATE TRIGGER update_book_rating_trigger 
    AFTER INSERT OR UPDATE OR DELETE ON book_ratings
    FOR EACH ROW EXECUTE FUNCTION update_book_rating();

-- Step 17: Create function to log user activity
CREATE OR REPLACE FUNCTION log_user_activity(
    p_user_name TEXT,
    p_activity_type TEXT,
    p_activity_data JSONB DEFAULT '{}'
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO user_activity_log (user_name, activity_type, activity_data)
    VALUES (p_user_name, p_activity_type, p_activity_data);
END;
$$ language 'plpgsql';

-- Step 18: NOW insert sample data (after tables are created)
INSERT INTO user_profiles (user_name, email, display_name, preferences, sync_settings) 
VALUES (
    'test_user', 
    'test@example.com', 
    'Test User',
    '{"theme": "dark", "notifications": true, "auto_backup": true}',
    '{"backup_frequency": "weekly", "cloud_sync": true, "auto_export": false}'
) ON CONFLICT (user_name) DO NOTHING;

-- Step 19: Create views for statistics
CREATE OR REPLACE VIEW backup_statistics AS
SELECT 
    user_name,
    COUNT(*) as total_backups,
    COALESCE(SUM(file_size), 0) as total_size,
    COALESCE(AVG(file_size), 0) as avg_size,
    MAX(created_at) as last_backup,
    MIN(created_at) as first_backup
FROM backup_metadata
GROUP BY user_name;

CREATE OR REPLACE VIEW user_activity_summary AS
SELECT 
    user_name,
    activity_type,
    COUNT(*) as activity_count,
    MAX(created_at) as last_activity,
    DATE_TRUNC('day', created_at) as activity_date
FROM user_activity_log
GROUP BY user_name, activity_type, DATE_TRUNC('day', created_at)
ORDER BY activity_date DESC;

-- Step 20: Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;

-- Step 21: Enable realtime for important tables (optional)
-- ALTER PUBLICATION supabase_realtime ADD TABLE backup_metadata;
-- ALTER PUBLICATION supabase_realtime ADD TABLE user_profiles;
-- ALTER PUBLICATION supabase_realtime ADD TABLE community_books_enhanced;

-- Step 22: Add comments for documentation
COMMENT ON TABLE backup_metadata IS 'Stores metadata about user backups';
COMMENT ON TABLE user_profiles IS 'Enhanced user profiles with sync settings';
COMMENT ON TABLE data_sync_log IS 'Logs all data synchronization activities';
COMMENT ON TABLE community_books_enhanced IS 'Enhanced community books with ratings and metadata';
COMMENT ON TABLE book_ratings IS 'User ratings and reviews for community books';
COMMENT ON TABLE user_activity_log IS 'Comprehensive user activity logging';

-- Verification: Check if everything was created successfully
SELECT 'Setup completed successfully!' as status;
SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN (
    'backup_metadata', 'user_profiles', 'data_sync_log', 
    'community_books_enhanced', 'book_ratings', 'user_activity_log'
) ORDER BY table_name;