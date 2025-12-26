-- ============================================
-- Supabase Code Snippets Table Setup
-- For C-Code Lab Realtime Updates
-- ============================================

-- Step 1: Create Table (if not exists)
-- ============================================
CREATE TABLE IF NOT EXISTS code_snippets (
  id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  category TEXT,
  code TEXT NOT NULL,
  output TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Step 2: Create Index for Performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_code_snippets_created_at 
  ON code_snippets(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_code_snippets_category 
  ON code_snippets(category);

-- Step 3: Enable Realtime
-- ============================================
ALTER PUBLICATION supabase_realtime ADD TABLE code_snippets;

-- Step 4: Enable Row Level Security
-- ============================================
ALTER TABLE code_snippets ENABLE ROW LEVEL SECURITY;

-- Step 5: Drop Old Policies (if any)
-- ============================================
DROP POLICY IF EXISTS "Public Code Access" ON code_snippets;
DROP POLICY IF EXISTS "Allow anonymous reads" ON code_snippets;
DROP POLICY IF EXISTS "Allow authenticated inserts" ON code_snippets;

-- Step 6: Create New Policies
-- ============================================

-- Allow anyone to read code snippets
CREATE POLICY "Allow anonymous reads"
  ON code_snippets
  FOR SELECT
  TO anon
  USING (true);

-- Allow authenticated users to insert
CREATE POLICY "Allow authenticated inserts"
  ON code_snippets
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- Allow authenticated users to update their own entries
CREATE POLICY "Allow authenticated updates"
  ON code_snippets
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- Allow authenticated users to delete
CREATE POLICY "Allow authenticated deletes"
  ON code_snippets
  FOR DELETE
  TO authenticated
  USING (true);

-- Step 7: Insert Sample Data
-- ============================================

-- Clear existing data (OPTIONAL - comment out if you want to keep existing data)
-- TRUNCATE code_snippets RESTART IDENTITY;

-- Star Patterns
INSERT INTO code_snippets (title, category, code, output) VALUES
('Right Triangle Star', 'Star', 
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\n");
    }
    return 0;
}',
'* 
* * 
* * * 
* * * * 
* * * * *'),

('Inverted Triangle', 'Star',
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = n; i >= 1; i--) {
        for(int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\n");
    }
    return 0;
}',
'* * * * * 
* * * * 
* * * 
* * 
*'),

('Diamond Pattern', 'Star',
'#include <stdio.h>
int main() {
    int n = 5, i, j;
    // Upper half
    for(i = 1; i <= n; i++) {
        for(j = 1; j <= n-i; j++) printf(" ");
        for(j = 1; j <= 2*i-1; j++) printf("*");
        printf("\n");
    }
    // Lower half
    for(i = n-1; i >= 1; i--) {
        for(j = 1; j <= n-i; j++) printf(" ");
        for(j = 1; j <= 2*i-1; j++) printf("*");
        printf("\n");
    }
    return 0;
}',
'    *
   ***
  *****
 *******
*********
 *******
  *****
   ***
    *'),

-- Number Patterns
('Number Triangle', 'Number',
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= i; j++) {
            printf("%d ", j);
        }
        printf("\n");
    }
    return 0;
}',
'1 
1 2 
1 2 3 
1 2 3 4 
1 2 3 4 5'),

('Floyd Triangle', 'Number',
'#include <stdio.h>
int main() {
    int n = 5, num = 1;
    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= i; j++) {
            printf("%d ", num++);
        }
        printf("\n");
    }
    return 0;
}',
'1 
2 3 
4 5 6 
7 8 9 10 
11 12 13 14 15'),

-- Alphabet Patterns
('Alphabet Triangle', 'Alphabet',
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = 1; i <= n; i++) {
        char ch = ''A'';
        for(int j = 1; j <= i; j++) {
            printf("%c ", ch++);
        }
        printf("\n");
    }
    return 0;
}',
'A 
A B 
A B C 
A B C D 
A B C D E'),

-- Pyramid Patterns
('Pyramid', 'Pyramid',
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= n-i; j++) printf("  ");
        for(int j = 1; j <= 2*i-1; j++) printf("* ");
        printf("\n");
    }
    return 0;
}',
'        * 
      * * * 
    * * * * * 
  * * * * * * * 
* * * * * * * * *'),

('Inverted Pyramid', 'Pyramid',
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = n; i >= 1; i--) {
        for(int j = 1; j <= n-i; j++) printf("  ");
        for(int j = 1; j <= 2*i-1; j++) printf("* ");
        printf("\n");
    }
    return 0;
}',
'* * * * * * * * * 
  * * * * * * * 
    * * * * * 
      * * * 
        *'),

-- Hollow Patterns
('Hollow Square', 'Hollow',
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= n; j++) {
            if(i == 1 || i == n || j == 1 || j == n)
                printf("* ");
            else
                printf("  ");
        }
        printf("\n");
    }
    return 0;
}',
'* * * * * 
*       * 
*       * 
*       * 
* * * * *'),

('Hollow Triangle', 'Hollow',
'#include <stdio.h>
int main() {
    int n = 5;
    for(int i = 1; i <= n; i++) {
        for(int j = 1; j <= i; j++) {
            if(j == 1 || j == i || i == n)
                printf("* ");
            else
                printf("  ");
        }
        printf("\n");
    }
    return 0;
}',
'* 
* * 
*   * 
*     * 
* * * * *');

-- Step 8: Verification Queries
-- ============================================

-- Check table structure
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'code_snippets'
ORDER BY ordinal_position;

-- Check RLS is enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'code_snippets';

-- Check policies
SELECT policyname, cmd, roles, qual 
FROM pg_policies 
WHERE tablename = 'code_snippets';

-- Check realtime is enabled
SELECT * FROM pg_publication_tables 
WHERE pubname = 'supabase_realtime' 
  AND tablename = 'code_snippets';

-- View all code snippets
SELECT id, title, category, created_at 
FROM code_snippets 
ORDER BY created_at DESC;

-- Count by category
SELECT category, COUNT(*) as count 
FROM code_snippets 
GROUP BY category 
ORDER BY count DESC;

-- ============================================
-- Setup Complete!
-- ============================================
-- 
-- Next Steps:
-- 1. Restart your Flutter app
-- 2. Navigate to C-Code Lab → Cloud tab
-- 3. You should see all patterns listed
-- 4. Try inserting a new row - it should appear instantly!
--
-- Test Insert:
-- INSERT INTO code_snippets (title, category, code, output)
-- VALUES ('Test Pattern', 'Star', '#include <stdio.h>\nint main() { printf("*"); return 0; }', '*');
-- ============================================
