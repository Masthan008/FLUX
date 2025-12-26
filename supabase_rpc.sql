-- Function to safely increment points for a user
-- This runs on the server side (Supabase) to prevent cheating
create or replace function increment_points(userid uuid, points int)
returns void as $$
begin
  -- Update lifetime score (for Leaderboard)
  update users 
  set total_points = total_points + points 
  where id = userid;

  -- Update weekly score (for News/Cron Job)
  update users 
  set weekly_points = weekly_points + points 
  where id = userid;
end;
$$ language plpgsql;
