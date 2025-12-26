# 🗄️ Supabase Database Setup - Quick Reference

## Current Table: `news`

### Required Columns:
```sql
id          | int8      | Primary Key (auto-generated)
title       | text      | News headline
description | text      | News body/content
created_at  | timestamp | Auto-generated timestamp
image_url   | text      | URL to image (NEW - for Pro upgrade)
```

---

## 🚀 Quick Setup Commands

### Step 1: Add the `image_url` column

Go to **Supabase Dashboard** → **SQL Editor** → Run this:

```sql
ALTER TABLE news 
ADD COLUMN IF NOT EXISTS image_url TEXT;
```

Or use the **Table Editor**:
1. Open `news` table
2. Click **"+" (Add Column)**
3. Name: `image_url`, Type: `text`
4. Save

---

## 📦 Step 2: Create Storage Bucket

1. Go to **Storage** → **New Bucket**
2. Name: `news_images`
3. **Public:** ✅ **MUST BE CHECKED**
4. Save

---

## 🧪 Test Data Examples

### News without image:
```sql
INSERT INTO news (title, description) 
VALUES ('Exam Postponed', 'The midterm exam has been moved to next Friday.');
```

### News with image:
```sql
INSERT INTO news (title, description, image_url) 
VALUES (
  'Campus Event', 
  'Join us for the annual tech fest this Saturday!',
  'https://gnlkgstnulfenqxvrsur.supabase.co/storage/v1/object/public/news_images/event.jpg'
);
```

### News with external image:
```sql
INSERT INTO news (title, description, image_url) 
VALUES (
  'Holiday Notice', 
  'Campus will be closed on Monday for maintenance.',
  'https://i.imgur.com/example.jpg'
);
```

---

## 🔐 Security Policies (Optional but Recommended)

If you want to restrict who can insert news:

```sql
-- Allow anyone to READ news (already default for public bucket)
CREATE POLICY "Anyone can read news" ON news
FOR SELECT USING (true);

-- Only authenticated users can INSERT news
CREATE POLICY "Only admins can insert news" ON news
FOR INSERT WITH CHECK (auth.role() = 'authenticated');
```

---

## 📱 How to Upload Images

### Method 1: Supabase Dashboard
1. Storage → `news_images` → Upload
2. Click uploaded file → Copy Public URL
3. Paste URL into `image_url` column

### Method 2: Direct URL
- Use any public image URL (Imgur, Cloudinary, etc.)
- Just paste it into `image_url`

---

## ✅ Verification Checklist

- [ ] `news` table exists
- [ ] `image_url` column added
- [ ] `news_images` bucket created
- [ ] Bucket is **PUBLIC**
- [ ] Test row inserted successfully
- [ ] App shows notification when new row added
- [ ] Image displays in app (if URL provided)

---

## 🐛 Common Issues

### "Image not loading"
- Check if bucket is PUBLIC
- Verify URL is correct (copy-paste from Supabase)
- Check if image file is actually uploaded

### "No notification"
- Ensure app is running (foreground or background)
- Check notification permissions in Android settings
- Restart app after first news insert

### "Column doesn't exist"
- Run the ALTER TABLE command above
- Or add column manually via Table Editor

---

**Your database is ready for the Pro News Feed! 🎉**
