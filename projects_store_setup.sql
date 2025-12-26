-- =====================================================
-- Projects Store - Database Setup
-- =====================================================
-- Run this in Supabase SQL Editor
-- =====================================================

-- 1. Create the Projects Table
CREATE TABLE IF NOT EXISTS projects (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  zip_link TEXT NOT NULL,
  category TEXT NOT NULL,
  min_tier TEXT DEFAULT 'free',
  downloads INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

-- 3. Allow everyone to read projects (they'll be filtered by tier in the app)
CREATE POLICY "Allow public read access on projects"
ON projects FOR SELECT
USING (true);

-- 4. Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_projects_category ON projects(category);
CREATE INDEX IF NOT EXISTS idx_projects_tier ON projects(min_tier);

-- 5. Add sample projects
INSERT INTO projects (title, description, zip_link, category, min_tier)
VALUES
-- FREE TIER PROJECTS
('Simple Calculator', 'Python • Tkinter • Basic Math Operations', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Python', 'free'),
('To-Do List App', 'JavaScript • HTML • CSS • LocalStorage', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Web', 'free'),
('Number Guessing Game', 'C • Console Application • Random Numbers', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'C', 'free'),

-- PRO TIER PROJECTS
('Library Management System', 'Java • MySQL • Swing GUI • CRUD Operations', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Java', 'pro'),
('Inventory Management', 'Python • Django • SQLite • Admin Panel', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Python', 'pro'),
('Student Attendance System', 'PHP • MySQL • Bootstrap • QR Code Scanner', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Web', 'pro'),
('Weather App', 'Android • Java • API Integration • Material Design', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Android', 'pro'),

-- ULTRA TIER PROJECTS
('AI Chatbot', 'Python • TensorFlow • NLP • Flask API', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'AI', 'ultra'),
('E-Commerce Platform', 'React • Node.js • MongoDB • Payment Gateway', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Web', 'ultra'),
('Traffic Detection System', 'Python • OpenCV • YOLO • Real-time Detection', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'AI', 'ultra'),
('Face Recognition Attendance', 'Python • OpenCV • Face Recognition • Database', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'AI', 'ultra'),
('Hospital Management System', 'Java • Spring Boot • MySQL • REST API', 'https://drive.google.com/file/d/SAMPLE_ID/view', 'Java', 'ultra');

-- 6. Verify the data
SELECT title, category, min_tier FROM projects ORDER BY min_tier, category;

-- =====================================================
-- Expected Output:
-- You should see 12 projects across 3 tiers
-- =====================================================
