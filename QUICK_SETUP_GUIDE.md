# ⚡ Quick Setup Guide - Update 36.0

## 🎯 5-Minute Setup

### Step 1: Supabase SQL (2 minutes)
1. Open **Supabase Dashboard**
2. Go to **SQL Editor**
3. Copy entire content of `SUPABASE_ATTENDANCE_SETUP.sql`
4. Paste and click **"Run"**
5. Wait for success message

### Step 2: Storage Bucket (2 minutes)
1. Go to **Storage** tab
2. Click **"New Bucket"**
3. Name: `attendance_proofs`
4. Check **"Public bucket"** ✅
5. Click **"Save"**
6. Click on the bucket
7. Go to **"Policies"** tab
8. Click **"New Policy"**
9. Choose **"For full customization"**
10. Fill in:
    - Policy name: `Public Access`
    - Allowed operations: All (SELECT, INSERT, UPDATE, DELETE)
    - Target roles: `public`
    - USING: `true`
    - WITH CHECK: `true`
11. Click **"Review"** → **"Save Policy"**

### Step 3: Build APK (1 minute)
```bash
flutter build apk --release
```

### Step 4: Test (5 minutes)
1. Install APK on 2 phones (teacher + student)
2. Teacher: Open dashboard → Set location
3. Student: Open attendance → Check in
4. Teacher: Verify record appears with photo

---

## ✅ Verification Checklist

After setup, verify these:

### Database
- [ ] `class_coordinates` table exists
- [ ] `attendance_logs` has `proof_url` column
- [ ] Policies are enabled
- [ ] Realtime is enabled

### Storage
- [ ] `attendance_proofs` bucket exists
- [ ] Bucket is public
- [ ] Upload policy is enabled

### App
- [ ] Teacher can set location
- [ ] Student can see distance
- [ ] Camera opens for face scan
- [ ] Photo uploads successfully
- [ ] Attendance is marked
- [ ] Teacher can view proof

---

## 🚨 Common Issues

### Issue: "Upload failed"
**Fix:** Storage bucket not created or not public

### Issue: "Waiting for teacher" forever
**Fix:** Teacher needs to click "Set Location" button

### Issue: "No face detected"
**Fix:** Better lighting, face camera directly

### Issue: Distance always large
**Fix:** Teacher must set location from actual classroom

---

## 📞 Support

If issues persist:
1. Check Supabase logs
2. Check Flutter console for errors
3. Verify all SQL commands ran successfully
4. Verify storage bucket is public

---

**Setup complete! System is ready to use.** 🎉
