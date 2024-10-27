import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;

import app.DatabaseService;
import app.UrlAndCredentials;

public class App {
    public static void main(String[] args) {
        /**** Data load and cleanup ****/

        /*
            Replacing dictionary values with numeric ones to make comparing groups of stats easier
            {No, Yes}                       -> {0, 1}
            {Low, Medium, High}             -> {-1, 0, 1}
            {Negative, Neutral, Positive}   -> {-1, 0, 1}
            {Far, Moderate, Near}           -> {-1, 0, 1}
            Leaving potential groupping columns like school type and parrental education level as they are 
        */
        try {
            String sourceData = new String(Files.readAllBytes(Paths.get("./data/StudentPerformanceFactors.csv")), StandardCharsets.UTF_8);
            sourceData = sourceData.replaceAll("No", "0").replaceAll("Yes", "1");
            sourceData = sourceData.replaceAll("Low", "-1").replaceAll("Medium", "0").replaceAll("High", "1");
            sourceData = sourceData.replaceAll("Negative", "-1").replaceAll("Neutral", "0").replaceAll("Positive", "1");
            sourceData = sourceData.replaceAll("Far", "-1").replaceAll("Moderate", "0").replaceAll("Near", "1");
            Files.write(Paths.get("./data/UpdatedSource.csv"), sourceData.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }

        // Database connection
        UrlAndCredentials u = UrlAndCredentials.parse("database.cfg");
        Connection c = DatabaseService.open(u);
        // Inserting the edited source data into the database
        try {
            Statement statement = c.createStatement();
            String createTable = new String(Files.readAllBytes(Paths.get("data\\schema.sql")), StandardCharsets.UTF_8);
            statement.executeUpdate(createTable);
            String dataImport = "COPY StudentPerformanceFactors(HoursStudied,Attendance,ParentalInvolvement,AccessToResources,ExtracurricularActivities,SleepHours,PreviousScores,MotivationLevel,InternetAccess,TutoringSessions,FamilyIncome,TeacherQuality,SchoolType,PeerInfluence,PhysicalActivity,LearningDisabilities,ParentalEducationLevel,DistanceFromHome,Gender,ExamScore)" +
                    "FROM '" + System.getProperty("user.dir") + "\\data\\UpdatedSource.csv'" +
                    "DELIMITER ',' CSV HEADER;";
            System.out.println(statement.executeUpdate(dataImport));
        } catch (Exception e) {
            e.printStackTrace();
        }
        DatabaseService.exitNicely(c);
    }
}
