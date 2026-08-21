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
 *
 * <p>Schema hierarchy: academic_years -> semesters -> subjects -> exam_results.</p>
 */
public class DatabaseInitializer {

    private static final String DEFAULT_YEAR = "2024-2025";

    /**
     * Creates all tables, migrates legacy data if needed,
     * and inserts sample data if tables are empty.
     */
    public static void initialize() {
        System.out.println("Initializing SQLite database...");
        System.out.println("Database path: " + DatabaseConnection.getDatabasePath());

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            createTables(stmt);
            migrateLegacySchema(conn);
            migrateSubjectsNullableSemester(conn);
            createIndexes(stmt);
            insertSampleData(conn);

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

        // Academic years table  (Step 1: e.g. "2024-2025")
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS academic_years (
                id         INTEGER PRIMARY KEY AUTOINCREMENT,
                year_name  TEXT    NOT NULL UNIQUE,
                created_at TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
            )
            """);

        // Semesters table  (Step 2: semester number within an academic year)
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS semesters (
                id               INTEGER PRIMARY KEY AUTOINCREMENT,
                academic_year_id INTEGER NOT NULL REFERENCES academic_years(id) ON DELETE CASCADE,
                semester_number  INTEGER NOT NULL CHECK(semester_number BETWEEN 1 AND 8),
                created_at       TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
                UNIQUE(academic_year_id, semester_number)
            )
            """);

        // Subjects table  (created standalone; optionally attached to a semester later)
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS subjects (
                id           INTEGER PRIMARY KEY AUTOINCREMENT,
                subject_code TEXT    NOT NULL,
                subject_name TEXT    NOT NULL,
                credit       INTEGER NOT NULL,
                department   TEXT    NOT NULL,
                semester_id  INTEGER REFERENCES semesters(id) ON DELETE CASCADE,
                created_at   TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
                UNIQUE(subject_code, semester_id)
            )
            """);

        // Exam results table (academic year / semester derived from the subject)
        stmt.execute("""
            CREATE TABLE IF NOT EXISTS exam_results (
                id          INTEGER PRIMARY KEY AUTOINCREMENT,
                student_id  INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
                subject_id  INTEGER NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
                marks       REAL    NOT NULL,
                total_marks REAL    NOT NULL DEFAULT 100,
                grade       TEXT    NOT NULL,
                exam_type   TEXT    NOT NULL DEFAULT 'REGULAR',
                created_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
            )
            """);

        // Migration for very old tables that lacked exam_type
        try {
            stmt.execute("ALTER TABLE exam_results ADD COLUMN exam_type TEXT NOT NULL DEFAULT 'REGULAR'");
        } catch (SQLException ignored) {
            // Column already exists
        }
    }

    // =========================================================================
    // Legacy migration: old flat schema (subjects.semester int +
    // exam_results.academic_year/semester columns) -> normalized hierarchy
    // =========================================================================

    private static void migrateLegacySchema(Connection conn) throws SQLException {
        boolean legacySubjects = columnExists(conn, "subjects", "semester");
        boolean legacyResults  = columnExists(conn, "exam_results", "academic_year");

        if (!legacySubjects && !legacyResults) return;

        System.out.println("Migrating legacy schema to academic_years/semesters structure...");

        try (Statement st = conn.createStatement()) {
            // Must be executed outside a transaction
            st.execute("PRAGMA foreign_keys = OFF");
            conn.setAutoCommit(false);

            // ── 1. Collect distinct academic years used in old results ──────
            java.util.List<String> years = new java.util.ArrayList<>();
            if (legacyResults) {
                try (ResultSet rs = st.executeQuery(
                        "SELECT DISTINCT academic_year FROM exam_results " +
                        "WHERE academic_year IS NOT NULL AND TRIM(academic_year) != '' ORDER BY id")) {
                    while (rs.next()) years.add(rs.getString(1).trim());
                }
            }
            if (years.isEmpty()) years.add(DEFAULT_YEAR);

            // ── 2. Create academic_years rows ────────────────────────────────
            try (PreparedStatement ps = conn.prepareStatement(
                    "INSERT OR IGNORE INTO academic_years (year_name) VALUES (?)")) {
                for (String y : years) {
                    ps.setString(1, y);
                    ps.executeUpdate();
                    ps.clearParameters();
                }
            }

            // Default year = first known year (used for subjects with no result context)
            String defaultYear = years.get(0);

            // ── 3. Rebuild subjects with semester_id ─────────────────────────
            if (legacySubjects) {
                // Add temporary mapping column
                try { st.execute("ALTER TABLE subjects ADD COLUMN semester_id INTEGER"); }
                catch (SQLException ignored) { /* already added */ }

                // Map every subject to (year, semester): prefer the year found in
                // the student's results for that subject; otherwise the default year.
                try (Statement q = conn.createStatement();
                     ResultSet rs = q.executeQuery("SELECT id, semester FROM subjects")) {
                    java.util.List<int[]> subjectRows = new java.util.ArrayList<>();
                    while (rs.next()) subjectRows.add(new int[]{rs.getInt(1), rs.getInt(2)});

                    try (PreparedStatement findYear = conn.prepareStatement(
                             "SELECT academic_year FROM exam_results WHERE subject_id = ? " +
                             "AND TRIM(COALESCE(academic_year,'')) != '' ORDER BY id LIMIT 1");
                         PreparedStatement getYearId = conn.prepareStatement(
                             "SELECT id FROM academic_years WHERE year_name = ?");
                         PreparedStatement getSemesterId = conn.prepareStatement(
                             "SELECT id FROM semesters WHERE academic_year_id = ? AND semester_number = ?");
                         PreparedStatement insSemester = conn.prepareStatement(
                             "INSERT OR IGNORE INTO semesters (academic_year_id, semester_number) VALUES (?, ?)");
                         PreparedStatement updSubject = conn.prepareStatement(
                             "UPDATE subjects SET semester_id = ? WHERE id = ?")) {

                        for (int[] row : subjectRows) {
                            int subjectId = row[0];
                            int semNo     = row[1];

                            String yearName = defaultYear;
                            findYear.setInt(1, subjectId);
                            try (ResultSet yrs = findYear.executeQuery()) {
                                if (yrs.next()) yearName = yrs.getString(1).trim();
                            }

                            getYearId.setString(1, yearName);
                            int yearId;
                            try (ResultSet yid = getYearId.executeQuery()) {
                                yid.next();
                                yearId = yid.getInt(1);
                            }

                            insSemester.setInt(1, yearId);
                            insSemester.setInt(2, semNo);
                            insSemester.executeUpdate();

                            getSemesterId.setInt(1, yearId);
                            getSemesterId.setInt(2, semNo);
                            int semesterId;
                            try (ResultSet sid = getSemesterId.executeQuery()) {
                                sid.next();
                                semesterId = sid.getInt(1);
                            }

                            updSubject.setInt(1, semesterId);
                            updSubject.setInt(2, subjectId);
                            updSubject.executeUpdate();
                        }
                    }
                }

                // Rebuild subjects table with proper constraints
                st.execute("""
                    CREATE TABLE subjects_new (
                        id           INTEGER PRIMARY KEY AUTOINCREMENT,
                        subject_code TEXT    NOT NULL,
                        subject_name TEXT    NOT NULL,
                        credit       INTEGER NOT NULL,
                        department   TEXT    NOT NULL,
                        semester_id  INTEGER REFERENCES semesters(id) ON DELETE CASCADE,
                        created_at   TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
                        UNIQUE(subject_code, semester_id)
                    )
                    """);
                st.execute("""
                    INSERT INTO subjects_new (id, subject_code, subject_name, credit, department, semester_id, created_at)
                    SELECT id, subject_code, subject_name, credit, department, semester_id, created_at FROM subjects
                    """);
                st.execute("DROP TABLE subjects");
                st.execute("ALTER TABLE subjects_new RENAME TO subjects");
            }

            // ── 4. Rebuild exam_results without academic_year/semester ───────
            if (legacyResults) {
                st.execute("""
                    CREATE TABLE exam_results_new (
                        id          INTEGER PRIMARY KEY AUTOINCREMENT,
                        student_id  INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
                        subject_id  INTEGER NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
                        marks       REAL    NOT NULL,
                        total_marks REAL    NOT NULL DEFAULT 100,
                        grade       TEXT    NOT NULL,
                        exam_type   TEXT    NOT NULL DEFAULT 'REGULAR',
                        created_at  TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
                    )
                    """);
                st.execute("""
                    INSERT INTO exam_results_new (id, student_id, subject_id, marks, total_marks, grade, exam_type, created_at)
                    SELECT id, student_id, subject_id, marks, total_marks, grade,
                           COALESCE(NULLIF(TRIM(exam_type), ''), 'REGULAR'), created_at
                    FROM exam_results
                    """);
                st.execute("DROP TABLE exam_results");
                st.execute("ALTER TABLE exam_results_new RENAME TO exam_results");
            }

            st.execute("PRAGMA foreign_key_check");
            conn.commit();
            conn.setAutoCommit(true);
            st.execute("PRAGMA foreign_keys = ON");
            System.out.println("Legacy schema migration completed.");

        } catch (SQLException e) {
            try { conn.rollback(); } catch (SQLException ignored) {}
            try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            throw e;
        }
    }

    private static boolean columnExists(Connection conn, String table, String column) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pragma_table_info(?) WHERE name = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, table);
            ps.setString(2, column);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    /**
     * Older databases define subjects.semester_id as NOT NULL, which forces
     * every subject to belong to a semester. The new workflow creates subjects
     * standalone and attaches them to a semester later, so the column must be
     * nullable. SQLite cannot drop a NOT NULL constraint in place — rebuild.
     */
    private static void migrateSubjectsNullableSemester(Connection conn) throws SQLException {
        Integer notNull = null;
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("PRAGMA table_info(subjects)")) {
            while (rs.next()) {
                if ("semester_id".equals(rs.getString("name"))) {
                    notNull = rs.getInt("notnull");
                    break;
                }
            }
        }
        if (notNull == null || notNull == 0) return; // table missing or already nullable

        System.out.println("Making subjects.semester_id optional (nullable)...");
        try (Statement st = conn.createStatement()) {
            st.execute("PRAGMA foreign_keys = OFF");
            conn.setAutoCommit(false);

            st.execute("""
                CREATE TABLE subjects_new (
                    id           INTEGER PRIMARY KEY AUTOINCREMENT,
                    subject_code TEXT    NOT NULL,
                    subject_name TEXT    NOT NULL,
                    credit       INTEGER NOT NULL,
                    department   TEXT    NOT NULL,
                    semester_id  INTEGER REFERENCES semesters(id) ON DELETE CASCADE,
                    created_at   TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
                    UNIQUE(subject_code, semester_id)
                )
                """);
            st.execute("""
                INSERT INTO subjects_new (id, subject_code, subject_name, credit, department, semester_id, created_at)
                SELECT id, subject_code, subject_name, credit, department, semester_id, created_at FROM subjects
                """);
            st.execute("DROP TABLE subjects");
            st.execute("ALTER TABLE subjects_new RENAME TO subjects");

            st.execute("PRAGMA foreign_key_check");
            conn.commit();
            conn.setAutoCommit(true);
            st.execute("PRAGMA foreign_keys = ON");
            System.out.println("subjects.semester_id is now optional.");
        } catch (SQLException e) {
            try { conn.rollback(); } catch (SQLException ignored) {}
            try { conn.setAutoCommit(true); } catch (SQLException ignored) {}
            throw e;
        }
    }

    private static void createIndexes(Statement stmt) throws SQLException {
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_results_student ON exam_results(student_id)");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_results_subject ON exam_results(subject_id)");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_semesters_year    ON semesters(academic_year_id)");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_subjects_semester ON subjects(semester_id)");
        // Drop indexes tied to the legacy flat columns
        stmt.execute("DROP INDEX IF EXISTS idx_results_year");
        stmt.execute("DROP INDEX IF EXISTS idx_unique_student_subject_year_sem");
        stmt.execute("DROP INDEX IF EXISTS idx_unique_student_subject_year_sem_type");
        // Clean up duplicate records if any exist before creating UNIQUE index
        stmt.execute("""
            DELETE FROM exam_results
            WHERE id NOT IN (
                SELECT MIN(id)
                FROM exam_results
                GROUP BY student_id, subject_id, exam_type
            )
            """);
        stmt.execute("CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_student_subject_type ON exam_results(student_id, subject_id, exam_type)");
    }

    // =========================================================================
    // Sample data
    // =========================================================================

    private static void insertSampleData(Connection conn) throws SQLException {
        // Only insert if tables are empty
        if (tableIsEmpty(conn, "users")) {
            insertSampleUsers(conn);
        }
        if (tableIsEmpty(conn, "students")) {
            insertSampleStudents(conn);
        }
        if (tableIsEmpty(conn, "academic_years")) {
            insertSampleAcademicStructure(conn);
        }
        if (tableIsEmpty(conn, "exam_results") && !tableIsEmpty(conn, "subjects")) {
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

    /**
     * Seeds: 2024-2025 -> Semester 1 & 2 with their subjects.
     * Mirrors the intended workflow:
     *   Step 1: academic year, Step 2: semesters, Step 3: subjects per semester.
     */
    private static void insertSampleAcademicStructure(Connection conn) throws SQLException {
        int yearId;
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO academic_years (year_name) VALUES (?)",
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, DEFAULT_YEAR);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                yearId = keys.getInt(1);
            }
        }

        int sem1Id;
        int sem2Id;
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO semesters (academic_year_id, semester_number) VALUES (?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, yearId);
            ps.setInt(2, 1);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) { keys.next(); sem1Id = keys.getInt(1); }

            ps.setInt(1, yearId);
            ps.setInt(2, 2);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) { keys.next(); sem2Id = keys.getInt(1); }
        }

        String sql = """
            INSERT INTO subjects (subject_code, subject_name, credit, department, semester_id)
            VALUES (?, ?, ?, ?, ?)
            """;
        Object[][] data = {
            {"CS101", "Java Programming",     4, "Computer Science",      sem1Id},
            {"CS102", "Database Systems",     3, "Computer Science",      sem1Id},
            {"CS105", "Web Development",      3, "Computer Science",      sem1Id},
            {"CS103", "Software Engineering", 3, "Computer Science",      sem2Id},
            {"CS104", "Computer Networks",    3, "Information Technology", sem2Id},
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

        // A few standalone subjects (not yet attached to any semester).
        // They can be attached from the academic year page.
        String unassignedSql = """
            INSERT INTO subjects (subject_code, subject_name, credit, department, semester_id)
            VALUES (?, ?, ?, ?, NULL)
            """;
        Object[][] pool = {
            {"CS201", "Artificial Intelligence",         3, "Computer Science"},
            {"CS202", "Mobile Application Development",  3, "Information Technology"},
        };
        try (PreparedStatement ps = conn.prepareStatement(unassignedSql)) {
            for (Object[] row : pool) {
                ps.setString(1, (String) row[0]);
                ps.setString(2, (String) row[1]);
                ps.setInt(3, (Integer) row[2]);
                ps.setString(4, (String) row[3]);
                ps.executeUpdate();
            }
        }
        System.out.println("  ✓ Sample academic year / semesters / subjects inserted.");
    }

    private static void insertSampleResults(Connection conn) throws SQLException {
        int[] studentIds = fetchIds(conn, "students");
        int[] subjectIds = fetchIds(conn, "subjects");

        if (studentIds.length == 0 || subjectIds.length == 0) return;

        String sql = """
            INSERT INTO exam_results (student_id, subject_id, marks, total_marks, grade)
            VALUES (?, ?, ?, ?, ?)
            """;

        // Sample pairs as (student index, subject index, marks, total).
        // Pairs referencing missing records are skipped so startup never
        // crashes on small databases.
        int[][] pairs = {
            {0, 0, 85, 100},
            {0, 1, 78, 100},
            {0, 2, 82, 100},
            {1, 0, 92, 100},
            {1, 1, 88, 100},
            {1, 4, 76, 100},
            {2, 0, 65, 100},
            {2, 3, 72, 100},
            {2, 4, 58, 100},
        };

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int[] pair : pairs) {
                int sIdx = pair[0], subjIdx = pair[1];
                if (sIdx >= studentIds.length || subjIdx >= subjectIds.length) continue;
                int sId = studentIds[sIdx];
                int subjId = subjectIds[subjIdx];
                double marks = pair[2];
                double total = pair[3];
                String grade = ExamResultServiceImpl.computeGrade(marks, total);
                ps.setInt(1, sId);
                ps.setInt(2, subjId);
                ps.setDouble(3, marks);
                ps.setDouble(4, total);
                ps.setString(5, grade);
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
