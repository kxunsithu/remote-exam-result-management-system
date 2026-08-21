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

    private static String getResolvedDbPath() {
        String envPath = System.getProperty("db.path");
        if (envPath != null && !envPath.isBlank()) {
            return envPath;
        }
        File cwd = new File(".").getAbsoluteFile();
        if (cwd.getName().equals("rmi-server") || cwd.getName().equals("web-app")) {
            return new File(cwd.getParentFile(), "data/remote_exam_result.db").getAbsolutePath();
        }
        return new File("data/remote_exam_result.db").getAbsolutePath();
    }

    private static String getJdbcUrl() {
        return "jdbc:sqlite:" + getResolvedDbPath();
    }

    private DatabaseConnection() {}

    public static Connection getConnection() throws SQLException {
        File dbFile = new File(getResolvedDbPath());
        File dataDir = dbFile.getParentFile();
        if (dataDir != null && !dataDir.exists()) {
            dataDir.mkdirs();
        }

        Connection conn = DriverManager.getConnection(getJdbcUrl());
        try (var stmt = conn.createStatement()) {
            stmt.execute("PRAGMA foreign_keys = ON");
            stmt.execute("PRAGMA journal_mode = WAL");
        }
        return conn;
    }

    public static String getDatabasePath() {
        return getResolvedDbPath();
    }
}
