# 🗄️ Supabase Database Setup for NovaMind v1.0

## Required Tables

### 1. **code_snippets** (Cloud Code Repository)

This table stores C programming code that appears dynamically in the app.

**Columns:**
- `id` - int8 (Primary Key, Auto-increment)
- `title` - text (e.g., "Fibonacci Series")
- `code` - text (The C source code)
- `output` - text (Expected console output)
- `category` - text (e.g., "Pattern", "Basic", "Pointer", "Loop")
- `created_at` - timestamptz (Auto-generated)

**SQL to Create:**
```sql
CREATE TABLE code_snippets (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  code TEXT NOT NULL,
  output TEXT,
  category TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE code_snippets;
```

**Row Level Security (RLS):**
```sql
-- Enable RLS
ALTER TABLE code_snippets ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read
CREATE POLICY "Allow public read access" ON code_snippets
  FOR SELECT USING (true);

-- Only authenticated users can insert (optional)
CREATE POLICY "Allow authenticated insert" ON code_snippets
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
```

**Sample Data:**
```sql
INSERT INTO code_snippets (title, code, output, category) VALUES
('Hello World', '#include<stdio.h>
int main() {
    printf("Hello, World!");
    return 0;
}', 'Hello, World!', 'Basic'),

('Star Pattern', '#include<stdio.h>
int main() {
    int i, j;
    for(i=1; i<=5; i++) {
        for(j=1; j<=i; j++) {
            printf("* ");
        }
        printf("\n");
    }
    return 0;
}', '* 
* * 
* * * 
* * * * 
* * * * *', 'Pattern'),

('Fibonacci Series', '#include<stdio.h>
int main() {
    int n=10, t1=0, t2=1, nextTerm;
    printf("Fibonacci Series: %d, %d, ", t1, t2);
    for(int i=3; i<=n; i++) {
        nextTerm = t1 + t2;
        printf("%d, ", nextTerm);
        t1 = t2;
        t2 = nextTerm;
    }
    return 0;
}', 'Fibonacci Series: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34', 'Basic');
```

---

### 2. **chat_messages** (Hub Chatroom)

Real-time messaging for students.

**Columns:**
- `id` - int8 (Primary Key, Auto-increment)
- `sender` - text (Student name)
- `message` - text (Message content)
- `created_at` - timestamptz (Auto-generated)

**SQL to Create:**
```sql
CREATE TABLE chat_messages (
  id BIGSERIAL PRIMARY KEY,
  sender TEXT NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE chat_messages;
```

**Row Level Security (RLS):**
```sql
-- Enable RLS
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read and insert
CREATE POLICY "Allow public read access" ON chat_messages
  FOR SELECT USING (true);

CREATE POLICY "Allow public insert access" ON chat_messages
  FOR INSERT WITH CHECK (true);
```

---

## 🚀 Quick Setup Steps

1. **Go to Supabase Dashboard** → Your Project
2. **Table Editor** → Click "New Table"
3. **Copy-paste the SQL** from above into SQL Editor
4. **Enable Realtime** for both tables:
   - Go to Database → Replication
   - Enable realtime for `code_snippets` and `chat_messages`
5. **Test Connection** in the app

---

## 📱 How to Add Code from Dashboard

1. Open **Supabase Dashboard** → `code_snippets` table
2. Click **Insert Row**
3. Fill in:
   - **title**: "Prime Number Check"
   - **code**: (Paste your C code)
   - **output**: (Expected output)
   - **category**: "Basic"
4. Click **Save**
5. **Open the app** → Code Lab → Cloud tab
6. **Your code appears instantly!** ✨

---

## 🔐 Teacher PIN Configuration (Optional)

To change the teacher PIN from "1234":

**Option 1: Hardcoded (Current)**
- Edit `lib/screens/auth_screen.dart`
- Change line: `if (pinController.text == '1234')`

**Option 2: Supabase Config Table**
```sql
CREATE TABLE app_config (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

INSERT INTO app_config (key, value) VALUES ('teacher_pin', '1234');
```

Then fetch it in the app:
```dart
final response = await Supabase.instance.client
  .from('app_config')
  .select('value')
  .eq('key', 'teacher_pin')
  .single();
final pin = response['value'];
```

---

## ✅ Verification Checklist

- [ ] `code_snippets` table created
- [ ] `chat_messages` table created
- [ ] Realtime enabled for both tables
- [ ] RLS policies configured
- [ ] Sample data inserted
- [ ] App connects successfully
- [ ] Cloud tab shows programs
- [ ] Chat messages send/receive

---

## 🎉 Benefits

**Before:** Editing JSON files in Android Studio for every new program  
**After:** Just paste code in Supabase Dashboard → Appears in app instantly!

**No rebuilding. No crashes. Pure magic.** ✨
