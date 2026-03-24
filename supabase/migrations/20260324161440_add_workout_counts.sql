/*
  # Add workout count columns to activity_logs

  1. Schema Changes
    - Add `gym_count` (integer, default 0) - tracks number of gym workouts per day
    - Add `padel_count` (integer, default 0) - tracks number of padel workouts per day

  2. Data Migration
    - Convert existing boolean gym=true to gym_count=1
    - Convert existing boolean padel=true to padel_count=1
    - Boolean false values become count=0 (handled by default)

  3. Purpose
    - Allows tracking multiple workouts of the same type on the same day
    - Example: 2 padel sessions = padel_count=2 instead of just padel=true
*/

ALTER TABLE activity_logs 
ADD COLUMN IF NOT EXISTS gym_count integer DEFAULT 0;

ALTER TABLE activity_logs 
ADD COLUMN IF NOT EXISTS padel_count integer DEFAULT 0;

UPDATE activity_logs 
SET gym_count = CASE WHEN gym = true THEN 1 ELSE 0 END
WHERE gym_count = 0 OR gym_count IS NULL;

UPDATE activity_logs 
SET padel_count = CASE WHEN padel = true THEN 1 ELSE 0 END
WHERE padel_count = 0 OR padel_count IS NULL;