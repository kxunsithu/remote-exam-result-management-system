package server;

import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Initializes the SQLite database schema and inserts sample data.
 * Called once at RMI server startup.
 */
public class DatabaseInitializer {

    /**
     * Creates all tables and inserts sample data if tables are empty.
     */
    public static void initialize() {
        System.out.println("Initializing SQLite database...");
        System.out.println("Database path: " + DatabaseConnection.getDatabasePath());

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            createTables(stmt);
            insertSampleData(conn);
            createIndexes(stmt);

            System.out.println("SQLite database initialized successfully.");

        } catch (SQLException e) {
            System.err.println("Database initialization failed: " + e.getMessage());
            throw new RuntimeException("Cannot initialize database", e);
        }
    }

    private static void createTables(Statement stmt) throws SQLException {
        // Users table
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS users (
                id         INTEGER PRIMARY KEY AUTOINCREMENT,
                email      TEXT    NOT NULL UNIQUE,
                password   TEXT    NOT NULL,
                role       TEXT    NOT NULL CHECK(role IN ('ADMIN','STUDENT')),
                created_at TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
            )
            """);

        // Students table
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS students (
                id            INTEGER PRIMARY KEY AUTOINCREMENT,
                student_id    TEXT    NOT NULL UNIQUE,
                name          TEXT    NOT NULL,
                email         TEXT    NOT NULL UNIQUE,
                phone         TEXT,
                gender        TEXT,
                created_at    TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
            )
            """);

        // Subjects table
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS subjects (
                id           INTEGER PRIMARY KEY AUTOINCREMENT,
                subject_code TEXT    NOT NULL UNIQUE,
                subject_name TEXT    NOT NULL,
                credit       INTEGER NOT NULL,
                department   TEXT    NOT NULL,
                semester     INTEGER NOT NULL,
                created_at   TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
            )
            """);

        // Exam results table
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS exam_results (
                id            INTEGER PRIMARY KEY AUTOINCREMENT,
                student_id    INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
                subject_id    INTEGER NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
                marks         REAL    NOT NULL,
                total_marks   REAL    NOT NULL DEFAULT 100,
                grade         TEXT    NOT NULL,
                academic_year TEXT    NOT NULL,
                semester      INTEGER NOT NULL,
                exam_type     TEXT    NOT NULL DEFAULT 'REGULAR',
                created_at    TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
            )
            """);

        // Migration for existing tables
        try {
            stmt.execute("ALTER TABLE exam_results ADD COLUMN exam_type TEXT NOT NULL DEFAULT 'REGULAR'");
        } catch (SQLException ignored) {
            // Column already exists
        }
    }

    private static void createIndexes(Statement stmt) throws SQLException {
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_results_student ON exam_results(student_id)");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_results_subject ON exam_results(subject_id)");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_results_year    ON exam_results(academic_year)");
        // Drop old index if it exists
        stmt.execute("DROP INDEX IF EXISTS idx_unique_student_subject_year_sem");
        // Clean up duplicate records if any exist before creating UNIQUE index
        stmt.execute("""
            DELETE FROM exam_results
            WHERE id NOT IN (
                SELECT MIN(id)
                FROM exam_results
                GROUP BY student_id, subject_id, academic_year, semester, exam_type
            )
            """);
        stmt.execute("CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_student_subject_year_sem_type ON exam_results(student_id, subject_id, academic_year, semester, exam_type)");
    }

    private static void insertSampleData(Connection conn) throws SQLException {
        // Only insert if tables are empty
        if (tableIsEmpty(conn, "users")) {
            insertSampleUsers(conn);
        }
        if (tableIsEmpty(conn, "students")) {
            insertSampleStudents(conn);
        }
        if (tableIsEmpty(conn, "subjects")) {
            insertSampleSubjects(conn);
        }
        if (tableIsEmpty(conn, "exam_results")) {
            insertSampleResults(conn);
        }
    }

    private static boolean tableIsEmpty(Connection conn, String table) throws SQLException {
        try (Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM " + table)) {
            return rs.next() && rs.getInt(1) == 0;
        }
    }

    private static void insertSampleUsers(Connection conn) throws SQLException {
        String adminHash   = BCrypt.hashpw("admin123", BCrypt.gensalt(12));
        String studentHash = BCrypt.hashpw("student123", BCrypt.gensalt(12));

        String sql = "INSERT INTO users (email, password, role) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "admin@example.com");
            ps.setString(2, adminHash);
            ps.setString(3, "ADMIN");
            ps.executeUpdate();

            ps.setString(1, "john.doe@university.edu");
            ps.setString(2, studentHash);
            ps.setString(3, "STUDENT");
            ps.executeUpdate();
        }
        System.out.println("  ✓ Sample users inserted.");
    }


    private static void insertSampleStudents(Connection conn) throws SQLException {
        String sql = """
            INSERT INTO students (student_id, name, email, phone, gender)
            VALUES (?, ?, ?, ?, ?)
            """;
        Object[][] data = {
            {"ST001", "John Doe",     "john.doe@university.edu",     "555-0101", "Male"},
            {"ST002", "Jane Smith",   "jane.smith@university.edu",   "555-0102", "Female"},
            {"ST003", "Alex Brown",   "alex.brown@university.edu",   "555-0103", "Male"},
            {"ST004", "Maria Garcia", "maria.garcia@university.edu", "555-0104", "Female"},
            {"ST005", "Liam Johnson", "liam.johnson@university.edu", "555-0105", "Male"},
        };
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Object[] row : data) {
                ps.setString(1, (String) row[0]);
                ps.setString(2, (String) row[1]);
                ps.setString(3, (String) row[2]);
                ps.setString(4, (String) row[3]);
                ps.setString(5, (String) row[4]);
                ps.executeUpdate();
            }
        }
        System.out.println("  ✓ Sample students inserted.");
    }

    private static void insertSampleSubjects(Connection conn) throws SQLException {
        String sql = """
            INSERT INTO subjects (subject_code, subject_name, credit, department, semester)
            VALUES (?, ?, ?, ?, ?)
            """;
        Object[][] data = {
            {"CS101", "Java Programming",     4, "Computer Science",      1},
            {"CS102", "Database Systems",     3, "Computer Science",      1},
            {"CS103", "Software Engineering", 3, "Computer Science",      2},
            {"CS104", "Computer Networks",    3, "Information Technology", 2},
            {"CS105", "Web Development",      3, "Computer Science",      1},
        };
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Object[] row : data) {
                ps.setString(1, (String) row[0]);
                ps.setString(2, (String) row[1]);
                ps.setInt(3, (Integer) row[2]);
                ps.setString(4, (String) row[3]);
                ps.setInt(5, (Integer) row[4]);
                ps.executeUpdate();
            }
        }
        System.out.println("  ✓ Sample subjects inserted.");
    }

    private static void insertSampleResults(Connection conn) throws SQLException {
        int[] studentIds = fetchIds(conn, "students");
        int[] subjectIds = fetchIds(conn, "subjects");

        if (studentIds.length == 0 || subjectIds.length == 0) return;

        String sql = """
            INSERT INTO exam_results (student_id, subject_id, marks, total_marks, grade, academic_year, semester)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;

        double[][] marksData = {
            {studentIds[0], subjectIds[0], 85, 100},
            {studentIds[0], subjectIds[1], 78, 100},
            {studentIds[0], subjectIds[2], 82, 100},
            {studentIds[1], subjectIds[0], 92, 100},
            {studentIds[1], subjectIds[1], 88, 100},
            {studentIds[1], subjectIds[4], 76, 100},
            {studentIds[2], subjectIds[0], 65, 100},
            {studentIds[2], subjectIds[3], 72, 100},
            {studentIds[2], subjectIds[4], 58, 100},
        };

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (double[] row : marksData) {
                int sId = (int) row[0];
                int subjId = (int) row[1];
                double marks = row[2];
                double total = row[3];
                String grade = ExamResultServiceImpl.computeGrade(marks, total);
                ps.setInt(1, sId);
                ps.setInt(2, subjId);
                ps.setDouble(3, marks);
                ps.setDouble(4, total);
                ps.setString(5, grade);
                ps.setString(6, "2024-2025");
                ps.setInt(7, 1);
                ps.executeUpdate();
            }
        }
        System.out.println("  ✓ Sample exam results inserted.");
    }

    private static int[] fetchIds(Connection conn, String table) throws SQLException {
        try (Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT id FROM " + table + " ORDER BY id")) {
            java.util.List<Integer> ids = new java.util.ArrayList<>();
            while (rs.next()) ids.add(rs.getInt(1));
            return ids.stream().mapToInt(Integer::intValue).toArray();
        }
    }
}
