import java.sql.*;

import app.DataService;
import app.UrlAndCredentials;

public class App {
    public static void main(String[] args) {
        UrlAndCredentials u = UrlAndCredentials.parse("database.cfg");
        Connection c = DataService.open(u);
        try {
            Statement s = c.createStatement();
            ResultSet rs = s.executeQuery("SELECT * FROM test;");
            while (rs.next()) {
                System.out.println(rs.getString(1) + "\t" + rs.getString(2));
            }
            rs.close();
            s.close();
            c.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
