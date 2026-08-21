package server;

import common.Subject;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Subject operations.
 * Subjects are created standalone and may optionally belong to a semester
 * (which belongs to an academic year). semester_id is NULL while unassigned.
 */
public class SubjectDAO {

    private static final String SELECT_ALL = """
        SELECT sub.id, sub.subject_code, sub.subject_name, sub.credit,
               sub.department, sub.semester_id, sub.created_at,
               sm.academic_year_id, sm.semester_number, ay.year_name AS academic_year_name
        FROM subjects sub
        LEFT JOIN semesters sm      ON sub.semester_id = sm.id
        LEFT JOIN academic_years ay ON sm.academic_year_id = ay.id
        """;

    public List<Subject> findAll() {
        List<Subject> list = new ArrayList<>();
        // Unassigned subjects first, then by year/semester/code
        String sql = SELECT_ALL + """
            ORDER BY (sub.semester_id IS NULL) DESC, ay.year_name, sm.semester_number, sub.subject_code
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("SubjectDAO.findAll error: " + e.getMessage());
        }
        return list;
    }

    /**
     * Returns subjects that are not yet attached to any semester.
     */
    public List<Subject> findUnassigned() {
        List<Subject> list = new ArrayList<>();
        String sql = SELECT_ALL + " WHERE sub.semester_id IS NULL ORDER BY sub.subject_code";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("SubjectDAO.findUnassigned error: " + e.getMessage());
        }
        return list;
    }

    public List<Subject> findBySemester(int semesterId) {
        List<Subject> list = new ArrayList<>();
        String sql = SELECT_ALL + " WHERE sub.semester_id = ? ORDER BY sub.subject_code";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semesterId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("SubjectDAO.findBySemester error: " + e.getMessage());
        }
        return list;
    }

    public List<Subject> search(String keyword) {
        List<Subject> list = new ArrayList<>();
        String q = "%" + keyword.toLowerCase() + "%";
        String sql = SELECT_ALL + """
            WHERE lower(sub.subject_code) LIKE ? OR lower(sub.subject_name) LIKE ?
               OR lower(sub.department) LIKE ? OR lower(ay.year_name) LIKE ?
            ORDER BY (sub.semester_id IS NULL) DESC, ay.year_name, sm.semester_number, sub.subject_code
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, q); ps.setString(2, q); ps.setString(3, q); ps.setString(4, q);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("SubjectDAO.search error: " + e.getMessage());
        }
        return list;
    }

    public Subject findById(int id) {
        String sql = SELECT_ALL + " WHERE sub.id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            System.err.println("SubjectDAO.findById error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Returns true when the subject code is already used within the given
     * academic year (in any of its semesters). The same code may repeat
     * across different academic years.
     */
    public boolean codeExistsInAcademicYear(String subjectCode, int academicYearId, int excludeId) {
        String sql = """
            SELECT COUNT(*) FROM subjects sub
            JOIN semesters sm ON sub.semester_id = sm.id
            WHERE sm.academic_year_id = ? AND lower(sub.subject_code) = lower(?) AND sub.id != ?
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, academicYearId);
            ps.setString(2, subjectCode.trim());
            ps.setInt(3, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Returns true when the subject code is already used by another subject
     * that is not assigned to any semester.
     */
    public boolean codeExistsWithoutSemester(String subjectCode, int excludeId) {
        String sql = "SELECT COUNT(*) FROM subjects WHERE lower(subject_code) = lower(?) AND semester_id IS NULL AND id != ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subjectCode.trim());
            ps.setInt(2, excludeId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Attaches a subject to a semester.
     */
    public boolean assignToSemester(int subjectId, int semesterId) {
        String sql = "UPDATE subjects SET semester_id = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, semesterId);
            ps.setInt(2, subjectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.assignToSemester error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Removes a subject from its semester (semester_id becomes NULL).
     */
    public boolean detachFromSemester(int subjectId) {
        String sql = "UPDATE subjects SET semester_id = NULL WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, subjectId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.detachFromSemester error: " + e.getMessage());
            return false;
        }
    }

    public boolean insert(Subject s) {
        String sql = """
            INSERT INTO subjects (subject_code, subject_name, credit, department, semester_id)
            VALUES (?, ?, ?, ?, ?)
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setSubjectParams(ps, s);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.insert error: " + e.getMessage());
            return false;
        }
    }

    public boolean update(Subject s) {
        String sql = """
            UPDATE subjects SET subject_code=?, subject_name=?, credit=?, department=?, semester_id=?
            WHERE id=?
            """;
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setSubjectParams(ps, s);
            ps.setInt(6, s.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.update error: " + e.getMessage());
            return false;
        }
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM subjects WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("SubjectDAO.delete error: " + e.getMessage());
            return false;
        }
    }

    public int count() {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT COUNT(*) FROM subjects")) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            return 0;
        }
    }

    private void setSubjectParams(PreparedStatement ps, Subject s) throws SQLException {
        ps.setString(1, s.getSubjectCode().trim());
        ps.setString(2, s.getSubjectName().trim());
        ps.setInt(3, s.getCredit());
        ps.setString(4, s.getDepartment().trim());
        if (s.getSemesterId() > 0) ps.setInt(5, s.getSemesterId());
        else                       ps.setNull(5, java.sql.Types.INTEGER);
    }

    private Subject mapRow(ResultSet rs) throws SQLException {
        Subject s = new Subject(
            rs.getInt("id"),
            rs.getString("subject_code"),
            rs.getString("subject_name"),
            rs.getInt("credit"),
            rs.getString("department"),
            rs.getInt("semester_id"),
            AcademicYearDAO.parseDate(rs.getString("created_at"))
        );
        int yearId = rs.getInt("academic_year_id");
        if (!rs.wasNull()) s.setAcademicYearId(yearId);
        s.setAcademicYearName(rs.getString("academic_year_name"));
        int semNo = rs.getInt("semester_number");
        if (!rs.wasNull()) s.setSemesterNumber(semNo);
        return s;
    }
}
