----------------------------
-- Scaling numerical data --
----------------------------
-- The script is safe to run multiple times over the same data and can be used to revert changes in the new columns or to update the new values.

-- Skipped for scaling due to being categorical: ParentalInvolvement, AccessToResources, AccessToResources, MotivationLevel, InternetAccess, FamilyIncome, TeacherQuality, SchoolType, PeerInfluence, LearningDisabilities, ParentalEducationLevel, DistanceFromHome, Gender.

-- Yes this is human written, yes this is how I talk.

-- HoursStudied is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS HoursStudiedMinMax;
WITH MinMaxScaling AS (
    SELECT
        RecordId,
       (HoursStudied - MIN(HoursStudied) OVER ())::numeric / 
       (MAX(HoursStudied) OVER () - MIN(HoursStudied) OVER ()) AS HoursStudiedMinMax
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.HoursStudiedMinMax = tmp.HoursStudiedMinMax
WHERE spf.RecordId = MinMaxScaling.RecordId;

-- Attendance is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, scaling to [0.0 - 1.0] with min-max.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS AttendanceMinMax;
UPDATE StudentPerformanceFactors
SET Attendance = Attendance / 100.0
WHERE 1 > (SELECT AVG(Attendance) FROM StudentPerformanceFactors);
WITH MinMaxScaling AS (
    SELECT
        RecordId,
       (Attendance - MIN(Attendance) OVER ())::numeric / 
       (MAX(Attendance) OVER () - MIN(Attendance) OVER ()) AS AttendanceMinMax
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.AttendanceMinMax = tmp.AttendanceMinMax
WHERE spf.RecordId = MinMaxScaling.RecordId;

-- SleepHours is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS SleepHoursMinMax;
WITH MinMaxScaling AS (
    SELECT
        RecordId,
       (SleepHours - MIN(SleepHours) OVER ())::numeric / 
       (MAX(SleepHours) OVER () - MIN(SleepHours) OVER ()) AS SleepHoursMinMax
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.SleepHoursMinMax = tmp.SleepHoursMinMax
WHERE spf.RecordId = MinMaxScaling.RecordId;

-- PreviousScores is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, scaling to [0.0 - 1.0] with min-max.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PreviousScoresMinMax;
UPDATE StudentPerformanceFactors
SET PreviousScores = PreviousScores / 100.0
WHERE 1 > (SELECT AVG(PreviousScores) FROM StudentPerformanceFactors);
WITH MinMaxScaling AS (
    SELECT
        RecordId,
       (PreviousScores - MIN(PreviousScores) OVER ())::numeric / 
       (MAX(PreviousScores) OVER () - MIN(PreviousScores) OVER ()) AS PreviousScoresMinMax
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.PreviousScoresMinMax = tmp.PreviousScoresMinMax
WHERE spf.RecordId = MinMaxScaling.RecordId;

-- TutoringSessions is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS TutoringSessionsMinMax;
WITH MinMaxScaling AS (
    SELECT
        RecordId,
       (TutoringSessions - MIN(TutoringSessions) OVER ())::numeric / 
       (MAX(TutoringSessions) OVER () - MIN(TutoringSessions) OVER ()) AS TutoringSessionsMinMax
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.TutoringSessionsMinMax = tmp.TutoringSessionsMinMax
WHERE spf.RecordId = MinMaxScaling.RecordId;

-- PhysicalActivity is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PhysicalActivityMinMax;
WITH MinMaxScaling AS (
    SELECT
        RecordId,
       (PhysicalActivity - MIN(PhysicalActivity) OVER ())::numeric / 
       (MAX(PhysicalActivity) OVER () - MIN(PhysicalActivity) OVER ()) AS PhysicalActivityMinMax
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.PhysicalActivityMinMax = tmp.PhysicalActivityMinMax
WHERE spf.RecordId = MinMaxScaling.RecordId;

-- ExamScore is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, scaling to [0.0 - 1.0] with min-max.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS ExamScoreMinMax;
UPDATE StudentPerformanceFactors
SET ExamScore = ExamScore / 100.0
WHERE 1 > (SELECT AVG(ExamScore) FROM StudentPerformanceFactors);
WITH MinMaxScaling AS (
    SELECT
        RecordId,
       (ExamScore - MIN(ExamScore) OVER ())::numeric / 
       (MAX(ExamScore) OVER () - MIN(ExamScore) OVER ()) AS ExamScoreMinMax
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.ExamScoreMinMax = tmp.ExamScoreMinMax
WHERE spf.RecordId = MinMaxScaling.RecordId;