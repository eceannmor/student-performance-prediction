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
        Connection c = DatabaseService.open(u);
        // Inserting the edited source data into the database
        try {
            Statement statement = c.createStatement();

            // CREATE TABLE script
            String createTable = new String(Files.readAllBytes(Paths.get("./data/schema.sql")), StandardCharsets.UTF_8);
            statement.executeUpdate(createTable);

            // COPY FROM CSV script
            String dataImport = "COPY StudentPerformanceFactors(HoursStudied,Attendance,ParentalInvolvement,AccessToResources,ExtracurricularActivities,SleepHours,PreviousScores,MotivationLevel,InternetAccess,TutoringSessions,FamilyIncome,TeacherQuality,SchoolType,PeerInfluence,PhysicalActivity,LearningDisabilities,ParentalEducationLevel,DistanceFromHome,Gender,ExamScore)"
                    + "FROM '" + System.getProperty("user.dir") + "\\data\\UpdatedSource.csv'" +
                    "DELIMITER ',' CSV HEADER NULL AS 'null';";
            System.out.println(statement.executeUpdate(dataImport));

            // UPDATE WHERE IS NULL script
            String removeNullValues = new String(Files.readAllBytes(Paths.get("data\\replaceNulls.sql")),
                    StandardCharsets.UTF_8);
            System.out.println(statement.executeUpdate(removeNullValues));

            // Sample use of the updated data
            ResultSet resultSet = statement.executeQuery("WITH tmp AS (\n" + //
                                "\tSELECT \n" + //
                                "\t\tGender,\n" + //
                                "\t\tHoursStudied,\n" + //
                                "\t\tAttendance,\n" + //
                                "\t\tExamScore,\n" + //
                                "\t\tParentalInvolvement + AccessToResources + InternetAccess + FamilyIncome + \n" + //
                                "\t\tTeacherQuality + PeerInfluence + LearningDisabilities AS Bonus\n" + //
                                "\tFROM StudentPerformanceFactors\n" + //
                                ")\n" + //
                                "\n" + //
                                "SELECT \n" + //
                                "\tGender,\n" + //
                                "\tBonus,\n" + //
                                "\tROUND(AVG(HoursStudied), 2) AS StudyHours,\n" + //
                                "\tROUND(AVG(Attendance), 2) AS Attendance,\n" + //
                                "\tROUND(AVG(ExamScore), 2) AS Score\n" + //
                                "FROM tmp\n" + //
                                "GROUP BY \n" + //
                                "\tGender, \n" + //
                                "\tBonus\n" + //
                                "ORDER BY AVG(ExamScore) DESC\n" + //
                                "LIMIT 5;");
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
            int columnsNumber = resultSetMetaData.getColumnCount();
            while (resultSet.next()) {
                for (int i = 1; i <= columnsNumber; i++) {
                    if (i > 1) System.out.print(",\t\t");
                    String columnValue = resultSet.getString(i);
                    System.out.print(columnValue + " " + resultSetMetaData.getColumnName(i));
                }
                System.out.println("");
            }
            resultSet.close();
            statement.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        DatabaseService.exitNicely(c);
    }
}
