package server;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Manages the SQLite database connection.
 * Database file is stored at data/remote_exam_result.db (relative to project root).
 */
public class DatabaseConnection {

    private static final String DB_DIR = "data";
    private static final String DB_FILE = DB_DIR + "/remote_exam_result.db";
    private static final String JDBC_URL = "jdbc:sqlite:" + DB_FILE;

    private DatabaseConnection() {}

    /**
     * Returns a new JDBC connection to the SQLite database.
     * Creates the data directory if it doesn't exist.
     */
    public static Connection getConnection() throws SQLException {
        // Ensure data directory exists
        File dataDir = new File(DB_DIR);
        if (!dataDir.exists()) {
            boolean created = dataDir.mkdirs();
            if (!created) {
                throw new SQLException("Failed to create data directory: " + dataDir.getAbsolutePath());
            }
        }

        Connection conn = DriverManager.getConnection(JDBC_URL);
        // Enable foreign key enforcement
        try (var stmt = conn.createStatement()) {
            stmt.execute("PRAGMA foreign_keys = ON");
            stmt.execute("PRAGMA journal_mode = WAL");
        }
        return conn;
    }

    /**
     * Returns the absolute path of the database file (for diagnostics).
     */
    public static String getDatabasePath() {
        return new File(DB_FILE).getAbsolutePath();
    }
}
