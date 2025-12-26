# 📦 Storage Bucket Setup Guide

## ⚠️ CRITICAL - This Must Be Done Manually

The storage bucket **CANNOT** be created via SQL. You **MUST** do this through the Supabase Dashboard.

---

## 🎯 Step-by-Step Instructions

### Step 1: Navigate to Storage
1. Open your **Supabase Dashboard**
2. Select your project
3. Click **"Storage"** in the left sidebar

### Step 2: Create New Bucket
1. Click the **"New Bucket"** button (top right)
2. A dialog will appear

### Step 3: Configure Bucket
Fill in these exact settings:

**Bucket Name:**
```
attendance_proofs
```
⚠️ **Must be exactly this name** (no spaces, no capitals)

**Public Bucket:**
```
✅ CHECKED
```
⚠️ **This is CRITICAL** - Without this, uploads will fail

**File Size Limit:**
```
Leave default (50 MB is fine)
```

**Allowed MIME Types:**
```
Leave default (or add: image/jpeg, image/png)
```

### Step 4: Save Bucket
1. Click **"Save"** button
2. Wait for confirmation
3. Bucket should now appear in the list

---

## 🔐 Step 5: Configure Policies (CRITICAL)

### Navigate to Policies
1. Click on the **"attendance_proofs"** bucket
2. Click the **"Policies"** tab at the top
3. You should see "No policies created yet"

### Create New Policy
1. Click **"New Policy"** button
2. Select **"For full customization"** (not a template)

### Policy Configuration
Fill in these exact settings:

**Policy Name:**
```
Public Access
```

**Allowed Operations:**
Select **ALL** checkboxes:
- ✅ SELECT (read)
- ✅ INSERT (upload)
- ✅ UPDATE (modify)
- ✅ DELETE (remove)

**Target Roles:**
```
public
```
⚠️ Type exactly: `public` (lowercase)

**USING Expression:**
```sql
true
```
⚠️ Type exactly: `true` (lowercase)

**WITH CHECK Expression:**
```sql
true
```
⚠️ Type exactly: `true` (lowercase)

### Save Policy
1. Click **"Review"** button
2. Verify settings are correct
3. Click **"Save Policy"**
4. Policy should now appear in the list

---

## ✅ Verification

### Check Bucket Settings
1. Go back to Storage → Buckets
2. Click on **"attendance_proofs"**
3. Verify:
   - ✅ Bucket name is correct
   - ✅ "Public" badge is visible
   - ✅ Policy count shows "1 policy"

### Test Upload (Optional)
1. Click **"Upload File"** in the bucket
2. Select any image
3. Upload it
4. Click on the uploaded file
5. Click **"Get URL"**
6. Copy the URL
7. Paste in browser
8. Image should display (not download)

If image displays → ✅ Setup is correct!  
If image downloads → ❌ Bucket is not public

---

## 🚨 Common Mistakes

### Mistake 1: Bucket Not Public
**Symptom:** Upload fails with "permission denied"  
**Fix:** Edit bucket → Check "Public bucket" → Save

### Mistake 2: No Policy
**Symptom:** Upload fails with "policy violation"  
**Fix:** Create policy as described above

### Mistake 3: Wrong Policy Settings
**Symptom:** Upload works but image doesn't display  
**Fix:** Edit policy → Set USING and WITH CHECK to `true`

### Mistake 4: Wrong Bucket Name
**Symptom:** App says "bucket not found"  
**Fix:** Rename bucket to exactly `attendance_proofs`

### Mistake 5: Wrong Target Role
**Symptom:** Upload fails for students  
**Fix:** Edit policy → Set target role to `public`

---

## 📋 Quick Checklist

Before testing the app, verify:

- [ ] Bucket named exactly `attendance_proofs`
- [ ] Bucket is marked as "Public"
- [ ] Policy exists with name "Public Access"
- [ ] Policy allows all operations (SELECT, INSERT, UPDATE, DELETE)
- [ ] Policy target role is `public`
- [ ] Policy USING expression is `true`
- [ ] Policy WITH CHECK expression is `true`
- [ ] Test upload works
- [ ] Test URL displays image in browser

---

## 🔍 Troubleshooting

### How to Check if Setup is Correct

**Method 1: Via Dashboard**
1. Go to Storage → attendance_proofs
2. Look for "Public" badge next to bucket name
3. Click Policies tab
4. Should see 1 policy listed

**Method 2: Via Test Upload**
1. Upload a test image
2. Get public URL
3. Open URL in incognito browser
4. Image should display immediately

**Method 3: Via App**
1. Try to mark attendance
2. Take photo
3. Check Supabase logs for errors
4. If no errors → Setup is correct

### Error Messages

**"Bucket not found"**
- Bucket doesn't exist or wrong name
- Create bucket with exact name

**"Permission denied"**
- Bucket is not public OR no policy
- Make bucket public AND create policy

**"Policy violation"**
- Policy settings are wrong
- Edit policy → Set USING and WITH CHECK to `true`

**"Upload failed"**
- Multiple possible causes
- Check all settings above

---

## 📞 Need Help?

If you're stuck:

1. **Double-check** every setting above
2. **Delete** the bucket and start over
3. **Check** Supabase logs for specific errors
4. **Test** with a simple image upload first
5. **Verify** the policy is active (not disabled)

---

## 🎯 Final Verification Command

After setup, run this in Supabase SQL Editor to verify:

```sql
-- Check if bucket exists
SELECT * FROM storage.buckets WHERE name = 'attendance_proofs';

-- Should return 1 row with public = true
```

If query returns nothing → Bucket doesn't exist  
If public = false → Bucket is not public  
If public = true → ✅ Setup is correct!

---

## ✅ Setup Complete!

Once you see:
- ✅ Bucket exists
- ✅ Bucket is public
- ✅ Policy is active
- ✅ Test upload works

You're ready to test the attendance system!

---

**Remember:** This is a **ONE-TIME** setup. Once configured correctly, it works forever.
