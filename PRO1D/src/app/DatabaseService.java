package app;

import java.sql.*;

public class DatabaseService {
    public static final String OK     = "\u001B[32m[OK]\u001B[0m\t";
    public static final String FATAL  = "\u001B[31m[Fatal]\u001B[0m\t";
    public static Connection open(UrlAndCredentials urlAndCredentials) {
        String databaseUrl = "jdbc:postgresql://" + urlAndCredentials.hostname() +
                ":" + urlAndCredentials.port() + "/"
                + urlAndCredentials.dbname();
        try {
            Connection connection = DriverManager.getConnection(databaseUrl, urlAndCredentials.username(),
                    urlAndCredentials.password());
            return connection;
        } catch (SQLException e) {
            System.err.println(FATAL + e.toString());
            return null;
        }
    }

    public static void exitNicely(Connection connection) {
        try {
            connection.close();
            System.out.println(OK + "connection closed")
        } catch (SQLException e) {
            System.err.println(FATAL + e.toString());
        } finally {
            System.exit(0);
        }
    }
}