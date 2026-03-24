/*
  # Update activity_logs table schema

  1. Changes
    - Remove old columns: workout_completed, workout_type, steps_over_10k
    - Add new columns: gym (boolean), padel (boolean), steps (integer)
    - Add unique constraint on (name, log_date)
    - Add check constraint for valid names
    - Add indexes for performance

  2. Notes
    - This migration updates the table to match the new requirements
    - One row per person per day enforced by unique constraint
    - Both gym and padel can be true (counts as 2 workouts)
    - Steps stored as exact integer value
*/

-- Drop old columns if they exist
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'activity_logs' AND column_name = 'workout_completed'
  ) THEN
    ALTER TABLE activity_logs DROP COLUMN workout_completed;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'activity_logs' AND column_name = 'workout_type'
  ) THEN
    ALTER TABLE activity_logs DROP COLUMN workout_type;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'activity_logs' AND column_name = 'steps_over_10k'
  ) THEN
    ALTER TABLE activity_logs DROP COLUMN steps_over_10k;
  END IF;
END $$;

-- Add new columns if they don't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'activity_logs' AND column_name = 'gym'
  ) THEN
    ALTER TABLE activity_logs ADD COLUMN gym boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'activity_logs' AND column_name = 'padel'
  ) THEN
    ALTER TABLE activity_logs ADD COLUMN padel boolean DEFAULT false;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'activity_logs' AND column_name = 'steps'
  ) THEN
    ALTER TABLE activity_logs ADD COLUMN steps integer DEFAULT 0;
  END IF;
END $$;

-- Add unique constraint if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'unique_person_per_day'
  ) THEN
    ALTER TABLE activity_logs ADD CONSTRAINT unique_person_per_day UNIQUE (name, log_date);
  END IF;
END $$;

-- Add check constraint for valid names if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'valid_name'
  ) THEN
    ALTER TABLE activity_logs ADD CONSTRAINT valid_name CHECK (name IN ('Peter', 'Amjad', 'Ali', 'Osman', 'Abod', 'Yazan', 'Rashed', 'Jonny'));
  END IF;
END $$;

-- Create indexes if they don't exist
CREATE INDEX IF NOT EXISTS idx_activity_logs_name ON activity_logs(name);
CREATE INDEX IF NOT EXISTS idx_activity_logs_date ON activity_logs(log_date);
CREATE INDEX IF NOT EXISTS idx_activity_logs_name_date ON activity_logs(name, log_date);