----------------------------
-- Scaling numerical data --
----------------------------
-- The script is safe to run multiple times over the same data and can be used to revert changes in the new columns or to update the new values.

-- Skipped for scaling due to being categorical: ParentalInvolvement, AccessToResources, ExtracurricularActivities, MotivationLevel, InternetAccess, FamilyIncome, TeacherQuality, SchoolType, PeerInfluence, LearningDisabilities, ParentalEducationLevel, DistanceFromHome, Gender.

-- Yes this is human written, yes this is how I talk.

-- HoursStudied is an uncapped non-negative integer. Normalising with min-max and z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS HoursStudiedMinMax numeric;
COMMENT ON COLUMN StudentPerformanceFactors.HoursStudiedMinMax IS 'HoursStudied, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS HoursStudiedZ numeric;
COMMENT ON COLUMN StudentPerformanceFactors.HoursStudiedZ IS 'HoursStudied, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET HoursStudiedMinMax = (HoursStudied - (SELECT MIN(HoursStudied) FROM StudentPerformanceFactors))::numeric / ((SELECT MAX(HoursStudied) FROM StudentPerformanceFactors)) - (SELECT MIN(HoursStudied) FROM StudentPerformanceFactors),
    HoursStudiedZ = (HoursStudied - (SELECT AVG(HoursStudied) FROM StudentPerformanceFactors))::numeric / (SELECT STDDEV(HoursStudied) FROM StudentPerformanceFactors);

-- Attendance is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, normalising with min-max and z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS AttendanceMinMax numeric;
COMMENT ON COLUMN StudentPerformanceFactors.AttendanceMinMax IS 'Attendance, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS AttendanceZ numeric;
COMMENT ON COLUMN StudentPerformanceFactors.AttendanceZ IS 'Attendance, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET Attendance = Attendance / 100.0
WHERE 1 > (SELECT AVG(Attendance) FROM StudentPerformanceFactors);
UPDATE StudentPerformanceFactors
SET AttendanceMinMax = (Attendance - (SELECT MIN(Attendance) FROM StudentPerformanceFactors))::numeric / ((SELECT MAX(Attendance) FROM StudentPerformanceFactors)) - (SELECT MIN(Attendance) FROM StudentPerformanceFactors),
    AttendanceZ = (Attendance - (SELECT AVG(Attendance) FROM StudentPerformanceFactors))::numeric / (SELECT STDDEV(Attendance) FROM StudentPerformanceFactors);

-- SleepHours is an uncapped non-negative integer. Normalising with min-max and z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS SleepHoursMinMax numeric;
COMMENT ON COLUMN StudentPerformanceFactors.SleepHoursMinMax IS 'SleepHours, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS SleepHoursZ numeric;
COMMENT ON COLUMN StudentPerformanceFactors.SleepHoursZ IS 'SleepHours, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET SleepHoursMinMax = (SleepHours - (SELECT MIN(SleepHours) FROM StudentPerformanceFactors))::numeric / ((SELECT MAX(SleepHours) FROM StudentPerformanceFactors)) - (SELECT MIN(SleepHours) FROM StudentPerformanceFactors),
    SleepHoursZ = (SleepHours - (SELECT AVG(SleepHours) FROM StudentPerformanceFactors))::numeric / (SELECT STDDEV(SleepHours) FROM StudentPerformanceFactors);

-- PreviousScores is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, normalising with min-max and z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PreviousScoresMinMax numeric;
COMMENT ON COLUMN StudentPerformanceFactors.PreviousScoresMinMax IS 'PreviousScores, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PreviousScoresZ numeric;
COMMENT ON COLUMN StudentPerformanceFactors.PreviousScoresZ IS 'PreviousScores, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET PreviousScores = PreviousScores / 100.0
WHERE 1 > (SELECT AVG(PreviousScores) FROM StudentPerformanceFactors);
UPDATE StudentPerformanceFactors
SET PreviousScoresMinMax = (PreviousScores - (SELECT MIN(PreviousScores) FROM StudentPerformanceFactors))::numeric / ((SELECT MAX(PreviousScores) FROM StudentPerformanceFactors)) - (SELECT MIN(PreviousScores) FROM StudentPerformanceFactors),
    PreviousScoresZ = (PreviousScores - (SELECT AVG(PreviousScores) FROM StudentPerformanceFactors))::numeric / (SELECT STDDEV(PreviousScores) FROM StudentPerformanceFactors);

-- TutoringSessions is an uncapped non-negative integer. Normalising with min-max and z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS TutoringSessionsMinMax numeric;
COMMENT ON COLUMN StudentPerformanceFactors.TutoringSessionsMinMax IS 'TutoringSessions, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS TutoringSessionsZ numeric;
COMMENT ON COLUMN StudentPerformanceFactors.TutoringSessionsZ IS 'TutoringSessions, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET TutoringSessionsMinMax = (TutoringSessions - (SELECT MIN(TutoringSessions) FROM StudentPerformanceFactors))::numeric / ((SELECT MAX(TutoringSessions) FROM StudentPerformanceFactors)) - (SELECT MIN(TutoringSessions) FROM StudentPerformanceFactors),
    TutoringSessionsZ = (TutoringSessions - (SELECT AVG(TutoringSessions) FROM StudentPerformanceFactors))::numeric / (SELECT STDDEV(TutoringSessions) FROM StudentPerformanceFactors);

-- PhysicalActivity is an uncapped non-negative integer. Normalising with min-max and z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PhysicalActivityMinMax numeric;
COMMENT ON COLUMN StudentPerformanceFactors.PhysicalActivityMinMax IS 'PhysicalActivity, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS PhysicalActivityZ numeric;
COMMENT ON COLUMN StudentPerformanceFactors.PhysicalActivityZ IS 'PhysicalActivity, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET PhysicalActivityMinMax = (PhysicalActivity - (SELECT MIN(PhysicalActivity) FROM StudentPerformanceFactors))::numeric / ((SELECT MAX(PhysicalActivity) FROM StudentPerformanceFactors)) - (SELECT MIN(PhysicalActivity) FROM StudentPerformanceFactors),
    PhysicalActivityZ = (PhysicalActivity - (SELECT AVG(PhysicalActivity) FROM StudentPerformanceFactors))::numeric / (SELECT STDDEV(PhysicalActivity) FROM StudentPerformanceFactors);

-- ExamScore is a non-negative integer, capped at 100. Updating the original data to be capped at 1 instead, normalising with min-max and z-score.
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS ExamScoreMinMax numeric;
COMMENT ON COLUMN StudentPerformanceFactors.ExamScoreMinMax IS 'ExamScore, normalised to 0-1 range using min-max normalisation.';
ALTER TABLE StudentPerformanceFactors 
ADD COLUMN IF NOT EXISTS ExamScoreZ numeric;
COMMENT ON COLUMN StudentPerformanceFactors.ExamScoreZ IS 'ExamScore, normalised using Z-Score normalisation.';
UPDATE StudentPerformanceFactors
SET ExamScoreMinMax = (ExamScore - (SELECT MIN(ExamScore) FROM StudentPerformanceFactors))::numeric / ((SELECT MAX(ExamScore) FROM StudentPerformanceFactors)) - (SELECT MIN(ExamScore) FROM StudentPerformanceFactors),
    ExamScoreZ = (ExamScore - (SELECT AVG(ExamScore) FROM StudentPerformanceFactors))::numeric / (SELECT STDDEV(ExamScore) FROM StudentPerformanceFactors);