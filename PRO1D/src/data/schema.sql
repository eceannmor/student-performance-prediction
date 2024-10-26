DROP TABLE IF EXISTS StudentPerformanceFactors;
CREATE TABLE StudentPerformanceFactors (
    RecordId bigint GENERATED BY DEFAULT AS IDENTITY,
    HoursStudied integer,
    Attendance integer,
    ParentalInvolvement integer,
    AccessToResources integer,
    ExtracurricularActivities integer,
    SleepHours integer,
    PreviousScores integer,
    MotivationLevel integer,
    InternetAccess integer,
    TutoringSessions integer,
    FamilyIncome integer,
    TeacherQuality integer,
    SchoolType text,
    PeerInfluence integer,
    PhysicalActivity integer,
    LearningDisabilities integer,
    ParentalEducationLevel text,
    DistanceFromHome integer,
    Gender text,
    ExamScore integer,
    PRIMARY KEY (RecordId)
);