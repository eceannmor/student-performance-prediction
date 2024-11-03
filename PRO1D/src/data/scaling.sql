----------------------------
-- Scaling numerical data --
----------------------------
-- The script is safe to run multiple times over the same data and can be used to revert changes in the new columns or to update the new values.

-- Skipped for scaling due to being categorical: ParentalInvolvement, AccessToResources, ExtracurricularActivities, MotivationLevel, InternetAccess, FamilyIncome, TeacherQuality, SchoolType, PeerInfluence, LearningDisabilities, ParentalEducationLevel, DistanceFromHome, Gender.

-- Yes this is human written, yes this is how I talk.

-- HoursStudied is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max, and with z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS HoursStudiedMinMax;
COMMENT ON COLUMN StudentPerformanceFactors.HoursStudiedMinMax IS 'HoursStudied, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS HoursStudiedZ;
COMMENT ON COLUMN StudentPerformanceFactors.HoursStudiedZ IS 'HoursStudied, normalised using Z-Score normalisation.';
WITH Scaling AS (
    SELECT
        RecordId,
       (HoursStudied - MIN(HoursStudied) OVER ())::numeric / 
       (MAX(HoursStudied) OVER () - MIN(HoursStudied) OVER ()) AS HoursStudiedMinMax,
       (HoursStudied - AVG(HoursStudied) OVER())::numeric / STDDEV(HoursStudied) OVER() AS HoursStudiedZ
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.HoursStudiedMinMax = tmp.HoursStudiedMinMax
SET spf.HoursStudiedZ = tmp.HoursStudiedZ
WHERE spf.RecordId = Scaling.RecordId;

-- Attendance is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, scaling to [0.0 - 1.0] with min-max, and with z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS AttendanceMinMax;
COMMENT ON COLUMN StudentPerformanceFactors.AttendanceMinMax IS 'Attendance, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS AttendanceZ;
COMMENT ON COLUMN StudentPerformanceFactors.AttendanceZ IS 'Attendance, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET Attendance = Attendance / 100.0
WHERE 1 > (SELECT AVG(Attendance) FROM StudentPerformanceFactors);
WITH Scaling AS (
    SELECT
        RecordId,
       (Attendance - MIN(Attendance) OVER ())::numeric / 
       (MAX(Attendance) OVER () - MIN(Attendance) OVER ()) AS AttendanceMinMax,
       (Attendance - AVG(Attendance) OVER())::numeric / STDDEV(Attendance) OVER() AS AttendanceZ
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.AttendanceMinMax = tmp.AttendanceMinMax
SET spf.AttendanceZ = tmp.AttendanceZ
WHERE spf.RecordId = Scaling.RecordId;

-- SleepHours is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max, and with z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS SleepHoursMinMax;
COMMENT ON COLUMN StudentPerformanceFactors.SleepHoursMinMax IS 'SleepHours, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS SleepHoursZ;
COMMENT ON COLUMN StudentPerformanceFactors.SleepHoursZ IS 'SleepHours, normalised using Z-Score normalisation.';
WITH Scaling AS (
    SELECT
        RecordId,
       (SleepHours - MIN(SleepHours) OVER ())::numeric / 
       (MAX(SleepHours) OVER () - MIN(SleepHours) OVER ()) AS SleepHoursMinMax,
       (SleepHours - AVG(SleepHours) OVER())::numeric / STDDEV(SleepHours) OVER() AS SleepHoursZ
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.SleepHoursMinMax = tmp.SleepHoursMinMax
SET spf.SleepHoursZ = tmp.SleepHoursZ
WHERE spf.RecordId = Scaling.RecordId;

-- PreviousScores is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, scaling to [0.0 - 1.0] with min-max, and with z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PreviousScoresMinMax;
COMMENT ON COLUMN StudentPerformanceFactors.PreviousScoresMinMax IS 'PreviousScores, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PreviousScoresZ;
COMMENT ON COLUMN StudentPerformanceFactors.PreviousScoresZ IS 'PreviousScores, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET PreviousScores = PreviousScores / 100.0
WHERE 1 > (SELECT AVG(PreviousScores) FROM StudentPerformanceFactors);
WITH Scaling AS (
    SELECT
        RecordId,
       (PreviousScores - MIN(PreviousScores) OVER ())::numeric / 
       (MAX(PreviousScores) OVER () - MIN(PreviousScores) OVER ()) AS PreviousScoresMinMax,
       (PreviousScores - AVG(PreviousScores) OVER())::numeric / STDDEV(PreviousScores) OVER() AS PreviousScoresZ
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.PreviousScoresMinMax = tmp.PreviousScoresMinMax
SET spf.PreviousScoresZ = tmp.PreviousScoresZ
WHERE spf.RecordId = Scaling.RecordId;

-- TutoringSessions is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max, and with z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS TutoringSessionsMinMax;
COMMENT ON COLUMN StudentPerformanceFactors.TutoringSessionsMinMax IS 'TutoringSessions, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS TutoringSessionsZ;
COMMENT ON COLUMN StudentPerformanceFactors.TutoringSessionsZ IS 'TutoringSessions, normalised using Z-Score normalisation.';
WITH Scaling AS (
    SELECT
        RecordId,
       (TutoringSessions - MIN(TutoringSessions) OVER ())::numeric / 
       (MAX(TutoringSessions) OVER () - MIN(TutoringSessions) OVER ()) AS TutoringSessionsMinMax,
       (TutoringSessions - AVG(TutoringSessions) OVER())::numeric / STDDEV(TutoringSessions) OVER() AS TutoringSessionsZ
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.TutoringSessionsMinMax = tmp.TutoringSessionsMinMax
SET spf.TutoringSessionsZ = tmp.TutoringSessionsZ
WHERE spf.RecordId = Scaling.RecordId;

-- PhysicalActivity is an uncapped non-negative integer. Scaling to [0.0 - 1.0] with min-max, and with z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PhysicalActivityMinMax;
COMMENT ON COLUMN StudentPerformanceFactors.PhysicalActivityMinMax IS 'PhysicalActivity, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PhysicalActivityZ;
COMMENT ON COLUMN StudentPerformanceFactors.PhysicalActivityZ IS 'PhysicalActivity, normalised using Z-Score normalisation.';
WITH Scaling AS (
    SELECT
        RecordId,
       (PhysicalActivity - MIN(PhysicalActivity) OVER ())::numeric / 
       (MAX(PhysicalActivity) OVER () - MIN(PhysicalActivity) OVER ()) AS PhysicalActivityMinMax,
       (PhysicalActivity - AVG(PhysicalActivity) OVER())::numeric / STDDEV(PhysicalActivity) OVER() AS PhysicalActivityZ
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.PhysicalActivityMinMax = tmp.PhysicalActivityMinMax
SET spf.PhysicalActivityZ = tmp.PhysicalActivityZ
WHERE spf.RecordId = Scaling.RecordId;

-- ExamScore is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, scaling to [0.0 - 1.0] with min-max, and with z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS ExamScoreMinMax;
COMMENT ON COLUMN StudentPerformanceFactors.ExamScoreMinMax IS 'ExamScore, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS ExamScoreZ;
COMMENT ON COLUMN StudentPerformanceFactors.ExamScoreZ IS 'ExamScore, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET ExamScore = ExamScore / 100.0
WHERE 1 > (SELECT AVG(ExamScore) FROM StudentPerformanceFactors);
WITH Scaling AS (
    SELECT
        RecordId,
       (ExamScore - MIN(ExamScore) OVER ())::numeric / 
       (MAX(ExamScore) OVER () - MIN(ExamScore) OVER ()) AS ExamScoreMinMax,
       (ExamScore - AVG(ExamScore) OVER())::numeric / STDDEV(ExamScore) OVER() AS ExamScoreZ
    FROM StudentPerformanceFactors
)
UPDATE StudentPerformanceFactors spf
SET spf.ExamScoreMinMax = tmp.ExamScoreMinMax
SET spf.ExamScoreZ = tmp.ExamScoreZ
WHERE spf.RecordId = Scaling.RecordId;