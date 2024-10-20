import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;

import app.DataCleanupService;
import app.DatabaseService;
import app.UrlAndCredentials;

public class App {
    public static void main(String[] args) {
        UrlAndCredentials u = UrlAndCredentials.parse("database.cfg");
        Connection c = DatabaseService.open(u);
        try {
            Statement statement = c.createStatement();
            String createTable = new String(Files.readAllBytes(Paths.get("data\\schema.sql")), StandardCharsets.UTF_8);
            statement.executeUpdate(createTable);
            String dataImport = "COPY StudentPerformanceFactors(HoursStudied,Attendance,ParentalInvolvement,AccessToResources,ExtracurricularActivities,SleepHours,PreviousScores,MotivationLevel,InternetAccess,TutoringSessions,FamilyIncome,TeacherQuality,SchoolType,PeerInfluence,PhysicalActivity,LearningDisabilities,ParentalEducationLevel,DistanceFromHome,Gender,ExamScore)" +
                    "FROM '" + System.getProperty("user.dir") + "\\data\\StudentPerformanceFactors.csv'" +
                    "DELIMITER ',' CSV HEADER;";
            System.out.println(statement.executeUpdate(dataImport));
        } catch (Exception e) {
            e.printStackTrace();
        }
        DataCleanupService dcs = new DataCleanupService(c);
        DatabaseService.exitNicely(c);
    }
}
