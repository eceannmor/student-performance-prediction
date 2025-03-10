import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;

import app.DatabaseService;
import app.UrlAndCredentials;

public class App {

    public static final String OK = "\u001B[32m[OK]\u001B[0m\t";
    // public static final String WARN = "\u001B[33m[Warn]\u001B[0m\t"; // unused
    public static final String FATAL = "\u001B[31m[Fatal]\u001B[0m\t";

    public static void main(String[] args) {
        /**** Data load and cleanup ****/

        /*
         * Replacing dictionary values with numeric ones to make comparing groups of
         * stats easier
         * {No, Yes} -> {0, 1}
         * {Low, Medium, High} -> {-1, 0, 1}
         * {Negative, Neutral, Positive} -> {-1, 0, 1}
         * {Far, Moderate, Near} -> {-1, 0, 1}
         * Leaving potential grouping columns like school type and parental education
         * level as they are; but
         * Replacing missing values with NULL to be handled on the database level
         * 
         * Duplicated will not be removed as it is reasonable to have several students
         * in similar conditions
         * Numerical data will not be normalised as it already has clearly defined
         * bounds, e.g. [0-100] for test scored or attendance
         */
        try {
            String sourceData = new String(Files.readAllBytes(Paths.get("./data/StudentPerformanceFactors.csv")),
                    StandardCharsets.UTF_8);
            sourceData = sourceData.replaceAll("No", "0").replaceAll("Yes", "1");
            sourceData = sourceData.replaceAll("Low", "-1").replaceAll("Medium", "0")
                    // Special case, avoiding replacing 'High School' with '1 School'
                    .replaceAll("High,", "1,");
            sourceData = sourceData.replaceAll("Negative", "-1").replaceAll("Neutral", "0").replaceAll("Positive", "1");
            sourceData = sourceData.replaceAll("Far", "-1").replaceAll("Moderate", "0").replaceAll("Near", "1");
            // Moving the problem of missing values to the database level
            sourceData = sourceData.replaceAll(",,", ",null,");
            Files.write(Paths.get("./data/UpdatedSource.csv"), sourceData.getBytes(StandardCharsets.UTF_8));
        } catch (Exception e) {
            e.printStackTrace();
            System.exit(1);
        }

        // Database connection
        UrlAndCredentials u = UrlAndCredentials.parse("database.cfg");
        if (null == u) {
            System.err.println(FATAL + "Database url and/or credentials failed to parse");
            System.exit(1);
        }
        Connection c = DatabaseService.open(u);
        if (null == c) {
            System.err.println(FATAL + "The connection could not be opened");
            System.exit(1);
        }
        // Inserting the edited source data into the database
        try {
            Statement statement = c.createStatement();

            // CREATE TABLE script
            String createTable = new String(Files.readAllBytes(Paths.get("./data/schema.sql")), StandardCharsets.UTF_8);
            System.out.println(OK + statement.executeUpdate(createTable));

            // COPY FROM CSV script
            String dataImport = "COPY StudentPerformanceFactors(HoursStudied,Attendance,ParentalInvolvement,AccessToResources,ExtracurricularActivities,SleepHours,PreviousScores,MotivationLevel,InternetAccess,TutoringSessions,FamilyIncome,TeacherQuality,SchoolType,PeerInfluence,PhysicalActivity,LearningDisabilities,ParentalEducationLevel,DistanceFromHome,Gender,ExamScore)"
                    + "FROM '" + System.getProperty("user.dir") + "\\data\\UpdatedSource.csv'" +
                    "DELIMITER ',' CSV HEADER NULL AS 'null';";
            System.out.println(OK + statement.executeUpdate(dataImport));

            // UPDATE WHERE IS NULL script
            String removeNullValues = new String(Files.readAllBytes(Paths.get("data\\replaceNulls.sql")),
                    StandardCharsets.UTF_8);
            System.out.println(OK + statement.executeUpdate(removeNullValues));

            // UPDATE standardisation script
            String scaling = new String(Files.readAllBytes(Paths.get("data\\scaling.sql")),
                    StandardCharsets.UTF_8);
            System.out.println(OK + statement.executeUpdate(scaling));
            // ResultSet tmp = statement.executeQuery("SELECT COUNT(*) FROM StudentPerformanceFactors;");
            // tmp.next();
            // int rows = tmp.getInt(1);
            // statement.executeUpdate("ALTER TABLE StudentPerformanceFactors ADD COLUMN IF NOT EXISTS tmp integer;");
            // for (int i = 1; i <= rows; i++) {
            //     statement.executeUpdate("UPDATE StudentPerformanceFactors SET tmp = " + Math.floor(Math.random * 100) + " WHERE RecordId = " + i);
            // }
            // statement.executeUpdate("COPY (SELECT * FROM StudentPerformanceFactors WHERE tmp < 80) TO '" + System.getProperty("user.dir") + "\\data\\trainingSet.csv'" + " DELIMITER ',' CSV HEADER;");
            // statement.executeUpdate("COPY (SELECT * FROM StudentPerformanceFactors WHERE tmp >= 80) TO '" + System.getProperty("user.dir") + "\\data\\testSet.csv'" + " DELIMITER ',' CSV HEADER;");
            // statement.executeUpdate("ALTER TABLE StudentPerformanceFactors DROP COLUMN tmp;");
            statement.executeUpdate("COPY (SELECT * FROM StudentPerformanceFactors) TO '" + System.getProperty("user.dir") + "\\data\\data.csv'" + " DELIMITER ',' CSV HEADER;");
            statement.close();
        } catch (Exception e) {
            System.err.println(FATAL + e.toString());
        }
        DatabaseService.exitNicely(c);
    }
}
