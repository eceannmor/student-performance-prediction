package app;
import java.util.Properties;
import java.io.*;

public record UrlAndCredentials(String hostname, String port, String dbname, String username, String password) {
    public UrlAndCredentials(String hostname, String port, String dbname, String username, String password) {
        this.hostname = hostname;
        this.port = port;
        this.dbname = dbname;
        this.username = username;
        this.password = password;
    }

    public static UrlAndCredentials parse(String databaseConfigurationFile) {
        Properties connectionProperties = new Properties();
        String hostname, port, dbname, username, password = null;
        UrlAndCredentials result = null;
        try {
            connectionProperties.load(new FileInputStream(databaseConfigurationFile));
            hostname = connectionProperties.getProperty("hostname");
            port = connectionProperties.getProperty("port");
            dbname = connectionProperties.getProperty("dbname");
            username = connectionProperties.getProperty("username");
            password = connectionProperties.getProperty("password");
            result = new UrlAndCredentials(hostname, port, dbname, username, password);
            return result;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
