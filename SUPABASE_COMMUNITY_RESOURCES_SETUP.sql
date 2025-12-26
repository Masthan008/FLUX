-- =====================================================
-- COMMUNITY RESOURCES SYSTEM - SUPABASE SETUP
-- Real-time Books & Notes Sharing Platform
-- =====================================================

-- 1. Create community_resources table
CREATE TABLE IF NOT EXISTS public.community_resources (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    uploader_name TEXT NOT NULL,
    book_name TEXT NOT NULL,
    category TEXT NOT NULL,
    resource_type TEXT NOT NULL CHECK (resource_type IN ('link', 'file')),
    resource_url TEXT,
    file_path TEXT,
    file_name TEXT,
    file_size BIGINT,
    file_type TEXT,
    description TEXT,
    download_count INTEGER DEFAULT 0,
    uploaded_by UUID REFERENCES auth.users(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_community_resources_category ON public.community_resources(category);
CREATE INDEX IF NOT EXISTS idx_community_resources_type ON public.community_resources(resource_type);
CREATE INDEX IF NOT EXISTS idx_community_resources_created ON public.community_resources(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_community_resources_uploader ON public.community_resources(uploaded_by);

-- 3. Enable Row Level Security
ALTER TABLE public.community_resources ENABLE ROW LEVEL SECURITY;

-- 4. Create RLS Policies

-- Allow anyone to read resources
CREATE POLICY "Anyone can view community resources"
ON public.community_resources
FOR SELECT
USING (true);

-- Allow authenticated users to insert resources
CREATE POLICY "Authenticated users can upload resources"
ON public.community_resources
FOR INSERT
TO authenticated
WITH CHECK (true);

-- Allow users to update their own resources
CREATE POLICY "Users can update their own resources"
ON public.community_resources
FOR UPDATE
TO authenticated
USING (auth.uid() = uploaded_by);

-- Allow users to delete their own resources
CREATE POLICY "Users can delete their own resources"
ON public.community_resources
FOR DELETE
TO authenticated
USING (auth.uid() = uploaded_by);

-- 5. Create function to increment download count
CREATE OR REPLACE FUNCTION increment_download_count(resource_id UUID)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE public.community_resources
    SET download_count = download_count + 1,
        updated_at = NOW()
    WHERE id = resource_id;
END;
$$;

-- 6. Create function to get resources by category
CREATE OR REPLACE FUNCTION get_resources_by_category(cat TEXT)
RETURNS SETOF public.community_resources
LANGUAGE sql
STABLE
AS $$
    SELECT * FROM public.community_resources
    WHERE category = cat
    ORDER BY created_at DESC;
$$;

-- 7. Create function to search resources
CREATE OR REPLACE FUNCTION search_resources(search_term TEXT)
RETURNS SETOF public.community_resources
LANGUAGE sql
STABLE
AS $$
    SELECT * FROM public.community_resources
    WHERE 
        book_name ILIKE '%' || search_term || '%' OR
        uploader_name ILIKE '%' || search_term || '%' OR
        description ILIKE '%' || search_term || '%'
    ORDER BY created_at DESC;
$$;

-- 8. Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_community_resources_updated_at
    BEFORE UPDATE ON public.community_resources
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 9. Enable Realtime for the table
ALTER PUBLICATION supabase_realtime ADD TABLE public.community_resources;

-- =====================================================
-- STORAGE BUCKET SETUP
-- =====================================================

-- Note: Storage bucket 'community-books' should be created in Supabase Dashboard
-- Bucket Settings:
-- - Name: community-books
-- - Public: true (for easy downloads)
-- - File size limit: 50MB
-- - Allowed MIME types: application/pdf, application/vnd.openxmlformats-officedocument.wordprocessingml.document, 
--                       application/vnd.ms-powerpoint, application/vnd.openxmlformats-officedocument.presentationml.presentation

-- Storage policies (run in Supabase Dashboard SQL Editor)
-- Allow authenticated users to upload
CREATE POLICY "Authenticated users can upload files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'community-books');

-- Allow anyone to download files
CREATE POLICY "Anyone can download files"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'community-books');

-- Allow users to delete their own files
CREATE POLICY "Users can delete their own files"
ON storage.objects FOR DELETE
TO authenticated
USING (bucket_id = 'community-books' AND auth.uid()::text = (storage.foldername(name))[1]);

-- =====================================================
-- SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Insert sample resources
INSERT INTO public.community_resources (
    uploader_name,
    book_name,
    category,
    resource_type,
    resource_url,
    description
) VALUES
    ('John Doe', 'Introduction to Algorithms', 'Computer Science', 'link', 'https://example.com/algorithms.pdf', 'Comprehensive guide to algorithms'),
    ('Jane Smith', 'Data Structures Notes', 'Computer Science', 'link', 'https://example.com/ds-notes.pdf', 'Complete data structures notes'),
    ('Mike Johnson', 'Web Development Guide', 'Web Development', 'link', 'https://example.com/web-dev.pdf', 'Full stack web development guide');

-- =====================================================
-- USEFUL QUERIES
-- =====================================================

-- Get all resources
-- SELECT * FROM public.community_resources ORDER BY created_at DESC;

-- Get resources by category
-- SELECT * FROM get_resources_by_category('Computer Science');

-- Search resources
-- SELECT * FROM search_resources('algorithm');

-- Get most downloaded resources
-- SELECT * FROM public.community_resources ORDER BY download_count DESC LIMIT 10;

-- Get recent uploads
-- SELECT * FROM public.community_resources WHERE created_at > NOW() - INTERVAL '7 days' ORDER BY created_at DESC;

-- =====================================================
-- MAINTENANCE
-- =====================================================

-- Clean up old resources (optional - run periodically)
-- DELETE FROM public.community_resources WHERE created_at < NOW() - INTERVAL '1 year';

-- Reset download counts (if needed)
-- UPDATE public.community_resources SET download_count = 0;

-- =====================================================
-- NOTES
-- =====================================================
-- 1. Make sure to create the 'community-books' bucket in Supabase Dashboard
-- 2. Set appropriate file size limits and MIME types
-- 3. Enable Realtime in Supabase Dashboard for the table
-- 4. Test upload and download functionality
-- 5. Monitor storage usage regularly
