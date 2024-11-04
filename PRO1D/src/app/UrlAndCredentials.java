package app;
import java.util.Properties;
import java.io.*;

public record UrlAndCredentials(String hostname, String port, String dbname, String username, String password) {
    public static final String FATAL  = "\u001B[31m[Fatal]\u001B[0m\t";
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
            String errString = "";
            hostname = connectionProperties.getProperty("hostname");
            port = connectionProperties.getProperty("port");
            dbname = connectionProperties.getProperty("dbname");
            username = connectionProperties.getProperty("username");
            password = connectionProperties.getProperty("password");
            if (null == hostname) errString += ("".equals(errString)?"hostname":", hostname");
            if (null == port) errString     += ("".equals(errString)?"port":", port");
            if (null == dbname) errString   += ("".equals(errString)?"dbname":", dbname");
            if (null == username) errString += ("".equals(errString)?"username":", username");
            if (null == password) errString += ("".equals(errString)?"password":", password");
            if (!"".equals(errString)) {
                System.out.println(FATAL + errString + " couldn\'t be parsed. Check that database.cfg follows the structure described in the README");
                return null;
            }
            result = new UrlAndCredentials(hostname, port, dbname, username, password);
            return result;
        } catch (IOException e) {
            System.err.println(FATAL + e.toString());
        }
        return null;
    }
}
