/*
  # Add UPDATE and DELETE policies for activity_logs

  1. Security Changes
    - Add policy allowing updates to activity_logs for same-day merge functionality
    - Add policy allowing deletes to activity_logs for reset functionality
  
  2. Purpose
    - UPDATE policy: Required for merging same-day log entries (accumulating steps, preserving workouts)
    - DELETE policy: Required for the reset leaderboard functionality
*/

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'activity_logs' 
    AND policyname = 'Anyone can update activity logs'
  ) THEN
    CREATE POLICY "Anyone can update activity logs"
      ON activity_logs
      FOR UPDATE
      TO public
      USING (true)
      WITH CHECK (true);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE tablename = 'activity_logs' 
    AND policyname = 'Anyone can delete activity logs'
  ) THEN
    CREATE POLICY "Anyone can delete activity logs"
      ON activity_logs
      FOR DELETE
      TO public
      USING (true);
  END IF;
END $$;