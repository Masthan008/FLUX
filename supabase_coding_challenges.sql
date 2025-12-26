-- =====================================================
-- CODING CHALLENGES & SUBMISSIONS
-- Contest system for interview preparation
-- =====================================================

-- Create coding_challenges table
create table if not exists coding_challenges (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  description text not null,
  starter_code text, -- Pre-filled template for students
  expected_output text, -- For answer validation
  test_input text, -- Input for the test case
  points int default 50,
  difficulty text default 'easy', -- 'easy', 'medium', 'hard'
  language text default 'python', -- 'python', 'java', 'javascript'
  min_tier_required text default 'free',
  week_number int default 1, -- For weekly rotation
  created_at timestamp with time zone default now()
);

-- Add weekly/total points to students table
alter table students add column if not exists weekly_points int default 0;
alter table students add column if not exists total_points int default 0;

-- Create student_submissions table
create table if not exists student_submissions (
  id uuid default gen_random_uuid() primary key,
  student_id uuid references students(id) on delete cascade,
  challenge_id uuid references coding_challenges(id) on delete cascade,
  submitted_code text not null,
  output text,
  is_correct boolean default false,
  points_earned int default 0,
  submitted_at timestamp with time zone default now(),
  unique(student_id, challenge_id) -- One submission per challenge per student
);

-- Enable RLS
alter table coding_challenges enable row level security;
alter table student_submissions enable row level security;

-- Policies for challenges
create policy "Challenges are viewable by everyone"
  on coding_challenges for select
  using (true);

-- Policies for submissions
create policy "Users can view own submissions"
  on student_submissions for select
  using (true); -- Allow viewing all for leaderboard

create policy "Users can insert submissions"
  on student_submissions for insert
  with check (true);

create policy "Users can update own submissions"
  on student_submissions for update
  using (true);

-- Indexes
create index if not exists idx_challenges_difficulty on coding_challenges(difficulty);
create index if not exists idx_challenges_week on coding_challenges(week_number);
create index if not exists idx_submissions_student on student_submissions(student_id);
create index if not exists idx_submissions_challenge on student_submissions(challenge_id);

-- Insert sample challenges
insert into coding_challenges (title, description, starter_code, expected_output, test_input, points, difficulty, language, week_number) values
  (
    'Reverse a String',
    'Write a function that reverses a string without using built-in reverse methods.',
    'def reverse_string(s):\n    # Your code here\n    pass\n\nprint(reverse_string(input()))',
    'olleh',
    'hello',
    50,
    'easy',
    'python',
    1
  ),
  (
    'Find Maximum in Array',
    'Find the maximum number in a list without using max() function.',
    'def find_max(arr):\n    # Your code here\n    pass\n\nprint(find_max([3, 7, 2, 9, 1]))',
    '9',
    '[3, 7, 2, 9, 1]',
    50,
    'easy',
    'python',
    1
  ),
  (
    'FizzBuzz Classic',
    'Print numbers 1-20. For multiples of 3 print "Fizz", for 5 print "Buzz", for both print "FizzBuzz".',
    'def fizzbuzz():\n    # Your code here\n    pass\n\nfizzbuzz()',
    '1\n2\nFizz\n4\nBuzz\nFizz\n7\n8\nFizz\nBuzz\n11\nFizz\n13\n14\nFizzBuzz\n16\n17\nFizz\n19\nBuzz',
    '',
    100,
    'medium',
    'python',
    1
  ),
  (
    'Palindrome Checker',
    'Check if a string is a palindrome (reads same forwards and backwards).',
    'def is_palindrome(s):\n    # Your code here\n    pass\n\nprint(is_palindrome(input()))',
    'True',
    'racecar',
    75,
    'medium',
    'python',
    2
  ),
  (
    'Sum of Digits',
    'Calculate the sum of all digits in a number.',
    'def sum_digits(n):\n    # Your code here\n    pass\n\nprint(sum_digits(int(input())))',
    '15',
    '12345',
    50,
    'easy',
    'python',
    2
  );

-- Success message
select 'Coding challenges and submissions tables created successfully!' as status;
