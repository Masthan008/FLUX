# 🧪 Focus Forest Testing Guide

## ✅ Rain Sound Added!

The `rain.mp3` file has been added to `assets/sounds/` and is ready to use.

---

## 🎵 Testing Ambient Sounds

### Test Rain Sound:
```
1. Open Focus Forest
2. Select "Rain" from Sound dropdown
3. Tap "Plant Seed"
4. ✅ Rain sound should start playing and loop
5. Wait for session to complete
6. ✅ Rain sound should stop automatically
```

### Test Other Sounds:
The following sounds will default to Silence until you add the files:
- Fire (needs: `assets/sounds/fire.mp3`)
- Night (needs: `assets/sounds/night.mp3`)
- Library (needs: `assets/sounds/library.mp3`)

**Note:** App won't crash if files are missing - it just won't play sound.

---

## 🌲 Testing Tree Evolution

### Test 1: Short Session (Grass)
```
1. Select Duration: 15 min
2. Select Sound: Rain
3. Start session
4. Stay in app for 10 minutes
5. Leave app (go to home screen)
6. ✅ Tree should die
7. Return to app
8. ✅ Dead tree dialog should show
9. Check "My Forest"
10. ✅ Dead tree (brown) should appear in gallery
```

### Test 2: Medium Session (Flower)
```
1. Select Duration: 25 min
2. Select Sound: Rain
3. Start session
4. Stay in app for full 25 minutes
5. ✅ Tree should grow: Seed → Sprout → Tree
6. ✅ Success dialog should show
7. Check "My Forest"
8. ✅ Flower tree (light green) should appear
```

### Test 3: Long Session (Pine Tree)
```
1. Select Duration: 45 min
2. Complete full session
3. ✅ Pine tree (green) should appear in gallery
```

### Test 4: Very Long Session (Oak Forest)
```
1. Select Duration: 60 min
2. Complete full session
3. ✅ Oak forest (dark green) should appear in gallery
```

---

## 📊 Testing Forest History

### Test Stats:
```
1. Complete 3 sessions (25 min each)
2. Fail 1 session (leave app)
3. Open "My Forest"
4. ✅ Total Focus: 1.25 hrs (75 min / 60)
5. ✅ Trees Planted: 3
6. ✅ Trees Lost: 1
```

### Test Tree Details:
```
1. Open "My Forest"
2. Tap any tree card
3. ✅ Dialog should show:
   - Tree type (Grass/Flower/Pine/Oak)
   - Duration (minutes)
   - Date and time
   - Status (Completed/Failed)
```

### Test Empty State:
```
1. Clear app data (or fresh install)
2. Open "My Forest"
3. ✅ Should show "No trees yet" message
```

---

## 🎮 Testing Gamification

### Test Duration Selector:
```
□ Can select 15 minutes
□ Can select 25 minutes (default)
□ Can select 30 minutes
□ Can select 45 minutes
□ Can select 60 minutes
□ Timer updates to selected duration
□ Selector hidden when focusing
```

### Test Sound Selector:
```
□ Can select Silence
□ Can select Rain (plays sound)
□ Can select Fire (silent if file missing)
□ Can select Night (silent if file missing)
□ Can select Library (silent if file missing)
□ Selector hidden when focusing
```

### Test Tree Growth Animation:
```
□ Tree icon changes during session
□ Tree color changes during session
□ Shimmer effect plays when focusing
□ Warning message shows when focusing
```

---

## 🐛 Edge Cases to Test

### Test 1: App Minimized
```
1. Start focus session
2. Minimize app (don't close)
3. Wait 30 seconds
4. Return to app
5. ✅ Tree should be dead
6. ✅ Sound should stop
```

### Test 2: Phone Call
```
1. Start focus session with Rain sound
2. Receive phone call
3. Answer call
4. ✅ Rain sound should pause/stop
5. End call
6. ✅ Tree should be dead (app was paused)
```

### Test 3: Multiple Sessions
```
1. Complete 5 sessions in a row
2. ✅ Forest count should increase each time
3. ✅ All 5 trees should appear in gallery
4. ✅ Stats should be accurate
```

### Test 4: Sound File Missing
```
1. Select "Fire" (file doesn't exist)
2. Start session
3. ✅ App should not crash
4. ✅ Session should work normally (silent)
5. ✅ No error messages shown to user
```

---

## 📱 Device-Specific Tests

### Android:
```
□ Rain sound plays correctly
□ Sound loops without gaps
□ Sound stops when session ends
□ Tree dies when app minimized
□ History persists after app restart
□ No crashes or errors
```

### iOS (if applicable):
```
□ Rain sound plays correctly
□ Sound loops without gaps
□ Sound stops when session ends
□ Tree dies when app backgrounded
□ History persists after app restart
□ No crashes or errors
```

---

## 🎵 Adding More Sounds

### Where to Get Free Sounds:

1. **Freesound.org**
   - Search: "rain loop", "fireplace", "night ambiance"
   - Download as MP3
   - Rename to match expected names

2. **YouTube Audio Library**
   - Filter: Sound effects
   - Download and convert to MP3

3. **Zapsplat.com**
   - Free sound effects
   - No attribution required

### How to Add:

1. Download/create sound file
2. Convert to MP3 format
3. Rename to match expected name:
   - `fire.mp3`
   - `night.mp3`
   - `library.mp3`
4. Place in `assets/sounds/` folder
5. Run `flutter pub get`
6. Rebuild app
7. Test!

### Sound Requirements:

- **Format:** MP3
- **Length:** 30 seconds to 5 minutes (will loop)
- **Quality:** 128-192 kbps (good balance)
- **Volume:** Normalized (not too loud/quiet)
- **Seamless Loop:** Should loop without noticeable gap

---

## 🔊 Current Sound Status

```
✅ rain.mp3     - ADDED (working)
❌ fire.mp3     - MISSING (defaults to silence)
❌ night.mp3    - MISSING (defaults to silence)
❌ library.mp3  - MISSING (defaults to silence)
```

---

## 📋 Quick Test Checklist

### Basic Functionality:
```
□ Can start focus session
□ Timer counts down correctly
□ Tree grows during session
□ Rain sound plays and loops
□ Can complete session successfully
□ Success dialog shows
□ Tree saved to history
□ Forest count increases
```

### History Gallery:
```
□ Can open "My Forest"
□ Stats display correctly
□ Trees appear in grid
□ Can tap tree for details
□ Alive trees show green
□ Dead trees show brown/grey
```

### Gamification:
```
□ Different tree types appear
□ Colors match tree types
□ Duration selector works
□ Sound selector works
□ Motivation to study longer
```

---

## 🎯 Success Criteria

### ✅ Feature is Working When:
- Rain sound plays smoothly
- Tree evolution shows different types
- History saves all sessions
- Stats calculate correctly
- No crashes or errors
- UI is responsive
- Gamification is motivating

### ❌ Feature Needs Fix If:
- Sound doesn't play
- Sound doesn't loop
- Sound doesn't stop
- Tree doesn't die when leaving app
- History doesn't save
- Stats are incorrect
- App crashes

---

## 💡 Tips for Best Experience

### For Users:
1. **Use headphones** for better ambient sound experience
2. **Start with 25 minutes** (standard Pomodoro)
3. **Try different sounds** to find what helps you focus
4. **Review your forest** regularly for motivation
5. **Aim for Oak Forest** (60+ min sessions)

### For Testing:
1. **Test on real device** (not just emulator)
2. **Test with headphones** and speakers
3. **Test different durations** (15, 25, 45, 60 min)
4. **Test all sound options**
5. **Test failure scenarios** (leaving app)
6. **Check history after multiple sessions**

---

## 🚀 Next Steps

1. **Test Rain Sound** ✅ (file added)
2. **Add Fire Sound** (optional)
3. **Add Night Sound** (optional)
4. **Add Library Sound** (optional)
5. **Test on multiple devices**
6. **Gather user feedback**
7. **Iterate based on feedback**

---

## 📝 Known Limitations

1. **Sound Quality:** Depends on source file quality
2. **Loop Gaps:** Some MP3s may have small gaps when looping
3. **Volume Control:** Uses system volume (no in-app control yet)
4. **Background Play:** Stops when app is killed (by design)
5. **File Size:** More sounds = larger app size

---

## 🎉 Testing Complete When:

- [x] Rain sound plays correctly
- [ ] All tree types appear in history
- [ ] Stats calculate accurately
- [ ] No crashes during testing
- [ ] UI is smooth and responsive
- [ ] Users find it motivating
- [ ] Ready for production use

---

**Version:** 43.0  
**Date:** November 28, 2025  
**Status:** Ready for Testing

**Happy Testing! 🌲🎵**
