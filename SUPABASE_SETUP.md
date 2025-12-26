# 🚀 Supabase Real-Time News Feed Setup

## 📋 Prerequisites
1. Create a Supabase account at https://supabase.com
2. Create a new project

## 🗄️ Database Setup

### Step 1: Create the `news` table
Run this SQL in your Supabase SQL Editor:

```sql
-- Create news table
CREATE TABLE news (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE news ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Allow public read access" 
ON news FOR SELECT 
TO public 
USING (true);

-- Optional: Create policy for authenticated inserts
CREATE POLICY "Allow authenticated inserts" 
ON news FOR INSERT 
TO authenticated 
WITH CHECK (true);
```

### Step 2: Enable Realtime
1. Go to Database → Replication in your Supabase dashboard
2. Find the `news` table
3. Toggle "Enable Realtime" ON

## 🔑 Get Your Credentials

1. Go to Project Settings → API
2. Copy your:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **Anon/Public Key** (starts with `eyJ...`)

## 📱 Configure Your App

Open `lib/main.dart` and replace the placeholders:

```dart
await NewsService.initialize(
  url: 'https://your-project.supabase.co',  // Replace with your URL
  anonKey: 'eyJhbGc...your-key-here',       // Replace with your anon key
);
```

## 🧪 Test Your Setup

### Add test data via Supabase Dashboard:
1. Go to Table Editor → news
2. Click "Insert row"
3. Add:
   - **title**: "Welcome to FluxFlow!"
   - **description**: "Your real-time news feed is now live!"
4. Save

The news should appear instantly in your app! 🎉

## 📝 Sample Data (Optional)

Run this SQL to add sample news:

```sql
INSERT INTO news (title, description) VALUES
  ('System Update', 'FluxFlow v2.0 is now available with enhanced features!'),
  ('New Feature', 'Real-time notifications are now enabled across all modules.'),
  ('Maintenance Notice', 'Scheduled maintenance on Sunday 2 AM - 4 AM EST.');
```

## 🔧 Troubleshooting

### Error: "Invalid API key"
- Double-check your anon key in `main.dart`
- Make sure you copied the full key

### Error: "Table not found"
- Verify the `news` table exists in your database
- Check table name spelling (case-sensitive)

### No real-time updates
- Ensure Realtime is enabled for the `news` table
- Check your internet connection
- Verify RLS policies allow SELECT

## 🎨 Customization

### Add more fields to news:
```sql
ALTER TABLE news ADD COLUMN priority TEXT DEFAULT 'normal';
ALTER TABLE news ADD COLUMN category TEXT;
ALTER TABLE news ADD COLUMN image_url TEXT;
```

Then update `news_service.dart` and `news_screen.dart` to display them!

---

**Need help?** Check Supabase docs: https://supabase.com/docs
