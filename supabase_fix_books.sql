-- Fix Book Tiers
-- Update min_tier_required based on existing is_premium flag
UPDATE books 
SET min_tier_required = 'pro' 
WHERE is_premium = true AND (min_tier_required IS NULL OR min_tier_required = 'free');

UPDATE books 
SET min_tier_required = 'free' 
WHERE is_premium = false AND min_tier_required IS NULL;

-- Make sure default is free
ALTER TABLE books 
ALTER COLUMN min_tier_required SET DEFAULT 'free';

-- Grant permissions if needed
GRANT ALL ON books TO authenticated;
GRANT ALL ON books TO anon;
GRANT ALL ON books TO service_role;
