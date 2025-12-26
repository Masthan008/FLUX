Due to the token limit and complexity, I'll create a comprehensive implementation guide for both features. Here's what needs to be implemented:

# Update 51: Book Upload System + Enhanced ChatHub

## 🎯 Overview
Adding two major features:
1. **Book Upload System** - Community book sharing with upload, download, likes
2. **Enhanced ChatHub** - Disappearing messages, reactions, polls, threads, and more

---

## 📚 PART 1: BOOK UPLOAD SYSTEM

### Features to Implement:

#### 1. **Book Upload**
- Upload PDF, DOCX, PPT files
- Add title, description, subject, semester
- Add tags for better searchability
- File size limit (e.g., 50MB)
- Progress indicator during upload

#### 2. **Book Library**
- Grid/List view of all books
- Search by title, subject, tags
- Filter by subject and semester
- Sort by date, downloads, likes

#### 3. **Book Details**
- View book information
- Download button
- Like/Unlike button
- Share button
- Report inappropriate content
- Delete (if uploader)

#### 4. **User Features**
- View own uploaded books
- Track downloads and likes
- Edit book details
- Delete own books

### Database Tables Created:
- `community_books` - Main books table
- `book_likes` - Track likes
- `book_downloads` - Track downloads
- `book_reports` - Report system

### Files Created:
1. ✅ `SUPABASE_BOOKS_UPLOAD_SETUP.sql` - Database setup
2. ✅ `lib/services/books_upload_service.dart` - Service layer
3. ⏳ `lib/modules/books/books_upload_screen.dart` - Upload UI
4. ⏳ `lib/modules/books/community_books_screen.dart` - Library UI
5. ⏳ `lib/modules/books/book_detail_screen.dart` - Detail view

---

## 💬 PART 2: ENHANCED CHATHUB

### New Features to Implement:

#### 1. **Disappearing Messages** ⏰
- Set message expiry time (1 hour, 24 hours, 7 days)
- Auto-delete after expiry
- Visual countdown timer
- Warning before sending

#### 2. **Message Reactions** 😊
- Add emoji reactions to messages
- Multiple reactions per message
- See who reacted
- Quick reaction picker

#### 3. **Polls** 📊
- Create polls in chat
- Multiple choice options
- Vote and see results
- Poll expiry time
- Anonymous voting option

#### 4. **Threaded Replies** 💬
- Reply to specific messages
- View thread conversations
- Thread indicators
- Navigate to parent message

#### 5. **Pinned Messages** 📌
- Pin important messages
- View all pinned messages
- Only teachers can pin
- Unpin messages

#### 6. **Message Bookmarks** 🔖
- Bookmark important messages
- View saved messages
- Quick access to bookmarks

#### 7. **Typing Indicators** ⌨️
- Show who's typing
- Real-time updates
- Auto-clear after 10 seconds

#### 8. **Read Receipts** ✓✓
- Track who read messages
- Show read count
- Privacy settings

#### 9. **Media Messages** 📷
- Send images
- Send files
- Preview media
- Download media

#### 10. **Announcements** 📢
- Teacher-only announcements
- Highlighted in chat
- Push notifications
- Cannot be deleted by students

### Database Enhancements:
- Added columns to `chat_messages`:
  - `expires_at` - For disappearing messages
  - `is_pinned` - Pin status
  - `message_type` - text/image/file/poll
  - `media_url` - Media file URL
  - `read_by` - Array of users who read

- New tables:
  - `message_reactions` - Emoji reactions
  - `chat_polls` - Poll data
  - `poll_votes` - Poll voting
  - `message_threads` - Threaded replies
  - `user_typing` - Typing indicators
  - `message_bookmarks` - Saved messages

### Files Created:
1. ✅ `SUPABASE_CHATHUB_ENHANCED_SETUP.sql` - Database setup
2. ⏳ Enhanced `lib/screens/chat_screen.dart` - Main chat UI
3. ⏳ `lib/services/chat_enhanced_service.dart` - Enhanced service
4. ⏳ `lib/widgets/message_reactions_widget.dart` - Reactions UI
5. ⏳ `lib/widgets/poll_widget.dart` - Poll UI
6. ⏳ `lib/widgets/thread_view_widget.dart` - Thread UI

---

## 🎨 UI/UX Improvements

### Book Upload Screen:
```
┌─────────────────────────────────┐
│  Upload Book                    │
├─────────────────────────────────┤
│  📄 Select File                 │
│  [Choose PDF/DOCX/PPT]          │
│                                 │
│  Title: ___________________     │
│  Description: ______________    │
│  Subject: [Dropdown]            │
│  Semester: [Dropdown]           │
│  Tags: [tag1] [tag2] [+]        │
│                                 │
│  [Upload Book]                  │
└─────────────────────────────────┘
```

### Enhanced Chat Features:
```
┌─────────────────────────────────┐
│  Community Chat          [📌]   │
├─────────────────────────────────┤
│  📌 Pinned: "Exam on Monday"    │
├─────────────────────────────────┤
│  John: Hello everyone!          │
│  😊2 ❤️1 [Reply] [⋮]           │
│  └─ Mary: Hi John!              │
│                                 │
│  📊 Poll: Favorite subject?     │
│  ○ Math (5 votes)               │
│  ○ Physics (3 votes)            │
│  [Vote]                         │
│                                 │
│  ⏰ This message expires in 1h  │
│  Teacher: Important notice...   │
│                                 │
│  💬 Alice is typing...          │
├─────────────────────────────────┤
│  [Type message...] [⏰] [📊]    │
└─────────────────────────────────┘
```

---

## 📊 Implementation Priority

### Phase 1 (High Priority):
1. ✅ Database setup (SQL files created)
2. ✅ Book upload service
3. ⏳ Book upload UI
4. ⏳ Community books library
5. ⏳ Disappearing messages
6. ⏳ Message reactions

### Phase 2 (Medium Priority):
7. ⏳ Polls in chat
8. ⏳ Pinned messages
9. ⏳ Threaded replies
10. ⏳ Typing indicators

### Phase 3 (Nice to Have):
11. ⏳ Message bookmarks
12. ⏳ Read receipts
13. ⏳ Media messages
14. ⏳ Announcements

---

## 🔧 Technical Requirements

### Dependencies Needed:
```yaml
dependencies:
  file_picker: ^6.0.0  # For file selection
  path_provider: ^2.1.0  # For file paths
  open_file: ^3.3.2  # For opening files
  share_plus: ^7.2.0  # For sharing
  cached_network_image: ^3.3.0  # For image caching
  emoji_picker_flutter: ^1.6.0  # For emoji picker
```

### Storage Setup:
1. Create `community-books` bucket in Supabase Storage
2. Set public access or authenticated access
3. Configure file size limits
4. Set allowed file types (PDF, DOCX, PPT)

### Permissions:
- Storage: Read/Write for authenticated users
- Database: RLS policies configured
- File upload: Max 50MB per file

---

## 🎯 User Flows

### Book Upload Flow:
1. User taps "Upload Book" button
2. Select file from device
3. Fill in book details (title, description, etc.)
4. Add tags (optional)
5. Tap "Upload" button
6. Show progress indicator
7. Success message + navigate to book detail

### Disappearing Message Flow:
1. User types message
2. Tap timer icon
3. Select expiry time (1h, 24h, 7d, custom)
4. Send message with timer indicator
5. Message shows countdown
6. Auto-deletes after expiry

### Poll Creation Flow:
1. User taps poll icon
2. Enter question
3. Add options (2-10)
4. Set expiry (optional)
5. Post poll
6. Users can vote
7. See live results

---

## 📱 UI Components Needed

### Book Upload:
- File picker button
- Form fields (title, description, etc.)
- Tag input with chips
- Progress bar
- Success/Error dialogs

### Enhanced Chat:
- Reaction picker (emoji selector)
- Poll creator dialog
- Thread view bottom sheet
- Pinned messages banner
- Typing indicator widget
- Disappearing message timer
- Bookmark button
- Media preview

---

## 🚀 Next Steps

### To Complete Implementation:

1. **Add dependencies** to pubspec.yaml
2. **Run SQL scripts** in Supabase
3. **Create storage bucket** in Supabase
4. **Implement UI screens**:
   - Book upload screen
   - Community books library
   - Enhanced chat features
5. **Test all features**
6. **Add to drawer menu**

### Quick Implementation Guide:

```dart
// 1. Add to drawer
ListTile(
  leading: Icon(Icons.library_books),
  title: Text('Community Books'),
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CommunityBooksScreen(),
    ),
  ),
),

// 2. Use service
final booksService = BooksUploadService();
await booksService.addBook(
  title: 'My Book',
  description: 'Description',
  // ... other params
);

// 3. Stream books
StreamBuilder(
  stream: booksService.getBooksStream(),
  builder: (context, snapshot) {
    // Build UI
  },
)
```

---

## ✅ What's Ready

1. ✅ Database schema for books
2. ✅ Database schema for enhanced chat
3. ✅ Book upload service
4. ✅ SQL functions for auto-deletion
5. ✅ RLS policies
6. ✅ Indexes for performance

## ⏳ What's Needed

1. ⏳ UI screens implementation
2. ⏳ File picker integration
3. ⏳ Enhanced chat UI
4. ⏳ Reaction picker
5. ⏳ Poll creator
6. ⏳ Thread view
7. ⏳ Testing

---

## 📝 Notes

- Book uploads require Supabase Storage setup
- Disappearing messages need cron job or manual cleanup
- Consider file size limits (50MB recommended)
- Implement virus scanning for uploads (optional)
- Add moderation for reported content
- Consider bandwidth costs for file storage
- Implement caching for better performance

---

**Status**: Database and Service Layer Complete ✅
**Next**: UI Implementation ⏳
**Version**: 1.0.51
**Date**: December 2025

Would you like me to implement the UI screens next?
