-- =====================================================
-- VIDEO LIBRARY TABLE
-- Tech education videos (AWS, Java, CyberSecurity, etc.)
-- =====================================================

-- Create videos table
create table if not exists videos (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  youtube_link text not null,
  category text not null, -- 'AWS', 'Java', 'CyberSecurity', 'Flutter', 'Python'
  description text,
  thumbnail_url text, -- Optional custom thumbnail
  duration_minutes int, -- Video length
  min_tier_required text default 'free', -- 'free', 'pro', 'ultra'
  created_at timestamp with time zone default now()
);

-- Enable Row Level Security
alter table videos enable row level security;

-- Policy: Anyone can read videos (tier check happens in app)
create policy "Videos are viewable by everyone"
  on videos for select
  using (true);

-- Create index for faster category queries
create index if not exists idx_videos_category on videos(category);
create index if not exists idx_videos_tier on videos(min_tier_required);

-- Insert sample data
insert into videos (title, youtube_link, category, description, min_tier_required) values
  ('AWS Fundamentals', 'https://youtube.com/watch?v=SAMPLE1', 'AWS', 'Introduction to Amazon Web Services', 'free'),
  ('Java Design Patterns', 'https://youtube.com/watch?v=SAMPLE2', 'Java', 'Master OOP design patterns', 'pro'),
  ('Ethical Hacking Basics', 'https://youtube.com/watch?v=SAMPLE3', 'CyberSecurity', 'Learn penetration testing', 'pro'),
  ('Flutter State Management', 'https://youtube.com/watch?v=SAMPLE4', 'Flutter', 'Provider, Riverpod & Bloc', 'free'),
  ('Python Data Science', 'https://youtube.com/watch?v=SAMPLE5', 'Python', 'NumPy, Pandas & Matplotlib', 'free');

-- Success message
select 'Videos table created successfully!' as status;
