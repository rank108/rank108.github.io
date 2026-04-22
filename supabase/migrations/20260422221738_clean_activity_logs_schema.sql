/*
  # Clean activity_logs table to final schema

  This migration removes deprecated legacy columns that are no longer used
  by the frontend or leaderboard logic. All legacy data has been verified
  as fully migrated into the `workouts` jsonb array.

  1. Removed Columns
    - `gym` (boolean) - old single-workout flag, replaced by `workouts` array
    - `padel` (boolean) - old single-workout flag, replaced by `workouts` array
    - `gym_count` (integer) - old counter, replaced by `workouts` array length
    - `padel_count` (integer) - old counter, replaced by `workouts` array length
    - `updated_at` (timestamptz) - redundant; `created_at` tracks submission time

  2. Final Active Schema
    - `id` (uuid, primary key)
    - `name` (text, check constraint for squad members)
    - `log_date` (date) - the date the user is logging FOR
    - `created_at` (timestamptz) - when the log was actually submitted
    - `workouts` (jsonb) - array of workout names e.g. ["Gym", "Padel"]
    - `steps` (integer) - total steps count

  3. Important Notes
    - All 93 existing rows were verified: every row with gym_count or
      padel_count > 0 already has matching entries in the workouts array
    - No data is lost by this migration
    - `created_at` remains the real submission timestamp (not the log_date)
    - `log_date` is the user-chosen date from the form
*/

ALTER TABLE activity_logs DROP COLUMN IF EXISTS gym;
ALTER TABLE activity_logs DROP COLUMN IF EXISTS padel;
ALTER TABLE activity_logs DROP COLUMN IF EXISTS gym_count;
ALTER TABLE activity_logs DROP COLUMN IF EXISTS padel_count;
ALTER TABLE activity_logs DROP COLUMN IF EXISTS updated_at;
