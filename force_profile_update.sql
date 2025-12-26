-- ============================================
-- NUCLEAR OPTION: Force Profile Update Function
-- ============================================
-- This function bypasses ALL RLS (Row Level Security) policies
-- and forces the database to update student profile data.
-- 
-- Usage: Run this in Supabase SQL Editor
-- ============================================

-- Create a function that bypasses all security checks to force-save data
create or replace function force_update_profile(
  p_regd_no text, 
  p_mobile text, 
  p_email text
)
returns void as $$
begin
  update students
  set 
    mobile_no = p_mobile,
    email_address = p_email
  where regd_no = p_regd_no; -- Finds the student by Regd No and updates them
end;
$$ language plpgsql security definer; -- 'security definer' gives it Root Admin power

-- Grant execute permission to authenticated users
grant execute on function force_update_profile(text, text, text) to authenticated;

-- Verification: Test the function (optional)
-- SELECT force_update_profile('YOUR_REGD_NO', '1234567890', 'test@example.com');
