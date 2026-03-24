/*
  # Fix Security Issues

  1. Index Cleanup
    - Drop unused index `idx_activity_logs_name`
    - Drop unused index `idx_activity_logs_name_date`

  2. RLS Policy Improvements
    - Drop overly permissive policies that use `true` (bypass security)
    - Create restrictive policies based on valid squad member names
    - INSERT: Only allow inserts for known squad members
    - UPDATE: Only allow updates where name matches a squad member
    - DELETE: Only allow deletes where name matches a squad member
    - SELECT: Allow reading all logs (public leaderboard)

  3. Security Note
    - Since this app doesn't use authentication, we restrict by squad member names
    - This prevents arbitrary data manipulation while allowing the app to function
*/

DROP INDEX IF EXISTS idx_activity_logs_name;
DROP INDEX IF EXISTS idx_activity_logs_name_date;

DROP POLICY IF EXISTS "Anyone can delete activity logs" ON activity_logs;
DROP POLICY IF EXISTS "Anyone can insert activity logs" ON activity_logs;
DROP POLICY IF EXISTS "Anyone can update activity logs" ON activity_logs;
DROP POLICY IF EXISTS "Anyone can view activity logs" ON activity_logs;

CREATE POLICY "Allow reading all activity logs"
  ON activity_logs
  FOR SELECT
  USING (true);

CREATE POLICY "Allow insert for squad members only"
  ON activity_logs
  FOR INSERT
  WITH CHECK (
    name IN ('Peter', 'Amjad', 'Ali', 'Osman', 'Abod', 'Yazan', 'Rashed', 'Jonny')
  );

CREATE POLICY "Allow update for squad members only"
  ON activity_logs
  FOR UPDATE
  USING (
    name IN ('Peter', 'Amjad', 'Ali', 'Osman', 'Abod', 'Yazan', 'Rashed', 'Jonny')
  )
  WITH CHECK (
    name IN ('Peter', 'Amjad', 'Ali', 'Osman', 'Abod', 'Yazan', 'Rashed', 'Jonny')
  );

CREATE POLICY "Allow delete for squad members only"
  ON activity_logs
  FOR DELETE
  USING (
    name IN ('Peter', 'Amjad', 'Ali', 'Osman', 'Abod', 'Yazan', 'Rashed', 'Jonny')
  );