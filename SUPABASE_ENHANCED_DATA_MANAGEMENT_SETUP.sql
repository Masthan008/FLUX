-- Enhanced Data Management Setup for FluxFlow
-- Run these SQL commands in your Supabase SQL editor

-- Create storage bucket for user backups
INSERT INTO storage.buckets (id, name, public) 
VALUES ('user-backups', 'user-backups', false);

-- Create backup metadata table
CREATE TABLE IF NOT EXISTS backup_metadata (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    file_name TEXT NOT NULL,
    file_size BIGINT DEFAULT 0,
    backup_version TEXT DEFAULT '2.0.0',
    device_info JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user profiles table for enhanced cloud sync
CREATE TABLE IF NOT EXISTS user_profiles (
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

-- Create data sync log table
CREATE TABLE IF NOT EXISTS data_sync_log (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    sync_type TEXT NOT NULL, -- 'backup', 'restore', 'sync'
    status TEXT NOT NULL, -- 'success', 'failed', 'partial'
    data_size BIGINT DEFAULT 0,
    error_message TEXT,
    sync_details JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create enhanced community books table with better metadata
CREATE TABLE IF NOT EXISTS community_books_enhanced (
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
    metadata JSONB,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create book ratings table
CREATE TABLE IF NOT EXISTS book_ratings (
    id BIGSERIAL PRIMARY KEY,
    book_id BIGINT REFERENCES community_books_enhanced(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(book_id, user_name)
);

-- Create user activity log for analytics
CREATE TABLE IF NOT EXISTS user_activity_log (
    id BIGSERIAL PRIMARY KEY,
    user_name TEXT NOT NULL,
    activity_type TEXT NOT NULL, -- 'login', 'backup', 'restore', 'export', 'sync'
    activity_data JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_backup_metadata_user_name ON backup_metadata(user_name);
CREATE INDEX IF NOT EXISTS idx_backup_metadata_created_at ON backup_metadata(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_profiles_user_name ON user_profiles(user_name);
CREATE INDEX IF NOT EXISTS idx_data_sync_log_user_name ON data_sync_log(user_name);
CREATE INDEX IF NOT EXISTS idx_data_sync_log_created_at ON data_sync_log(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_books_enhanced_subject ON community_books_enhanced(subject);
CREATE INDEX IF NOT EXISTS idx_community_books_enhanced_uploaded_by ON community_books_enhanced(uploaded_by);
CREATE INDEX IF NOT EXISTS idx_community_books_enhanced_created_at ON community_books_enhanced(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_book_ratings_book_id ON book_ratings(book_id);
CREATE INDEX IF NOT EXISTS idx_user_activity_log_user_name ON user_activity_log(user_name);
CREATE INDEX IF NOT EXISTS idx_user_activity_log_created_at ON user_activity_log(created_at DESC);

-- Create RLS (Row Level Security) policies
ALTER TABLE backup_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE data_sync_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE community_books_enhanced ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_activity_log ENABLE ROW LEVEL SECURITY;

-- Backup metadata policies
CREATE POLICY "Users can view their own backup metadata" ON backup_metadata
    FOR SELECT USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can insert their own backup metadata" ON backup_metadata
    FOR INSERT WITH CHECK (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can update their own backup metadata" ON backup_metadata
    FOR UPDATE USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- User profiles policies
CREATE POLICY "Users can view their own profile" ON user_profiles
    FOR SELECT USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can insert their own profile" ON user_profiles
    FOR INSERT WITH CHECK (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can update their own profile" ON user_profiles
    FOR UPDATE USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- Data sync log policies
CREATE POLICY "Users can view their own sync log" ON data_sync_log
    FOR SELECT USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can insert their own sync log" ON data_sync_log
    FOR INSERT WITH CHECK (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- Community books policies
CREATE POLICY "Anyone can view community books" ON community_books_enhanced
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own books" ON community_books_enhanced
    FOR INSERT WITH CHECK (uploaded_by = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can update their own books" ON community_books_enhanced
    FOR UPDATE USING (uploaded_by = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can delete their own books" ON community_books_enhanced
    FOR DELETE USING (uploaded_by = current_setting('request.jwt.claims', true)::json->>'user_name');

-- Book ratings policies
CREATE POLICY "Anyone can view book ratings" ON book_ratings
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own ratings" ON book_ratings
    FOR INSERT WITH CHECK (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can update their own ratings" ON book_ratings
    FOR UPDATE USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can delete their own ratings" ON book_ratings
    FOR DELETE USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- User activity log policies
CREATE POLICY "Users can view their own activity log" ON user_activity_log
    FOR SELECT USING (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

CREATE POLICY "Users can insert their own activity log" ON user_activity_log
    FOR INSERT WITH CHECK (user_name = current_setting('request.jwt.claims', true)::json->>'user_name');

-- Create functions for automatic updates
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_backup_metadata_updated_at BEFORE UPDATE ON backup_metadata
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_profiles_updated_at BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_community_books_enhanced_updated_at BEFORE UPDATE ON community_books_enhanced
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create function to update book ratings
CREATE OR REPLACE FUNCTION update_book_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE community_books_enhanced 
    SET rating = (
        SELECT AVG(rating)::DECIMAL(3,2) 
        FROM book_ratings 
        WHERE book_id = NEW.book_id
    )
    WHERE id = NEW.book_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for book rating updates
CREATE TRIGGER update_book_rating_trigger 
    AFTER INSERT OR UPDATE OR DELETE ON book_ratings
    FOR EACH ROW EXECUTE FUNCTION update_book_rating();

-- Create function to log user activity
CREATE OR REPLACE FUNCTION log_user_activity(
    p_user_name TEXT,
    p_activity_type TEXT,
    p_activity_data JSONB DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO user_activity_log (user_name, activity_type, activity_data)
    VALUES (p_user_name, p_activity_type, p_activity_data);
END;
$$ language 'plpgsql';

-- Storage policies for user-backups bucket
CREATE POLICY "Users can upload their own backups" ON storage.objects
    FOR INSERT WITH CHECK (
        bucket_id = 'user-backups' AND 
        (storage.foldername(name))[1] = (current_setting('request.jwt.claims', true)::json->>'user_name')
    );

CREATE POLICY "Users can view their own backups" ON storage.objects
    FOR SELECT USING (
        bucket_id = 'user-backups' AND 
        (storage.foldername(name))[1] = (current_setting('request.jwt.claims', true)::json->>'user_name')
    );

CREATE POLICY "Users can update their own backups" ON storage.objects
    FOR UPDATE USING (
        bucket_id = 'user-backups' AND 
        (storage.foldername(name))[1] = (current_setting('request.jwt.claims', true)::json->>'user_name')
    );

CREATE POLICY "Users can delete their own backups" ON storage.objects
    FOR DELETE USING (
        bucket_id = 'user-backups' AND 
        (storage.foldername(name))[1] = (current_setting('request.jwt.claims', true)::json->>'user_name')
    );

-- Insert some sample data for testing
INSERT INTO user_profiles (user_name, email, display_name, preferences, sync_settings) VALUES
('test_user', 'test@example.com', 'Test User',
 '{"theme": "dark", "notifications": true, "auto_backup": true}',
 '{"backup_frequency": "weekly", "cloud_sync": true, "auto_export": false}'
) ON CONFLICT (user_name) DO NOTHING;

-- Create view for backup statistics
CREATE OR REPLACE VIEW backup_statistics AS
SELECT 
    user_name,
    COUNT(*) as total_backups,
    SUM(file_size) as total_size,
    AVG(file_size) as avg_size,
    MAX(created_at) as last_backup,
    MIN(created_at) as first_backup
FROM backup_metadata
GROUP BY user_name;

-- Create view for user activity summary
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

-- Grant necessary permissions
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO anon, authenticated;

-- Enable realtime for important tables
ALTER PUBLICATION supabase_realtime ADD TABLE backup_metadata;
ALTER PUBLICATION supabase_realtime ADD TABLE user_profiles;
ALTER PUBLICATION supabase_realtime ADD TABLE community_books_enhanced;

COMMENT ON TABLE backup_metadata IS 'Stores metadata about user backups';
COMMENT ON TABLE user_profiles IS 'Enhanced user profiles with sync settings';
COMMENT ON TABLE data_sync_log IS 'Logs all data synchronization activities';
COMMENT ON TABLE community_books_enhanced IS 'Enhanced community books with ratings and metadata';
COMMENT ON TABLE book_ratings IS 'User ratings and reviews for community books';
COMMENT ON TABLE user_activity_log IS 'Comprehensive user activity logging';