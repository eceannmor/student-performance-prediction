package app;

import java.sql.Connection;

public class DataCleanupService {
    Connection db;

    public DataCleanupService(Connection connection) {
        this.db = connection;
    }

    public int manageNullValues() {
        return 0;
    }
}
