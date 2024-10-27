-- HoursStudied
UPDATE StudentPerformanceFactors
SET HoursStudied = (
    SELECT AVG(HoursStudied) 
    FROM StudentPerformanceFactors
    WHERE HoursStudied IS NOT NULL
)
WHERE HoursStudied IS NULL;

-- Attendance
UPDATE StudentPerformanceFactors
SET Attendance = (
    SELECT AVG(Attendance) 
    FROM StudentPerformanceFactors
    WHERE Attendance IS NOT NULL
)
WHERE Attendance IS NULL;

-- ParentalInvolvement
UPDATE StudentPerformanceFactors
SET ParentalInvolvement = 0
WHERE ParentalInvolvement IS NULL;

-- AccessToResources
UPDATE StudentPerformanceFactors
SET AccessToResources = 0
WHERE AccessToResources IS NULL;

-- ExtracurricularActivities
UPDATE StudentPerformanceFactors
SET AccessToResources = 0
WHERE AccessToResources IS NULL;

-- SleepHours
UPDATE StudentPerformanceFactors
SET SleepHours = (
    SELECT AVG(SleepHours) 
    FROM StudentPerformanceFactors
    WHERE SleepHours IS NOT NULL
)
WHERE SleepHours IS NULL;

-- PreviousScores
UPDATE StudentPerformanceFactors
SET PreviousScores = (
    SELECT AVG(PreviousScores) 
    FROM StudentPerformanceFactors
    WHERE PreviousScores IS NOT NULL
)
WHERE PreviousScores IS NULL;

-- MotivationLevel
UPDATE StudentPerformanceFactors
SET AccessToResources = 0
WHERE AccessToResources IS NULL;

-- InternetAccess
UPDATE StudentPerformanceFactors
SET AccessToResources = 0
WHERE AccessToResources IS NULL;

-- TutoringSessions
UPDATE StudentPerformanceFactors
SET TutoringSessions = (
    SELECT CAST(ROUND(AVG(TutoringSessions)) AS INTEGER) 
    FROM StudentPerformanceFactors
    WHERE TutoringSessions IS NOT NULL
)
WHERE AccessToResources IS NULL;

-- FamilyIncome
UPDATE StudentPerformanceFactors
SET FamilyIncome = 0
WHERE FamilyIncome IS NULL;

-- TeacherQuality
UPDATE StudentPerformanceFactors
SET TeacherQuality = 0
WHERE TeacherQuality IS NULL;

-- SchoolType
UPDATE StudentPerformanceFac
SET SchoolType = (
    SELECT SchoolType
    FROM StudentPerformanceFactors
    WHERE SchoolType IS NOT NULL
    GROUP BY SchoolType
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
WHERE SchoolType IS NULL;

-- PeerInfluence
UPDATE StudentPerformanceFactors
SET PeerInfluence = 0
WHERE PeerInfluence IS NULL;

-- PhysicalActivity
UPDATE StudentPerformanceFactors
SET PhysicalActivity = (
    SELECT CAST(ROUND(AVG(PhysicalActivity)) AS INTEGER) 
    FROM StudentPerformanceFactors
    WHERE PhysicalActivity IS NOT NULL
)
WHERE AccessToResources IS NULL;

-- LearningDisabilities
UPDATE StudentPerformanceFactors
SET LearningDisabilities = 0
WHERE LearningDisabilities IS NULL;

-- ParentalEducationLevel
UPDATE StudentPerformanceFactors
SET ParentalEducationLevel = (
    SELECT ParentalEducationLevel
    FROM StudentPerformanceFactors
    WHERE ParentalEducationLevel IS NOT NULL
    GROUP BY ParentalEducationLevel
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
WHERE ParentalEducationLevel IS NULL;

-- DistanceFromHome
UPDATE StudentPerformanceFactors
SET DistanceFromHome = 0
WHERE DistanceFromHome IS NULL;

-- Gender
UPDATE StudentPerformanceFactors
SET Gender = 'Other'
WHERE Gender IS NULL;

-- ExamScore
-- Must not be edited