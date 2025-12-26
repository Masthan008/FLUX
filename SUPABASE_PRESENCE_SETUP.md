# 🟢 Supabase Presence Setup Guide

## Overview
This guide will help you enable Supabase Realtime Presence for the "Online Users" feature in the Chat screen.

---

## What is Presence?

Presence allows you to track which users are currently active in your app in real-time. It's perfect for:
- Showing "X users online" counters
- Displaying active user lists
- Building collaborative features
- Real-time status indicators

---

## Step-by-Step Setup

### 1. Access Supabase Dashboard

1. Go to [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Sign in to your account
3. Select your NovaMind project

### 2. Navigate to Replication Settings

1. In the left sidebar, click **"Database"**
2. Click on **"Replication"** tab
3. You should see a list of publications

### 3. Enable Presence

1. Find the publication named **"supabase_realtime"**
2. Look for the **"Presence"** toggle switch
3. Click to **enable** it (should turn green/blue)
4. Click **"Save"** or **"Apply"** if prompted

**Visual Guide:**
```
Database → Replication → supabase_realtime
                              ↓
                    [✓] Presence (ENABLED)
```

### 4. Verify Configuration

After enabling, you should see:
- ✅ Presence: Enabled
- Status: Active

---

## Alternative Method (SQL)

If you prefer using SQL, you can enable presence with this command:

```sql
-- Enable presence for the realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE realtime.presence;
```

Run this in the **SQL Editor** section of your Supabase dashboard.

---

## Testing the Feature

### In the App:

1. **Open the Chat Screen** (Hub - Chatroom)
2. Look at the **AppBar subtitle**
3. You should see: **"🟢 1 Online"** (or more if others are online)

### Testing with Multiple Users:

1. Open the app on **Device 1**
2. Navigate to Chat screen
3. Note the count (e.g., "1 Online")
4. Open the app on **Device 2** (or emulator)
5. Navigate to Chat screen on Device 2
6. **Both devices** should now show "2 Online"
7. Close the app on Device 1
8. After ~30 seconds, Device 2 should show "1 Online"

---

## Troubleshooting

### Issue: Online count always shows 0

**Possible Causes:**
1. Presence not enabled in Supabase
2. Realtime not configured properly
3. Network connection issues

**Solutions:**
1. Double-check Presence is enabled (see Step 3)
2. Verify Realtime is enabled for your project:
   - Go to **Settings** → **API**
   - Check "Realtime" is enabled
3. Check your internet connection
4. Restart the app

### Issue: Count doesn't update when users leave

**Explanation:** This is normal behavior. Supabase waits ~30 seconds before removing a user from presence to handle temporary disconnections.

**Expected Behavior:**
- User joins → Count updates immediately
- User leaves → Count updates after 30s timeout

### Issue: Error in console about presence

**Check:**
1. Supabase URL and API key are correct in `main.dart`
2. You're using Supabase Flutter SDK version 2.0+
3. Internet connection is stable

---

## How It Works (Technical)

### 1. Channel Creation
```dart
final channel = Supabase.instance.client.channel('online_users');
```
Creates a Realtime channel named "online_users"

### 2. Presence Tracking
```dart
await channel.track({'user': _currentUser});
```
Registers the current user in the presence state

### 3. Listening for Changes
```dart
channel.onPresenceSync((payload) {
  setState(() {
    _onlineCount = channel.presenceState().length;
  });
});
```
Updates the UI whenever presence state changes

### 4. Automatic Cleanup
When the user closes the app or loses connection, Supabase automatically removes them from presence after a timeout period.

---

## Best Practices

### 1. Channel Naming
- Use descriptive names: `online_users`, `chat_room_1`, etc.
- Keep names consistent across your app
- Avoid special characters

### 2. Presence Data
- Keep presence data minimal (just user ID/name)
- Don't store sensitive information
- Use for ephemeral state only

### 3. Performance
- Presence is lightweight (~1KB per user)
- Suitable for 100s of concurrent users
- For 1000s+ users, consider pagination

### 4. Privacy
- Only track users who are actively using the feature
- Provide opt-out options if needed
- Don't expose personal information

---

## Advanced Features

### Show Who's Online (Not Just Count)

```dart
channel.onPresenceSync((payload) {
  final presenceState = channel.presenceState();
  final onlineUsers = presenceState.values
      .expand((presence) => presence)
      .map((p) => p['user'] as String)
      .toList();
  
  setState(() {
    _onlineUsers = onlineUsers;
  });
});
```

### User Status (Active, Away, Busy)

```dart
await channel.track({
  'user': _currentUser,
  'status': 'active', // or 'away', 'busy'
  'last_seen': DateTime.now().toIso8601String(),
});
```

### Typing Indicators

```dart
// When user starts typing
await channel.track({
  'user': _currentUser,
  'typing': true,
});

// When user stops typing
await channel.track({
  'user': _currentUser,
  'typing': false,
});
```

---

## Cost & Limits

### Free Tier:
- ✅ Unlimited presence tracking
- ✅ Up to 200 concurrent connections
- ✅ 2GB bandwidth per month

### Pro Tier ($25/month):
- ✅ Unlimited concurrent connections
- ✅ 50GB bandwidth per month
- ✅ Priority support

**For NovaMind:** Free tier is sufficient for most college use cases (200 concurrent users).

---

## Security Considerations

### Row Level Security (RLS)
Presence doesn't use database tables, so RLS doesn't apply. However:

1. **Channel Access:** Anyone with your Supabase URL can join channels
2. **Mitigation:** Use authenticated channels (requires user login)
3. **Best Practice:** Validate user identity before tracking

### Authenticated Presence

```dart
// Only track if user is logged in
final user = Supabase.instance.client.auth.currentUser;
if (user != null) {
  await channel.track({'user': user.email});
}
```

---

## Resources

### Official Documentation:
- [Supabase Presence Docs](https://supabase.com/docs/guides/realtime/presence)
- [Flutter Realtime Guide](https://supabase.com/docs/reference/dart/subscribe)

### Community:
- [Supabase Discord](https://discord.supabase.com)
- [GitHub Issues](https://github.com/supabase/supabase-flutter/issues)

---

## Summary

✅ **Enable Presence** in Supabase Dashboard  
✅ **Test** with multiple devices  
✅ **Monitor** online count in Chat screen  
✅ **Troubleshoot** using this guide  

**Your chat now has live presence tracking! 🎉**

---

**Last Updated:** November 28, 2025  
**Version:** 40.0
