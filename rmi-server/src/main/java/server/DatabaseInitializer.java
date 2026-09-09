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
            migrateSubjectsSemesterNumber(conn);
            autoLinkUnassignedSubjects(conn);
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
                id              INTEGER PRIMARY KEY AUTOINCREMENT,
                subject_code    TEXT    NOT NULL,
                subject_name    TEXT    NOT NULL,
                credit          INTEGER NOT NULL,
                department      TEXT    NOT NULL,
                semester_id     INTEGER REFERENCES semesters(id) ON DELETE CASCADE,
                semester_number INTEGER DEFAULT NULL,
                created_at      TEXT    NOT NULL DEFAULT (datetime('now','localtime')),
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

    /**
     * Adds the semester_number column to subjects table if it does not exist.
     * This column stores the preferred semester number (1-8) set at subject
     * creation, used for auto-linking when an academic year is created.
     */
    private static void migrateSubjectsSemesterNumber(Connection conn) throws SQLException {
        if (columnExists(conn, "subjects", "semester_number")) return;
        System.out.println("Adding subjects.semester_number column...");
        try (Statement st = conn.createStatement()) {
            st.execute("ALTER TABLE subjects ADD COLUMN semester_number INTEGER DEFAULT NULL");
        }
        System.out.println("subjects.semester_number added.");
    }

    /**
     * Links any unassigned subjects (semester_id IS NULL) to existing semesters
     * if their stored semester_number matches a semester number in an academic year.
     */
    private static void autoLinkUnassignedSubjects(Connection conn) throws SQLException {
        // 1. Link unassigned subjects (semester_id IS NULL)
        String sql = """
            SELECT sub.id, sub.semester_number, sm.id AS target_sem_id
            FROM subjects sub
            JOIN semesters sm ON sub.semester_number = sm.semester_number
            WHERE sub.semester_id IS NULL
            """;
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            java.util.List<int[]> updates = new java.util.ArrayList<>();
            while (rs.next()) {
                updates.add(new int[]{rs.getInt("id"), rs.getInt("target_sem_id")});
            }
            if (!updates.isEmpty()) {
                System.out.println("Auto-linking " + updates.size() + " unassigned subjects to existing semesters...");
                try (PreparedStatement ps = conn.prepareStatement("UPDATE subjects SET semester_id = ? WHERE id = ?")) {
                    for (int[] pair : updates) {
                        ps.setInt(1, pair[1]);
                        ps.setInt(2, pair[0]);
                        ps.executeUpdate();
                    }
                }
            }
        }

        // 2. Ensure every academic year semester has copies of all subjects belonging to its semester_number
        String sqlMissing = """
            SELECT sm.id AS sem_id, sm.academic_year_id, sm.semester_number,
                   sub.subject_code, sub.subject_name, sub.credit, sub.department
            FROM semesters sm
            JOIN subjects sub ON (
                sub.semester_number = sm.semester_number
                OR sub.id IN (SELECT s2.id FROM subjects s2 JOIN semesters sm2 ON s2.semester_id = sm2.id WHERE sm2.semester_number = sm.semester_number)
            )
            WHERE NOT EXISTS (
                SELECT 1 FROM subjects s3
                WHERE s3.semester_id = sm.id AND lower(s3.subject_code) = lower(sub.subject_code)
            )
            GROUP BY sm.id, lower(sub.subject_code)
            """;
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sqlMissing)) {
            java.util.List<Object[]> toInsert = new java.util.ArrayList<>();
            while (rs.next()) {
                toInsert.add(new Object[]{
                    rs.getString("subject_code"),
                    rs.getString("subject_name"),
                    rs.getInt("credit"),
                    rs.getString("department"),
                    rs.getInt("sem_id"),
                    rs.getInt("semester_number")
                });
            }
            if (!toInsert.isEmpty()) {
                System.out.println("Auto-linking " + toInsert.size() + " missing subjects across academic years...");
                String insSql = "INSERT INTO subjects (subject_code, subject_name, credit, department, semester_id, semester_number) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insSql)) {
                    for (Object[] row : toInsert) {
                        ps.setString(1, (String) row[0]);
                        ps.setString(2, (String) row[1]);
                        ps.setInt(3, (Integer) row[2]);
                        ps.setString(4, (String) row[3]);
                        ps.setInt(5, (Integer) row[4]);
                        ps.setInt(6, (Integer) row[5]);
                        ps.executeUpdate();
                    }
                }
            }
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
    // Initial Seed Data (Admin Only)
    // =========================================================================

    private static void insertSampleData(Connection conn) throws SQLException {
        if (tableIsEmpty(conn, "users")) {
            insertDefaultAdminUser(conn);
        }

        if (tableIsEmpty(conn, "students")) {
            seedFullDataset(conn);
        }
    }

    private static boolean tableIsEmpty(Connection conn, String table) throws SQLException {
        try (Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM " + table)) {
            return rs.next() && rs.getInt(1) == 0;
        }
    }

    private static void insertDefaultAdminUser(Connection conn) throws SQLException {
        String adminHash = BCrypt.hashpw("admin123", BCrypt.gensalt(12));

        String sql = "INSERT OR IGNORE INTO users (email, password, role) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "admin@example.com");
            ps.setString(2, adminHash);
            ps.setString(3, "ADMIN");
            ps.executeUpdate();
        }
        System.out.println("  ✓ Default admin user inserted (admin@example.com / admin123).");
    }

    private static class SubjectSeed {
        String code; String name; int credit; String dept; int semId; int semNo;
        SubjectSeed(String c, String n, int cr, String d, int sId, int sNo) {
            code=c; name=n; credit=cr; dept=d; semId=sId; semNo=sNo;
        }
    }

    public static void seedFullDataset(Connection conn) throws SQLException {
        System.out.println("Seeding 50 students, academic structure, and exam results...");

        // 1. Insert Academic Years
        int year1Id = getOrInsertAcademicYear(conn, "2023-2024");
        int year2Id = getOrInsertAcademicYear(conn, "2024-2025");

        // 2. Insert Semesters
        int sem1Id = getOrInsertSemester(conn, year1Id, 1);
        int sem2Id = getOrInsertSemester(conn, year1Id, 2);
        int sem3Id = getOrInsertSemester(conn, year2Id, 3);
        int sem4Id = getOrInsertSemester(conn, year2Id, 4);

        // 3. Insert Subjects for each semester
        java.util.List<SubjectSeed> subjectSeeds = java.util.List.of(
            // Semester 1
            new SubjectSeed("CS101", "Programming Fundamentals", 3, "Computer Science", sem1Id, 1),
            new SubjectSeed("CS102", "Discrete Mathematics", 3, "Mathematics", sem1Id, 1),
            new SubjectSeed("CS103", "Digital Logic Design", 3, "Hardware Systems", sem1Id, 1),
            new SubjectSeed("ENG101", "Technical English", 2, "Languages", sem1Id, 1),

            // Semester 2
            new SubjectSeed("CS104", "Data Structures & Algorithms", 4, "Computer Science", sem2Id, 2),
            new SubjectSeed("CS105", "Object-Oriented Programming", 3, "Computer Science", sem2Id, 2),
            new SubjectSeed("CS106", "Computer Architecture", 3, "Hardware Systems", sem2Id, 2),
            new SubjectSeed("MTH102", "Linear Algebra & Calculus", 3, "Mathematics", sem2Id, 2),

            // Semester 3
            new SubjectSeed("CS201", "Database Management Systems", 4, "Computer Science", sem3Id, 3),
            new SubjectSeed("CS202", "Web Engineering", 3, "Software Engineering", sem3Id, 3),
            new SubjectSeed("CS203", "Operating Systems", 3, "Computer Science", sem3Id, 3),
            new SubjectSeed("CS204", "Software Engineering", 3, "Software Engineering", sem3Id, 3),

            // Semester 4
            new SubjectSeed("CS205", "Computer Networks", 3, "Computer Science", sem4Id, 4),
            new SubjectSeed("CS206", "Artificial Intelligence", 3, "Artificial Intelligence", sem4Id, 4),
            new SubjectSeed("CS207", "Cyber Security", 3, "Information Technology", sem4Id, 4),
            new SubjectSeed("CS208", "Cloud Computing", 3, "Information Technology", sem4Id, 4)
        );

        java.util.List<Integer> subjectIds = new java.util.ArrayList<>();
        String insSubSql = "INSERT OR IGNORE INTO subjects (subject_code, subject_name, credit, department, semester_id, semester_number) VALUES (?, ?, ?, ?, ?, ?)";
        String selSubSql = "SELECT id FROM subjects WHERE subject_code = ? AND semester_id = ?";

        for (SubjectSeed ss : subjectSeeds) {
            try (PreparedStatement ps = conn.prepareStatement(insSubSql)) {
                ps.setString(1, ss.code);
                ps.setString(2, ss.name);
                ps.setInt(3, ss.credit);
                ps.setString(4, ss.dept);
                ps.setInt(5, ss.semId);
                ps.setInt(6, ss.semNo);
                ps.executeUpdate();
            }
            try (PreparedStatement ps = conn.prepareStatement(selSubSql)) {
                ps.setString(1, ss.code);
                ps.setInt(2, ss.semId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) subjectIds.add(rs.getInt(1));
                }
            }
        }
        System.out.println("  ✓ Academic years, semesters, and " + subjectIds.size() + " subjects ready.");

        // 4. Seed 50 Students & User Accounts
        String[] studentNames = {
            "Aung Aung", "Kyaw Kyaw", "Thandar Htoo", "Su Su Hlaing", "Min Maw",
            "Alexander Smith", "Emma Watson", "Ethan Brown", "Olivia Davis", "Noah Wilson",
            "Liam Miller", "Sophia Taylor", "Benjamin Anderson", "Isabella Thomas", "Lucas Jackson",
            "Mia White", "Mason Harris", "Charlotte Martin", "Ethan Clark", "Amelia Lewis",
            "James Robinson", "Harper Walker", "Alexander Hall", "Evelyn Young", "Henry Allen",
            "Abigail Wright", "Sebastian King", "Emily Scott", "Jack Green", "Elizabeth Baker",
            "Owen Adams", "Camila Nelson", "Daniel Hill", "Ella Ramirez", "Matthew Campbell",
            "Scarlett Mitchell", "Jackson Roberts", "Victoria Carter", "David Phillips", "Grace Evans",
            "Joseph Turner", "Chloe Torres", "Samuel Parker", "Penelope Flores", "Sebastian Rivera",
            "Layla Morris", "Logan Nguyen", "Zoey Murphy", "Jayden Cook", "Zin Mar Phyo"
        };

        String defaultStudentHash = BCrypt.hashpw("student123", BCrypt.gensalt(12));

        String insStuSql = "INSERT OR IGNORE INTO students (student_id, name, email, phone, gender) VALUES (?, ?, ?, ?, ?)";
        String selStuSql = "SELECT id FROM students WHERE student_id = ?";
        String insUserSql = "INSERT OR IGNORE INTO users (email, password, role) VALUES (?, ?, ?)";

        java.util.List<Integer> studentDbIds = new java.util.ArrayList<>();

        for (int i = 0; i < 50; i++) {
            String stuIdStr = String.format("STU-2024-%03d", i + 1);
            String name = studentNames[i];
            String email = String.format("student%02d@example.com", i + 1);
            String phone = String.format("09-450000%03d", i + 1);
            String gender = (i % 2 == 0) ? "Male" : "Female";

            try (PreparedStatement ps = conn.prepareStatement(insStuSql)) {
                ps.setString(1, stuIdStr);
                ps.setString(2, name);
                ps.setString(3, email);
                ps.setString(4, phone);
                ps.setString(5, gender);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(selStuSql)) {
                ps.setString(1, stuIdStr);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        studentDbIds.add(rs.getInt(1));
                    }
                }
            }

            // User account for student login
            try (PreparedStatement ps = conn.prepareStatement(insUserSql)) {
                ps.setString(1, email);
                ps.setString(2, defaultStudentHash);
                ps.setString(3, "STUDENT");
                ps.executeUpdate();
            }
        }

        System.out.println("  ✓ 50 students & student user accounts created (Password: student123).");

        // 5. Seed Exam Results for each student
        String insResSql = "INSERT OR IGNORE INTO exam_results (student_id, subject_id, marks, total_marks, grade, exam_type) VALUES (?, ?, ?, ?, ?, ?)";
        int resultCount = 0;

        for (int sIdx = 0; sIdx < studentDbIds.size(); sIdx++) {
            int studentDbId = studentDbIds.get(sIdx);

            for (int subIdx = 0; subIdx < subjectIds.size(); subIdx++) {
                int subjectDbId = subjectIds.get(subIdx);

                // Deterministic marks formula for rich grade distribution (A+, A, A-, B+, B, B-, C+, C, D, F)
                double baseMarks = 52.0 + ((sIdx * 11 + subIdx * 7 + (sIdx * subIdx)) % 47);
                if (baseMarks > 98.0) baseMarks = 98.0;
                double marks = Math.round(baseMarks * 10.0) / 10.0;
                String grade = ExamResultServiceImpl.computeGrade(marks, 100.0);

                try (PreparedStatement ps = conn.prepareStatement(insResSql)) {
                    ps.setInt(1, studentDbId);
                    ps.setInt(2, subjectDbId);
                    ps.setDouble(3, marks);
                    ps.setDouble(4, 100.0);
                    ps.setString(5, grade);
                    ps.setString(6, "REGULAR");
                    ps.executeUpdate();
                    resultCount++;
                }
            }
        }

        System.out.println("  ✓ " + resultCount + " exam results inserted across 50 students (" + subjectIds.size() + " subjects each).");
    }

    private static int getOrInsertAcademicYear(Connection conn, String yearName) throws SQLException {
        String ins = "INSERT OR IGNORE INTO academic_years (year_name) VALUES (?)";
        String sel = "SELECT id FROM academic_years WHERE year_name = ?";
        try (PreparedStatement ps = conn.prepareStatement(ins)) {
            ps.setString(1, yearName);
            ps.executeUpdate();
        }
        try (PreparedStatement ps = conn.prepareStatement(sel)) {
            ps.setString(1, yearName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Could not get or insert academic year: " + yearName);
    }

    private static int getOrInsertSemester(Connection conn, int academicYearId, int semesterNumber) throws SQLException {
        String ins = "INSERT OR IGNORE INTO semesters (academic_year_id, semester_number) VALUES (?, ?)";
        String sel = "SELECT id FROM semesters WHERE academic_year_id = ? AND semester_number = ?";
        try (PreparedStatement ps = conn.prepareStatement(ins)) {
            ps.setInt(1, academicYearId);
            ps.setInt(2, semesterNumber);
            ps.executeUpdate();
        }
        try (PreparedStatement ps = conn.prepareStatement(sel)) {
            ps.setInt(1, academicYearId);
            ps.setInt(2, semesterNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        throw new SQLException("Could not get or insert semester: " + semesterNumber);
    }

    public static void main(String[] args) {
        System.out.println("Executing standalone DatabaseInitializer seed task...");
        initialize();
        System.out.println("Done!");
    }
}

