# 🚀 Quick Start: Update 40.0 Features

## New Features at a Glance

### 1. 💬 Chat Message Deletion
**How to use:**
1. Open **Hub - Chatroom**
2. **Long-press** any message bubble
3. Confirm deletion in dialog
4. Message disappears for everyone

**Permissions:**
- ✅ Delete your own messages
- ✅ Teachers can delete any message
- ❌ Students cannot delete others' messages

---

### 2. 🟢 Online User Counter
**Where to see:**
- Open **Hub - Chatroom**
- Look at **AppBar subtitle**
- Shows: "🟢 5 Online" (live count)

**Setup Required:**
- Enable Presence in Supabase Dashboard
- See `SUPABASE_PRESENCE_SETUP.md` for instructions

---

### 3. 📊 Total Users Statistics
**Where to see:**
- Open **Drawer** → **About Us**
- Scroll to "Total NovaMind Users" card
- Shows live count from database

**Example:**
```
👥 Total NovaMind Users
   125
```

---

### 4. 🔔 Smart Notifications
**What changed:**
- News notifications limited to **once per 24 hours**
- **Red badge** on news bell icon shows unread count
- Badge updates in real-time

**How it works:**
1. First news notification shows immediately
2. Subsequent notifications blocked for 24 hours
3. Badge always shows current unread count
4. Click bell icon to view all news

---

## Testing Checklist

### Chat Features:
```
□ Long-press message shows delete dialog
□ Can delete own messages
□ Teachers can delete any message
□ Online count appears in AppBar
□ Count updates with multiple users
```

### Statistics:
```
□ About screen shows user count
□ Count loads correctly
□ No errors in console
```

### Notifications:
```
□ First news notification appears
□ Second notification within 24h is blocked
□ Badge shows on news icon
□ Badge count is accurate
```

---

## Common Issues & Fixes

### Issue: Online count shows 0
**Fix:** Enable Presence in Supabase
- Dashboard → Database → Replication → Enable Presence
- See `SUPABASE_PRESENCE_SETUP.md`

### Issue: Can't delete messages
**Fix:** Check permissions
- Verify you're logged in
- Check your role (student/teacher)
- Ensure message ID is valid

### Issue: User count shows 0
**Fix:** Check Supabase connection
- Verify `profiles` table exists
- Check internet connection
- Look for errors in console

### Issue: Badge not showing
**Fix:** Check news data
- Verify `news` table has data
- Check Supabase connection
- Restart app

---

## Quick Commands

### Test Online Presence:
```bash
# Open app on Device 1
flutter run

# Open app on Device 2 (or emulator)
flutter run -d <device-id>

# Both should show "2 Online" in chat
```

### Check User Count:
```sql
-- Run in Supabase SQL Editor
SELECT COUNT(*) FROM profiles;
```

### Reset Notification Throttle:
```dart
// In Dart DevTools or app code
Hive.box('user_prefs').delete('last_news_notify_time');
```

---

## File Locations

### Modified Files:
```
lib/screens/chat_screen.dart          - Chat features
lib/screens/about_screen.dart         - User statistics
lib/services/notification_service.dart - Notification throttle
lib/screens/home_screen.dart          - News badge
```

### Documentation:
```
UPDATE_40_COMPLETE.md           - Full implementation details
SUPABASE_PRESENCE_SETUP.md      - Presence setup guide
QUICK_START_UPDATE_40.md        - This file
version.md                      - Version history
```

---

## Next Steps

1. **Enable Presence** in Supabase (required for online count)
2. **Test all features** using the checklist above
3. **Build APK** and test on real devices
4. **Gather feedback** from users
5. **Monitor** Supabase usage and performance

---

## Support

### Documentation:
- `UPDATE_40_COMPLETE.md` - Detailed implementation
- `SUPABASE_PRESENCE_SETUP.md` - Presence configuration

### Troubleshooting:
- Check console for errors
- Verify Supabase connection
- Test with multiple devices
- Review permission settings

---

**Version:** 40.0  
**Date:** November 28, 2025  
**Status:** ✅ Ready to Use

**Enjoy your new community features! 🎉**
