import java.sql.*;

import app.DataService;
import app.UrlAndCredentials;

public class App {
    public static void main(String[] args) {
        UrlAndCredentials u = UrlAndCredentials.parse("database.cfg");
        Connection c = DataService.open(u);
        try {
            Statement statement = c.createStatement();
            String createTable = """
                        DROP TABLE IF EXISTS StudentPerformanceFactors;
                        CREATE TABLE StudentPerformanceFactors (
                        RecordId bigint GENERATED BY DEFAULT AS IDENTITY,
                        HoursStudied integer,
                        Attendance integer,
                        ParentalInvolvement text,
                        AccessToResources text,
                        ExtracurricularActivities text,
                        SleepHours integer,
                        PreviousScores integer,
                        MotivationLevel text,
                        InternetAccess text,
                        TutoringSessions integer,
                        FamilyIncome text,
                        TeacherQuality text,
                        SchoolType text,
                        PeerInfluence text,
                        PhysicalActivity integer,
                        LearningDisabilities text,
                        ParentalEducationLevel text,
                        DistanceFromHome text,
                        Gender text,
                        ExamScore integer,
                        PRIMARY KEY (RecordId)
                    );""";
            System.out.println(statement.executeUpdate(createTable));
            String dataImport = "COPY StudentPerformanceFactors(HoursStudied,Attendance,ParentalInvolvement,AccessToResources,ExtracurricularActivities,SleepHours,PreviousScores,MotivationLevel,InternetAccess,TutoringSessions,FamilyIncome,TeacherQuality,SchoolType,PeerInfluence,PhysicalActivity,LearningDisabilities,ParentalEducationLevel,DistanceFromHome,Gender,ExamScore)" +
                    "FROM '" + System.getProperty("user.dir") + "\\data\\StudentPerformanceFactors.csv'" +
                    "DELIMITER ',' CSV HEADER;";
            System.out.println(statement.executeUpdate(dataImport));
        } catch (Exception e) {
            e.printStackTrace();
        }
        DataService.exitNicely(c);
    }
}
