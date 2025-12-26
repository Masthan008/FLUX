# Critical Fixes Needed

## Issues Identified:

### 1. Books/Notes Not User-Specific ❌
**Problem:** All users see same books/notes
**Solution:** Use user-specific Hive keys

**Changes needed in `books_notes_screen.dart`:**
```dart
// Add at class level
late String _currentUserId;

// In initState
void _loadCurrentUser() {
  final box = Hive.box('user_prefs');
  _currentUserId = box.get('user_id', defaultValue: 'default_user');
}

// Replace all instances of:
box.get('books', defaultValue: [])
// With:
box.get('books_$_currentUserId', defaultValue: [])

// Replace all instances of:
box.put('books', books)
// With:
box.put('books_$_currentUserId', books)

// Same for notes:
box.get('notes', defaultValue: [])
// With:
box.get('notes_$_currentUserId', defaultValue: [])
```

### 2. Duplicate User Registration ❌
**Problem:** Same user can register multiple times
**Solution:** Check if user exists before registration

**Changes needed in `auth_screen.dart`:**
```dart
Future<void> _register() async {
  if (_formKey.currentState!.validate()) {
    final box = Hive.box('user_prefs');
    final userId = _idController.text;
    
    // Check if user already exists
    final existingUserId = box.get('registered_user_$userId');
    if (existingUserId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This ID is already registered! Please login.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    // Mark user as registered
    await box.put('registered_user_$userId', true);
    await box.put('user_name', _nameController.text);
    await box.put('user_id', userId);
    // ... rest of registration
  }
}
```

### 3. Green Snackbar ✅
**Status:** Already fixed with backgroundColor: Colors.green

### 4. Missing Features ❌

#### A. C Programs Not Added
**Files to update:** `lib/modules/coding/program_data.dart`

Add these programs:
1. Factorial (recursion)
2. Fibonacci series  
3. Prime number check
4. Armstrong number
5. Palindrome check
6. Array sorting
7. Matrix operations
8. String reverse
9. GCD/LCM
10. Binary search

#### B. Calculator Features Not Added
**Files to update:** `lib/modules/calculator/calculator_screen.dart`

Add these tabs:
1. Percentage Calculator
2. Discount Calculator
3. Tip Calculator

#### C. Calendar Features Not Added
**Status:** Calendar already has reminders with sound - working

## Priority Order:

### HIGH PRIORITY (Fix Now):
1. ✅ User-specific books/notes
2. ✅ Duplicate user check

### MEDIUM PRIORITY:
3. ⏳ Add C programs
4. ⏳ Add calculator tabs

### LOW PRIORITY:
5. ⏳ Additional alarm features

## Quick Fix Implementation:

### Step 1: Fix Books/Notes User Isolation
Replace in `_BooksTab` class:
```dart
final books = List<Map<String, dynamic>>.from(
  box.get('books_${widget.currentUserId}', defaultValue: [])
);
```

### Step 2: Fix Duplicate Registration
Add check in auth_screen before registration

### Step 3: Test
1. Register user A
2. Add book
3. Logout
4. Register user B  
5. Check books page (should be empty)
6. Try to register user A again (should show error)

## Implementation Status:

- [ ] Books/Notes user-specific
- [ ] Duplicate user check
- [ ] C programs added
- [ ] Calculator tabs added
- [ ] All tested

## Notes:

The main issue is that books/notes are stored globally instead of per-user. This is a critical data isolation issue that needs immediate fixing.
