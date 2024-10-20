package app;

import java.sql.*;

public class DataService {
    public static Connection open(UrlAndCredentials urlAndCredentials) {
        String databaseUrl = "jdbc:postgresql://" + urlAndCredentials.hostname() +
                ":" + urlAndCredentials.port() + "/"
                + urlAndCredentials.dbname();
        try {
            Connection connection = DriverManager.getConnection(databaseUrl, urlAndCredentials.username(),
                    urlAndCredentials.password());
            return connection;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void exitNicely(Connection connection) {
        try {
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            System.exit(0);
        }
    }
}
